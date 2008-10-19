
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
 
package org.projectsnooze.session
{
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.generator.DDLGenerator;
	
	/**
	 * The session object is the main point of interation
	 * between the application and the database.  It defines the 
	 * methods to save and retrieve as well as creating and
	 * dropping the database tables
	 * 
	 * @autor Samuel Williams
	 * @since 31.08.08
	 */ 
	public interface Session
	{
		/**
		 * Creates the database tables for the 
		 * domain objects provided to the EntityFacade
		 */ 
		function createDatabase():void;
		
		/**
		 * Drops the database tables for the 
		 * domain objects provided to the EntityFacade
		 */ 
		function dropDatabase():void;
		
		/**
		 * Saves an entity to the database
		 * 
		 * @param entity:Object the object to save to the database
		 */ 
		function save ( entity:Object ):void;
		
		/**
		 * Retrieves a object map from the database
		 * 
		 * @param clazz:Class tehe class of the object to retrieve
		 * @param id:Object the ID of the object in the database
		 */ 
		function retrieve( clazz:Class, id:Object ):void;
		
		function getDependencyTreeCreator (  ):DependencyTreeCreator;
		
		function setDependencyTreeCreator ( dependencyTreeCreator:DependencyTreeCreator ):void;
		
		function getQueueManager ():QueueManager;
		
		function setQueueManager ( queueManager:QueueManager ):void;

		function getDDLGenerator():DDLGenerator;
		
		function setDDLGenerator( ddlGenerator:DDLGenerator ):void;
		
		function getDispatcher():Dispatcher;
		
		function setDispatcher( dispather:Dispatcher ):void;
	}
}