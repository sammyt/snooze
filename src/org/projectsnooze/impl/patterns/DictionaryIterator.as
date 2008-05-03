package org.projectsnooze.impl.patterns
{
	import flash.utils.Dictionary;
	
	import org.projectsnooze.patterns.Iterator;

	public class DictionaryIterator implements Iterator
	{
		private var _dict : Dictionary;
		private var _iterator : ArrayIterator;
		
		public function DictionaryIterator( dict : Dictionary )
		{
			_dict = dict;
			
			var keys : Array = new Array();
			for ( var key : String in _dict )
			{
				keys.push( key );
			}
			_iterator = new ArrayIterator( keys );
		}

		public function hasNext():Boolean
		{
			return _iterator.hasNext();
		}
		
		public function next():Object
		{
			return _dict[ _iterator.next() ];
		}
		
	}
}