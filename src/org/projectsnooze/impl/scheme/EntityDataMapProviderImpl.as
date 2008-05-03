package org.projectsnooze.impl.scheme
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.projectsnooze.impl.patterns.DictionaryIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public class EntityDataMapProviderImpl implements EntityDataMapProvider
	{
		private var _dataMaps : Dictionary; 
		
		public function EntityDataMapProviderImpl () 
		{
			_dataMaps = new Dictionary ();
		}
		
		public function getEntityDataMap ( entity : Object ) : EntityDataMap
		{
			var name : String = describeType( entity ).@name;
			return getEntityDataMapByClassName ( name );
		}
		
		public function getEntityDataMapByClassName ( name : String ) : EntityDataMap
		{
			return _dataMaps[ name ] as EntityDataMap;
		}
		
		public function setEntityDataMap ( name : String , dataMap : EntityDataMap ) : void
		{
			_dataMaps[ name ] = dataMap;
		}
		
		public function getIterator () : Iterator
		{
			return new DictionaryIterator( _dataMaps );
		}
	}
}