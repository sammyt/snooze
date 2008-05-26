
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
	import flash.utils.describeType;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.patterns.Iterator;

	public class SmartIterator implements Iterator
	{
		private static var logger : ILogger = Log.getLogger( "SmartIterator" );
		
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
		
		public function remove () : void
		{
			_iterator.remove();
		}
		
	}
}