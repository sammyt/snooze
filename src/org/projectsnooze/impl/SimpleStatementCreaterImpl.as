package org.projectsnooze.impl
{
	import flash.data.SQLStatement;
	
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.StatementCreator;
	import org.projectsnooze.patterns.Iterator;

	public class SimpleStatementCreaterImpl implements StatementCreator
	{
		private const NamePrefix : String = "_name";
		private const ValuePrefix : String = "_value";
		
		public function SimpleStatementCreaterImpl()
		{
		}

		public function getSelectSql( data : EntityDataMap ):SQLStatement
		{
			return null;
		}
		
		public function getInsertSql( data : EntityDataMap ):SQLStatement
		{
			var sql : SQLStatement = new SQLStatement ();
			sql.text = "INSERT INTO :TableName (";
			sql.text += getValueList( data , NamePrefix , false );
			sql.text += ") ";
			sql.text += " VALUES ("
			sql.text += getValueList( data , ValuePrefix , false );
			sql.text += ");";
			
			insertData( data , sql , true , false );
			insertData( data , sql , false , false );
			
			return sql;
		}
		
		public function getUpdateSql( data : EntityDataMap ):SQLStatement
		{
			return null;
		}
		
		public function getDeleteSql( data : EntityDataMap ):SQLStatement
		{
			return null;
		}
		
		private function getValueList ( data : EntityDataMap , postFix : String , withId : Boolean = true ) : String
		{
			var values : Array = new Array();
			for ( var iterator : Iterator = data.getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				if ( ! mapping.isPrimaryKey() || withId )
				{
					values.push( ":" + mapping.getName() + postFix );
				}
			}
			return getCsvFromArray( values );
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
		
		private function insertData ( data : EntityDataMap , statement : SQLStatement , useValues : Boolean = true , withId : Boolean = true ) : void
		{
			var postfix : String = useValues ? ValuePrefix : NamePrefix;
			for ( var iterator : Iterator = data.getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				if ( ! mapping.isPrimaryKey() || withId )
				{
				//	statement.parameters[ ":" + mapping.getName() + postfix ] = useValues ?  mapping.getValue() : mapping.getName();
				}
			}
			statement.parameters[":TableName"] = data.getTableName();
		}
	}
}