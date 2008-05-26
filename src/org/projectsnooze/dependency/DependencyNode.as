
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
 
package org.projectsnooze.dependency
{
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.patterns.Command;
	import org.projectsnooze.patterns.Observer;
	import org.projectsnooze.patterns.Subject;
	import org.projectsnooze.scheme.EntityDataMap;
	
	public interface DependencyNode extends Subject , Observer , Command , Responder
	{
		function setStatementQueue ( statementQueue : StatementQueue ) : void;
		
		function getStatementQueue () : StatementQueue;
		
		function isDependent () : Boolean;
		
		function dependenciesAreMet () : Boolean;
		
		function isComplete () : Boolean;
		
		function setEnity ( entity : Object ) : void;
		
		function getEntity () : Object;
		
		function setEntityDataMap ( entityDataMap : EntityDataMap ) : void;
		
		function getEntityDataMap () : EntityDataMap;
		
		function addDependentNode ( dependencyNode : DependencyNode ) : void;
		
		function addDependency ( dependencyNode : DependencyNode ) : void;
		
		function setStatement ( statement : Statement ) : void;
		
		function getStatement () : Statement;
		
		function addParams () : void;
		
		function begin () : void;
		
	}
}