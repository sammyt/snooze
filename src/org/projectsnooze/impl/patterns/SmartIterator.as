package org.projectsnooze.impl.patterns
{
	import flash.utils.describeType;
	
	import org.projectsnooze.patterns.Iterator;

	public class SmartIterator implements Iterator
	{
		private var _iterator : Iterator;
		
		public function SmartIterator( list : Object )
		{
			var type : String = describeType( list ).@name;
			switch ( type )
			{
				case "Array":
					_iterator = new ArrayIterator ( list as Array );
					break;
			}
		}

		public function hasNext():Boolean
		{
			return _iterator.hasNext();
		}
		
		public function next():Object
		{
			return _iterator.next();
		}
		
	}
}