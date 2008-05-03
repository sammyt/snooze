package org.projectsnooze.impl.patterns
{
	import mx.collections.ArrayCollection;
	
	import org.projectsnooze.patterns.Iterator;

	public class ArrayCollectionIterator implements Iterator
	{
		private var _list : ArrayCollection;
		private var _index : int = -1;
		
		public function ArrayCollectionIterator( list : ArrayCollection )
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