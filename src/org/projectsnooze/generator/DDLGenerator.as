
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
 
package org.projectsnooze.generator
{
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	/**
	*	the DDLGenerator creates SQL statements for createing and dropping 
	*	whole databases.  It generates the SQL based on the EntityDataMapProvider
	*	is is given via the <code>setEntityDataMapProvider<code> method.
	*	
	*	@see org.projectsnooze.scheme.EntityDataMapProvider
	*	@see org.projectsnooze.generator.Statement
	*/	
	public interface DDLGenerator
	{
		/**
		*	sets the EntityDataMapProvider used to determine the structure 
		*	of the database to be created or deleted
		*/	
		function setEntityDataMapProvider ( entityDataMapProvider:EntityDataMapProvider ):void;
		
		/**
		*	returns the EntityDataMapProvider in use by the DDLGenerator
		*/	
		function getEntityDataMapProvider ():EntityDataMapProvider;
		
		/**
		*	returns an <code>Array</code> of <code>Statement</code> objects
		*	which when executed will generate the while database structure
		*/	
		function getDDLStatements ():Array;
		
		/**
		*	returns an <code>Array</code> of <code>Statement</code> objects
		*	which when executed will drop all the database tables
		*/
		function getDropStatements ():Array;
	}
}