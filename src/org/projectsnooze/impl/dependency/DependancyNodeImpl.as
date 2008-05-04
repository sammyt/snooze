package org.projectsnooze.impl.dependency
{
	import mx.collections.ArrayCollection;
	
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.impl.patterns.ArrayCollectionIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.patterns.Observer;
	import org.projectsnooze.scheme.EntityDataMap;

	public class DependancyNodeImpl implements DependencyNode
	{
		private var _dependencies : ArrayCollection;
		private var _observers : ArrayCollection;
		private var _entityDataMap : EntityDataMap;
		private var _entity : Object;
		
		public function DependancyNodeImpl()
		{
			_observers = new ArrayCollection();
			_dependencies = new ArrayCollection();
		}

		public function registerObserver(observer:Observer):void
		{
			_observers.addItem( observer );
		}
		
		public function execute():void
		{
		}
		
		public function update(obj:Object=null):void
		{
			var dependencyNode : DependencyNode = obj as DependencyNode;
			
		}
		
		public function removeObserver(observer:Observer):void
		{
			_observers.removeItemAt( _observers.getItemIndex( observer ) );
		}
		
		public function notifyObservers(obj:Object=null):void
		{
			for( var iterator : Iterator = new ArrayCollectionIterator( _observers ); iterator.hasNext() ; )
			{
				var observer : Observer = iterator.next() as Observer;
				observer.update( this );
			}
		}
		
		public function isComplete () : Boolean
		{
			return false;
		}
		
		public function isDependent():Boolean
		{
			return _dependencies.length > 0;
		}
		
		public function dependenciesAreMet():Boolean
		{
			var depsMet : Boolean = true;
			
			for ( var iterator : Iterator = new ArrayCollectionIterator( _dependencies ) ; iterator.next() ; )
			{
				var depNode : DependencyNode = iterator.next() as DependencyNode;
				if ( ! depNode.isComplete() ) 
				{
					depsMet = false;
				}
			}
			
			return depsMet;
		}
		
		public function addDependentNode ( dependencyNode : DependencyNode ) : void
		{
			registerObserver( dependencyNode );
		}
		
		public function addDependency ( dependencyNode : DependencyNode ) : void
		{
			_dependencies.addItem( dependencyNode );
		}
		
		public function setEnity ( entity : Object ) : void
		{
			_entity = entity;
		}
		
		public function getEntity () : Object
		{
			return _entity;
		}
		
		public function setEntityDataMap ( entityDataMap : EntityDataMap ) : void
		{
			_entityDataMap = entityDataMap;
		}
		
		public function getEntityDataMap () : EntityDataMap
		{
			return _entityDataMap;			
		}
		
	}
}