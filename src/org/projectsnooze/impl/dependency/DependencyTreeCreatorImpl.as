package org.projectsnooze.impl.dependency
{
	import flash.utils.describeType;
	
	import mx.logging.ILogger;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.utils.SnoozeLog;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		private static var logger : ILogger;
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _typeUtils : TypeUtils;
		
		public function DependencyTreeCreatorImpl()
		{
			logger = SnoozeLog.getLogger ( this );
		}
		
		
		public function getSaveDependencyTree ( entity : Object ) : Array
		{
			var saveTree : Array = new Array();
			
			createDataMap( entity , saveTree );
			
			return saveTree;
		}
		
		private function createDataMap ( entity : Object , tree : Array , lastDepNode : DependencyNode = null , isPrevEntityFKContiner : Boolean = true ) : void
		{
			var dataMap : EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			var depNode : DependencyNode = new DependancyNodeImpl();
			depNode.setEnity( entity );
			depNode.setEntityDataMap( dataMap );
			
			if ( isPrevEntityFKContiner && lastDepNode )
			{
				depNode.registerObserver( lastDepNode );
			}
			else if ( lastDepNode )
			{
				lastDepNode.registerObserver( depNode );
			}
			
			tree.push( entity );
			
			for ( var iterator : Iterator = dataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship  : Relationship = iterator.next() as Relationship;
				
				if ( relationship.getIsEntityContainer() )
				{
					var getter : Function = entity[ "get" + relationship.getPropertyName() ] as Function;
					var data : * = getter.apply( entity );
					
					if ( getTypeUtils().isCollection( data ) )
					{
						for ( var i : Iterator = new SmartIterator( data ) ; i.hasNext() ; )
						{
							createDataMap( i.next() , tree , depNode , relationship.getType().getForeignKeyContainer() );
						}
					}
					else
					{
						createDataMap( data , tree , depNode , relationship.getType().getForeignKeyContainer() );
					}
				}
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