
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
 
package org.projectsnooze.impl.associations
{
	import org.projectsnooze.associations.LinkType;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.scheme.EntityDataMap;

	public class RelationshipImpl implements Relationship
	{
		private var _type : LinkType;
		private var _dataMap : EntityDataMap;
		private var _name : String;
		private var _isEntityContainer : Boolean;
		
		public function RelationshipImpl()
		{
		}

		public function setType(type:LinkType):void
		{
			_type = type;
		}
		
		public function getType():LinkType
		{
			return _type;
		}
		
		public function setEntityDataMap(dataMap:EntityDataMap):void
		{
			_dataMap = dataMap;
		}
		
		public function getEntityDataMap():EntityDataMap
		{
			return _dataMap;
		}
		
		public function setPropertyName ( name : String ) : void
		{
			_name = name;
		}
		
		public function getPropertyName () : String
		{
			return _name;
		}
		
		public function setIsEntityContainer ( isEntityContainer : Boolean ) : void
		{
			_isEntityContainer = isEntityContainer;
		}
		
		public function getIsEntityContainer () : Boolean
		{
			return _isEntityContainer;
		}
	}
}