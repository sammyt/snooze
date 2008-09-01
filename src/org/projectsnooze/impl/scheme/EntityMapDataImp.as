
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
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.NameTypeMapping;

	public class EntityMapDataImp implements EntityDataMap
	{
		private var logger:ILogger = Log.getLogger( "EntityMapDataImp" );
		
		private var _properties:Array;
		private var _relationships:Array;
		private var _tableName:String;
		private var _pkMapping:NameTypeMapping;
		
		public function EntityMapDataImp()
		{
			_properties = new Array();
			_relationships = new Array();
		}
		
		public function setPrimaryKey ( mapping:NameTypeMapping ):void
		{
			_pkMapping = mapping;
		}
		
		public function getPrimaryKey ():NameTypeMapping
		{
			return _pkMapping;
		}

		public function addProperty( mapping:NameTypeMapping ):void
		{
			_properties.push( mapping );
		}
		
		public function getPropertyIterator ():Iterator
		{
			return new ArrayIterator ( _properties );
		}
		
		public function getRelationshipIterator ():Iterator
		{
			//logger.debug( "create ArrayIterator with {0} or length {1} " , 
			//	_relationships , _relationships.length );
				
			return new ArrayIterator ( _relationships );
		}
		
		public function getTableName ():String
		{
			return _tableName;
		}
		
		public function setTableName ( name:String ):void
		{
			_tableName = name;
		}
		
		public function addRelationship ( relationship:Relationship ):void
		{
			_relationships.push( relationship );
		}
		
		public function getRelationship ( dataMap:EntityDataMap ):Relationship
		{
			for ( var iterator:Iterator = getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship:Relationship = iterator.next() as Relationship;
				if ( relationship.getEntityDataMap() == dataMap ) return relationship;
			}
			return null;
		}
		
		public function getForeignKeyName ():String
		{
			return getTableName().toLowerCase() + "_" + getPrimaryKey().getLowerCaseName();
		}
		
	}
}


