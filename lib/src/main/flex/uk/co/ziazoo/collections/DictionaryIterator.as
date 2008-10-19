
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
 
package uk.co.ziazoo.collections
{
	import flash.utils.Dictionary;
	
	import uk.co.ziazoo.collections.Iterator;

	public class DictionaryIterator implements Iterator
	{
		private var _dict:Dictionary;
		private var _iterator:ArrayIterator;
		
		public function DictionaryIterator( dict:Dictionary )
		{
			_dict = dict;
			
			var keys:Array = new Array();
			for ( var key:String in _dict )
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
		
		public function remove ():void
		{
			_iterator.remove();
			trace( "this doesnt work!" )
		}
		
	}
}