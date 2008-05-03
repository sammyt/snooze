package org.projectsnooze.impl.dependency
{
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _typeUtils : TypeUtils;
		
		public function DependencyTreeCreatorImpl()
		{
		}
		
		
		public function getSaveDependencyTree ( entity : Object ) : Array
		{
			var saveTree : Array = new Array();
			
			// need to create DependencyNode for each entity
			
			
			
			return saveTree;
		}
		
		public function getAllContainedEntities ( entity : Object ) : Array
		{
			var entities : Array = new Array();
			entities.push( entity );
			var dataMap : EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			for ( var iterator : Iterator = dataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var getter : Function = entity[ "get" + relationship.getPropertyName() ] as Function;
					if ( getter != null )
					{
						var obj : * = getter();
						if ( ! getTypeUtils().isCollection( obj ) )
						{
							entities.push( obj );
						}
						else 
						{
							addContainedEntities( obj , entities );
						}
					}
				}
			}
			return entities;
		}
		
		public function addContainedEntities ( entitiesToAdd : * , list : Array ) : void
		{
			for( var iterator : Iterator = new SmartIterator ( entitiesToAdd ) ; iterator.hasNext() ; )
			{
				var entity : * = iterator.next();
				list.push( entity );
			}
		}
		
		public function setEntityDataMapProvider ( entityDataMap : EntityDataMapProvider ) : void
		{
			_entityDataMapProvider = entityDataMap;
		}
		
		public function getEntitDataMapProvider ( ) : EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		public function setTypeUtils ( typeUtils : TypeUtils ) : void
		{
			_typeUtils = typeUtils;
		}
		
		public function getTypeUtils () : TypeUtils
		{
			return _typeUtils;
		}

	}
}