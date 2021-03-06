
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
 
package org.projectsnooze.impl.scheme
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import uk.co.ziazoo.collections.DictionaryIterator;
	import uk.co.ziazoo.collections.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public class EntityDataMapProviderImpl implements EntityDataMapProvider
	{
		private var _dataMaps:Dictionary; 
		
		public function EntityDataMapProviderImpl () 
		{
			_dataMaps = new Dictionary ();
		}
		
		public function getEntityDataMap ( entity:Object ):EntityDataMap
		{
			var name:String = describeType( entity ).@name;
			return getEntityDataMapByClassName ( name );
		}
		
		public function getEntityDataMapByClassName ( name:String ):EntityDataMap
		{
			return _dataMaps[ name ] as EntityDataMap;
		}
		
		public function setEntityDataMap ( name:String , dataMap:EntityDataMap ):void
		{
			_dataMaps[ name ] = dataMap;
		}
		
		public function getIterator ():Iterator
		{
			return new DictionaryIterator( _dataMaps );
		}
	}
}