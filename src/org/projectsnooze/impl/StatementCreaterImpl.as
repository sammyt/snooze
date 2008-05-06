package org.projectsnooze.impl
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.StatementCreator;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.generator.StatementImpl;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;

	public class StatementCreaterImpl implements StatementCreator
	{
		private static var logger : ILogger = Log.getLogger( "StatementCreaterImpl" );
		
		private const ValuePrefix : String = "_value";
		
		public function StatementCreaterImpl()
		{
		}

		public function getSelectSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		public function getInsertSql( data : EntityDataMap ):Statement
		{
			var statement : Statement = new StatementImpl();
			var sql : String = "";
			
			sql = "INSERT INTO "; 
			sql += data.getTableName();
			sql +=  " (";
			
			var names : Array = new Array();
			addPrimaryKey( names , data );
			addForeignKeys( names , data );
			addArgList( names , data );
			
			sql += getCsvFromArray( names );
			sql += ") ";
			sql += " VALUES ("
			
			var valueNames : Array = new Array();
			addPrimaryKey( valueNames , data , ValuePrefix );
			addForeignKeys( valueNames , data , ValuePrefix );
			addArgList( valueNames , data , ValuePrefix );
			
			sql += getCsvFromArray( valueNames );
			sql += ");";
			
			statement.setSqlSkeleton( sql );
			
			return statement;
		}
		
		public function getUpdateSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		public function getDeleteSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		private function addPrimaryKey ( values : Array , data : EntityDataMap , postFix : String = "" ) : String
		{
			var mapping : NameTypeMapping = data.getPrimaryKey()
			values.push( mapping.getName() + postFix );
			
			return getCsvFromArray( values );
		}
		
		private function addForeignKeys ( values : Array , data : EntityDataMap , postFix : String = "" ) : String
		{
			for ( var iterator : Iterator = data.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var name : String = relationship.getEntityDataMap().getTableName() + "_" + relationship.getPropertyName();
					values.push( name + postFix );
				}
			}
			return getCsvFromArray( values );
		}
		
		private function addArgList ( values : Array , data : EntityDataMap , postFix : String = "" ) : String
		{
			for ( var iterator : Iterator = data.getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				if ( ! mapping.isPrimaryKey() )
				{
					values.push( mapping.getName() + postFix );
				}
			}
			return  getCsvFromArray( values );;
		}
		
		private function getCsvFromArray ( list : Array ) : String
		{
			var csv : String = "";
			for ( var i : int = 0 ; i < list.length ; i++ )
			{
				csv += list[i];
				csv += i < list.length - 1 ? "," : "";
			}
			return csv;
		}
	}
}