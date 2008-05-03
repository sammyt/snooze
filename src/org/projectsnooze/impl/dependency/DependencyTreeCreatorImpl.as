package org.projectsnooze.impl.dependency
{
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.impl.session.DependancyNodeImpl;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.session.DependencyNode;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _typeUtils : TypeUtils;
		
		public function DependencyTreeCreatorImpl()
		{
		}
		
		
		public function getSaveDependencyTree ( entity : Object ) : Array
		{
			trace( "getSaveDependencyTree " + entity );
			var saveTree : Array = new Array();
			buildNodes ( entity , saveTree );
			return saveTree;
		}
		
		private function buildNodes ( entity : Object , list : Array , prevNode : DependencyNode = null , prevRelationship : Relationship = null ) : void
		{
			trace ( "buildNodes " + entity + " , " + list + " , " + prevNode + " , " + prevRelationship );
			var dataMap : EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity ); 
			
			var node : DependencyNode = new DependancyNodeImpl();
			node.setEntityDataMap( dataMap );
			node.setEnity( entity );
			list.push( node );
			
			if ( prevNode != null && prevRelationship != null )
			{
				if ( prevRelationship.getType().getForeignKeyContainer() )
				{
					node.registerObserver( prevNode );
				}
				else
				{
					prevNode.registerObserver( node );
				}
			}
			
			trace ( "DataMap " + dataMap.getTableName() );
			for ( var iterator : Iterator = dataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				trace( "relationship " + relationship.getType().getName() );
				//trace( "get" + relationship.getPropertyName() + " , " + entity );
				
				var value : * = entity[ "get" + relationship.getPropertyName() ]();
				if ( value != null )
				{
					if ( getTypeUtils().isCollection( value )  )
					{
						for ( var i : Iterator = new SmartIterator( value ) ; i.hasNext() ; )
						{
							buildNodes( i.next() , list , node , relationship );
						}
					}
					else
					{
						buildNodes( value , list , node , relationship );
					}
				}
			}
		}
		
		private function isEntityAlreadyInDependecnyTree ( entity : Object , list : Array ) : Boolean
		{
			for( var iterator : Iterator = new ArrayIterator( list ) ; iterator.hasNext() ; )
			{
				var dep : DependencyNode = iterator.next() as DependencyNode;
				if ( dep.getEntity() == entity ) return true
			}
			return false;
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