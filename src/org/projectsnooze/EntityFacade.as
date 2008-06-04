
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

package org.projectsnooze
{
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.SchemeBuilder;
	import org.projectsnooze.session.Session;
	
	public interface EntityFacade
	{
		
		function init () : void;
		
		function createDatabase () : void;
		
		function dropDatabase () : void;
		
		function setCreateDDL ( createDDL : Boolean ) : void;
		
		function getCreateDDL () : Boolean;
		
		function addEntityClass ( clazz : Class ) : void; 
		
		function setSchemeBuilder ( schemeBuilder : SchemeBuilder ) : void;
		
		function getSchemeBuilder () : SchemeBuilder;
		
		function setEntityDataMapProvider ( entityDataMapProvider : EntityDataMapProvider ): void;
		
		function getEntityDataMapProvider () : EntityDataMapProvider;
		
		function setTypeUtils ( typeUtils : TypeUtils ) : void;
		
		function getTypeUtils () : TypeUtils;
		
		function setTypeFactory( typeFactory : TypeFactory ) : void;
		
		function getTypeFactory () : TypeFactory;
		
		function setLinkTypeFactory ( linkTypeFactory : LinkTypeFactory ) : void;
		
		function getLinkTypeFactory () : LinkTypeFactory;
		
		function setStatementCreator ( statementCreator : StatementCreator ) : void;
		
		function getStatementCreator () : StatementCreator;
		
		function setConnectionPool ( connectionPool : ConnectionPool ) : void;
		
		function getConnectionPool () : ConnectionPool;
		
		function setDependencyTreeCreator ( dependencyTreeCreator : DependencyTreeCreator ) : void;
		
		function getDependencyTreeCreator () : DependencyTreeCreator;
		
		function setDDLGenerator ( ddlGenerator : DDLGenerator ) : void;
		
		function getDDLgenerator () : DDLGenerator;
		
		function setQueueManager ( queueManager : QueueManager ) : void;
		
		function getQueueManager () : QueueManager;
		
		function getSession () : Session;
				
	}
}