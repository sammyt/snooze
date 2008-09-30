package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.collections.DictionaryIterator;
	
	import flash.utils.Dictionary;
	
	public class MetaDataImpl implements MetaData
	{
		protected var _name:String;
		protected var _map:Dictionary;
		
		public function MetaDataImpl()
		{
		}
		
		public function getName():String
		{
			return _name;
		}
		
		public function setName( name:String ):void
		{
			_name = name;
		}
		
		public function addArg( key:String, value:String ):void
		{
			map[ key ] = value;
		}
		
		public function hasArg( key:String ):Boolean
		{
			return getArgByKey( key ) != null;
		}
		
		public function getArgByKey( key:String ):String
		{
			return map[ key ];
		}
		
		public function getArgsIterator():Iterator
		{
			return new DictionaryIterator( map );
		}
		
		protected function get map():Dictionary
		{
			if( !_map )
			{
				_map = new Dictionary()
			}
			return _map;
		}
	}
}

