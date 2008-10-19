
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
	import org.projectsnooze.datatype.Type;
	
	import uk.co.ziazoo.reflection.NameAndTypeReference;
	
	/**
	 * 	This class maps the name of a property getter/setter to its 
	 * 	<code>Type</code>.  It also holds useful information about whether or
	 * 	not the property is mapped to a primary key
	 */ 
	public interface NameTypeMapping
	{
		/**
		*	one property in each entity must act as a primary key.
		*	This function returns wether of not this is the 
		*	property which holds the primary key
		*	
		*	@return true if property is a primary key
		*/	
		function isPrimaryKey():Boolean;
		
		/**
		*	Used to specify is this <code>NameTypeMapping</code>
		*	is that of a primary key
		*	
		*	@param value:Boolean, true if this is a primary key
		*/	
		function setPrimaryKey( value:Boolean ):void;
		
		/**
		*	Returns the column name that this property maps to.
		*	This can be determined from the name of the getter from
		*	the property or from the [Column] metadata where it 
		*	is present
		*	
		*	@return the column name in the database table
		*/	
		function getColumnName():String;
		
		/**
		*	Sets the column name for this property
		*	
		*	@param columnName:String the name for the db column
		*/	
		function setColumnName( columnName:String ):void;
		
		/**
		*	The <code>NameAndTypeReference</code> created from
		*	reflection on the getter for this property
		*	
		*	@return the NameAndTypeReference for the getter
		*/	
		function getGetter():NameAndTypeReference;
		
		/**
		*	Sets the <code>NameAndTypeReference</code> for the
		*	given property
		*	
		*	@param getter:NameAndTypeReference the reflection
		*/	
		function setGetter( getter:NameAndTypeReference ):void;
		
		/**
		*	The <code>NameAndTypeReference</code> created from
		*	reflection on the setter for this property
		*	
		*	@return the NameAndTypeReference for the setter
		*/	
		function getSetter():NameAndTypeReference;
		
		/**
		*	Sets the <code>NameAndTypeReference</code> for the
		*	given property
		*	
		*	@param setter:NameAndTypeReference the reflection
		*/
		function setSetter( setter:NameAndTypeReference ):void;
			
		function setType( type:Type ):void;
		
		function getType():Type;
		
		/**
		*	Returns the column name in lowercase
		*/	
		function getLowerCaseName():String;
	
	}
}