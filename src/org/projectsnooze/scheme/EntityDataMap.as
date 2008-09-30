
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
 
package org.projectsnooze.scheme
{
	import org.projectsnooze.scheme.NameTypeMapping;
	import org.projectsnooze.associations.Relationship;
	import uk.co.ziazoo.collections.Iterator;
	
	/**
	*	this class hold all the infotmation about a given entity
	*	such that is can be mapped to and from the database.  It contains
	*	information about all the relationships the entity is involved
	*	in, as well as all the properties the entity has.  It is the vital
	*	contract that snooze uses to work with entities in an applicaion
	*	
	*	@see org.projectsnooze.scheme.NameTypeMapping
	*	@see org.projectsnooze.associations.Relationship
	*/	
	public interface EntityDataMap
	{
		/**
		*	adds a natural property to the data map.  A natrual property
		*	is one that maps directly to a database column such as a String
		*	or a Number.
		*	
		*	@param mapping:NameTypeMapping , the object that describes the 
		*	natural property of the entity
		*/	
		function addProperty ( mapping:NameTypeMapping ):void;
		
		/**
		*	this method adds a Relationship to the entities data map.  Relationships
		*	describe the way the underlying database tables that map the business domain
		*	objects are related. An example relationship would be a one-to-many relatinship.
		*	
		*	@param relationship:Relationship , the relationship to be added 
		*	the the entities data map
		*/	
		function addRelationship ( relationship:Relationship ):void;
		
		/**
		*	this method returns the relationship between this entity and the one
		*	whos data map is porvided
		*	
		*	@param dataMap:EntityDataMap , the data map of the entity we want
		*	to know the relationship with
		*/	
		function getRelationship ( dataMap:EntityDataMap ):Relationship;
		
		function setPrimaryKey ( mapping:NameTypeMapping ):void;
		
		function getPrimaryKey ():NameTypeMapping;
		
		function getPropertyIterator ():Iterator;
		
		function getRelationshipIterator ():Iterator;
		
		function getTableName ():String;
		
		function setTableName ( name:String ):void;
		
		function getForeignKeyName ():String;
		
	}
}