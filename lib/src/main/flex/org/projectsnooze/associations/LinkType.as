
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
	/**
	*	Defines the type of underlying database
	*	relationship of a <code>Relationship</code>	
	*/	 
	public interface LinkType
	{
		/**
		*	The name of the relationship
		*	eg ManyToMany
		*	
		*	@return the relationship name
		*/	
		function getName ():String;
		
		/**
		*	Sets the name of the relationship
		*	
		*	@param name:String the name
		*/	
		function setName ( name:String ):void;
		
		/**
		*	is this entity's table one that contains a foreign key
		*	to describe this relationship
		*/	
		function getForeignKeyContainer ():Boolean;
		
		/**
		*	used to set whether or not the entities table contains 
		*	a forien key to describe the relationship
		*/	
		function setForeignKeyContainer ( foreignKeyContainer:Boolean ):void;
	}
}