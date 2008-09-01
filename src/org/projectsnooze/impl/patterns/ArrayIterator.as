
/* 
 * The MIT License
 * 
 * Copyright (c) 2008 Samuel Williams
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package org.projectsnooze.impl.patterns
{
	import org.projectsnooze.patterns.Iterator;

	public class ArrayIterator implements Iterator
	{
		private var _list:Array;
		private var _index:int = -1;
		
		public function ArrayIterator( list:Array )
		{
			_list = list;
		}

		public function hasNext():Boolean
		{
			return _index < _list.length - 1;
		}
		
		public function next():Object
		{
			_index ++;
			return _list[ _index ];
		}
		
		public function remove ():void
		{
			_list.splice( _index , 1 );
			_index --;
		}
	}
}