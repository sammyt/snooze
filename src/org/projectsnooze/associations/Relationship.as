
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
 
package org.projectsnooze.associations
{
	import org.projectsnooze.scheme.EntityDataMap;
	
	import uk.co.ziazoo.reflection.NameReference;
	
	/**
	*	A Relationship is a description of a relationship
	*	between or more tables in a relational data base <strong>from
	*	the perspective of one of the entities in the relationship</strong>
	*/	
	public interface Relationship
	{
		
		/**
		*	set the link type object for this relationship.
		*	LinkTypes define the underlying database relationship
		*	this object represents
		*	
		*	@param the link type for this Relationship
		*/	
		function setType ( type:LinkType ):void;
		
		/**
		*	retreive the link type object for this relationship
		*/	
		function getType ():LinkType;
		
		/**
		*	where the relationship requires a join table (ManyToMany) the name
		*	of that table, in the form 'joined table name 1'_'joined table name 2'
		*	is returned with the following function
		*/	
		function getJoinTableName ():String;
		
		/**
		*	use this function to set the name of the join table
		*	where the relationship requires it
		*/	
		function setJoinTableName ( joinTableName:String ):void;
		
		/**
		*	sets the entity data map of the entity whos 
		*	relationships this object describes
		*/	
		function setEntityDataMap ( dataMap:EntityDataMap ):void;
		
		/**
		*	returns the entity data map whos relationship is described
		*/	
		function getEntityDataMap ():EntityDataMap;
		
		/**
		*	set whether or not this is the entity container
		*/	
		function setIsEntityContainer ( isEntityContainer:Boolean ):void;
		
		/**
		*	returns is this entity is the entity container is the relationship
		*/
		function getIsEntityContainer ():Boolean;
		
		/**
		*	<code>Relationship</code> objects are created by inspecting
		*	a field on an entity, and its associated metadata.  The 
		*	<code>NameTypeMapping</code> describes the field that created
		*	this <code>Relationship</code> object
		*/	
		function getNameTypeMapping():NameTypeMapping;
		
		/**
		*	The <code>NameTypeMapping</code> object for this relationship
		*/	
		function setNameTypeMapping( nameTypeMapping:NameTypeMapping ):void;
		
		
	}
}