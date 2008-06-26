
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
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.scheme.EntityDataMap;
	
	/**
	 * 	The <code>StatementCreator</code>s job is to generate the necessary
	 * 	<code>Statement</code> objects for a given scenario, such as inserting
	 * 	an entity into the database
	 */ 
	public interface StatementCreator
	{
		/**
		 * 	this method returns a <code>Statement</code> object for inserting
		 * 	into a join table to relate two entites within a many to many
		 * 	relationship within the database
		 */ 
		function getRelationshipInsert ( relationship : Relationship ,
			dataOne : EntityDataMap , dataTwo : EntityDataMap ) : Statement;
		
		/**
		 * 	returns a SELECT statement for the provided entity
		 */ 
		function getSelectStatement ( data : EntityDataMap ) : Statement;
		
		/**
		 * 	returns a INSERT statement for the provided entity
		 */
		function getInsertStatement ( data : EntityDataMap ) : Statement;
		
		/**
		 * 	returns a UPDATE statement for the provided entity
		 */
		function getUpdateStatement ( data : EntityDataMap ) : Statement;
		
		/**
		 * 	returns a DELETE statement for the provided entity
		 */
		function getDeleteStatement ( data : EntityDataMap ) : Statement;
		
		/**
		 * 	returns a statement for the provided entity of the type select,
		 * 	update, delete or insert  
		 */
		function getStatementByType ( type : String , data : EntityDataMap ) : Statement;
	}
}