package org.projectsnooze.impl.generator
{
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;

	public class DDLGeneratorImpl implements DDLGenerator
	{
		private var _entityDataMapProvider : EntityDataMapProvider;
		
		public function DDLGeneratorImpl()
		{
		}

		public function setEntityDataMapProvider(entityDataMapProvider:EntityDataMapProvider):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function getEntityDataMapProvider():EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		public function getDDL():Statement
		{
			var sqlSkeleton : String = "";
			var params : Object = {};
			 
			for ( var iterator : Iterator = getEntityDataMapProvider().getIterator() ; iterator.hasNext() ; )
			{
				var entityDataMap : EntityDataMap = iterator.next() as EntityDataMap;
				sqlSkeleton += "\n CREATE TABLE IF NOT EXISTS " + ":" + entityDataMap.getTableName() + " ( "; 
				params[ ":" + entityDataMap.getTableName() ] = entityDataMap.getTableName();
				
				sqlSkeleton += getPrimaryKey ( entityDataMap , params );
				sqlSkeleton += getForignKeys ( entityDataMap , params );
				sqlSkeleton += getNatrualProperties( entityDataMap , params );
				
				sqlSkeleton += " );";
			}
			
			var statement : Statement = new StatementImpl()
			statement.setSqlSkeleton( sqlSkeleton );
			statement.setParameters( params );
			return statement;
		}
		
		private function getPrimaryKey ( entityDataMap : EntityDataMap , params : Object ) : String
		{
			var sqlSkeleton : String = "";
			
			var mapping : NameTypeMapping = entityDataMap.getPrimaryKey();
			sqlSkeleton += ":" + mapping.getLowerCaseName() + " " + mapping.getType().getSQLType() + " PRIMARY KEY AUTOINCREMENT";
			params[ ":" + mapping.getLowerCaseName() ] = mapping.getLowerCaseName();
			
			return sqlSkeleton;
		}
		
		private function getForignKeys ( entityDataMap : EntityDataMap , params : Object ) : String
		{
			var sqlSkeleton : String = "";
			var first : Boolean = true;
			
			for ( var iterator : Iterator = entityDataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					if ( first ) sqlSkeleton += " , "; 
					first = false;
				
					sqlSkeleton += ":" + relationship.getEntityDataMap().getTableName().toLocaleLowerCase() + "_id " + relationship.getEntityDataMap().getPrimaryKey().getType().getSQLType();
					params[ ":" + relationship.getEntityDataMap().getTableName().toLocaleLowerCase() + "_id" ] = relationship.getEntityDataMap().getTableName().toLocaleLowerCase() + "_id";
					
					if ( iterator.hasNext() ) sqlSkeleton += " , "; 
				}
			}
			
			return sqlSkeleton;
		}
		
		private function getNatrualProperties ( entityDataMap : EntityDataMap , params : Object ) : String
		{
			var sqlSkeleton : String = "";
			var first : Boolean = true;
			
			for ( var iterator : Iterator = entityDataMap.getPropertyIterator() ; iterator.hasNext() ; )
			{
				if ( first ) sqlSkeleton += " , "; 
				first = false;
				
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				sqlSkeleton += ":" + mapping.getLowerCaseName() + " " + mapping.getType().getSQLType();
				params[ ":" + mapping.getLowerCaseName() ] = mapping.getLowerCaseName();
				
				if ( iterator.hasNext() ) sqlSkeleton += " , ";
			}
			return sqlSkeleton;
		}
		
	}
}