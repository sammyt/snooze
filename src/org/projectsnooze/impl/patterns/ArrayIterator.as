package org.projectsnooze.impl.patterns
{
	import org.projectsnooze.patterns.Iterator;

	public class ArrayIterator implements Iterator
	{
		private var _list : Array;
		private var _index : int = -1;
		
		public function ArrayIterator( list : Array )
		{
			_list = list;
		}

		public function hasNext() : Boolean
		{
			return _index < _list.length - 1;
		}
		
		public function next() : Object
		{
			_index ++;
			return _list[ _index ];
		}
		
	}
}