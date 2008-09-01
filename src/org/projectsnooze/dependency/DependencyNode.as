
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
	
	/**
	 * 	The <code>DependencyNode</code> represents an one object within a tree of
	 * 	interdependent objects.
	 * 	
	 * 	@see org.projectsnooze.dependency.DependencyTree 	
	 * 	@see org.projectsnooze.impl.dependency.DependencyTreeCreator
	 */ 
	public interface DependencyNode extends Subject , Observer , Command , Responder
	{
		/**
		 * 	Sets the <code>DependencyTree</code> that this <code>DependencyNode</code>
		 * 	is contained within.
		 * 
		 * 	<p>each node maintains a list of nodes it is dependent on, and 
		 * 	a list of nodes which depend on it.  This is done via the observer
		 * 	pattern, with each node implementing both <code>Subject</code> and
		 * 	<code>Observer</code>.  Observers are the dependent nodes.</p>
		 * 
		 * 	<p>When a node has completed executing, it notifies all its 
		 * 	dependent nodes (obserers) view the notifyObservers method, any
		 * 	of those which as a result have all their dependencies met begin
		 * 	the process of execution.</p>
		 */ 
		function setDependencyTree ( dependencyTree:DependencyTree ):void;
		
		/**
		 * 	Gets the <code>DependencyTree</code> that this <code>DependencyNode</code>
		 * 	is contained within.
		 */
		function getDependencyTree ():DependencyTree;
		
		/**
		 * 	<code>DependencyNode</code>s require a reference to the statement
		 * 	queue so that when they are executed that can create their
		 * 	<code>Statement</code> object and set its <code>StatementQueue</code
		 * 	property, thus allowing it to be executed on the database
		 */ 
		//function setStatementQueue ( statementQueue:StatementQueue ):void;
		
		/**
		 * 	returns the reference to the <code>StatementQueue</code> given
		 * 	to the instance
		 */ 
		function getStatementQueue ():StatementQueue;
		
		/**
		 * 	returns wether this node is dependent on the execution of any other
		 * 	nodes.  If it is, it cannot execute until the nodes it depends on
		 * 	have completed
		 * 
		 * 	@see isComplete
		 * 	@see dependenciesAreMet
		 */ 
		function isDependent ():Boolean;
		
		/**
		 * 	this function returns true if all the nodes this node is dependent
		 * 	on have completed there execution.  Otherwise it returns false.
		 */ 
		function dependenciesAreMet ():Boolean;
		
		/**
		 * 	isComplete returns true if the node has completed execution or
		 * 	false if is has not begun, or is currently executing
		 */ 
		function isComplete ():Boolean;
		
		/**
		 * 	this is used by the <code>DependencyTreeCreator</code> to add a
		 * 	dependent node to this nodes list of dependent nodes.
		 */ 
		function addDependentNode ( dependencyNode:DependencyNode ):void;
		
		/**
		 * 	this is used to inform the node of another node which it is dependent
		 * 	on.  This node cannot execute untill all the nodes it is dependent on
		 * 	have completed execution.
		 */ 
		function addDependency ( dependencyNode:DependencyNode ):void;
		
		/**
		 * 	the statement set here should be ready prepared with the correct
		 * 	sql for the given action, the dependecy node simple need to fill
		 * 	in the blank parameters
		 */ 
		function setStatement ( statement:Statement ):void;
		
		/**
		 * 	returns the statement for this <code>DependencyNode</code>
		 */ 
		function getStatement ():Statement;
		
		/**
		 * 	used to begin the execution of the dependency node where there
		 * 	are no dependencies
		 */ 
		function begin ():void;
		
		/**
		 * 	<code>DependencyNode</code>s often wrap objects such as entities.
		 * 	If this is such a node then this function will return the object
		 */	
		function getWrappedObject ():Object;
		
	}
}