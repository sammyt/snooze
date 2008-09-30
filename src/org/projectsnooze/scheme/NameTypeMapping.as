
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
		*	@return	true if property id primary key
		*/	
		function isPrimaryKey ():Boolean;
		
		function setIsPrimaryKey ( value:Boolean ):void;
		
		function getIsPrimaryKey ():Boolean;
		
		function setName ( name:String ):void;
		
		function getName ():String;
		
		function setType ( type:Type ):void;
		
		function getType ():Type;
		
		function getLowerCaseName ():String;
	
	}
}