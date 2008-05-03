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
		private var _observers : ArrayCollection;
		private var _entityDataMap : EntityDataMap;
		private var _entity : Object;
		
		public function DependancyNodeImpl()
		{
			_observers = new ArrayCollection();
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
			var deoendancyNode : DependencyNode = obj as DependencyNode;
			
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
		
		public function isDependent():Boolean
		{
			return false;
		}
		
		public function dependenciesAreMet():Boolean
		{
			return false;
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