package org.projectsnooze.dependency
{
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.execute.StatementQueue;
	
	/**
	 * 	The <code>DependencyTree</code> contains references to many
	 * 	<code>DependencyNode</code>s, whos interdependencies give them a tree
	 * 	shape.  This class allow for the whole tree to be passed around
	 * 	the applicaiton as well as defining some usefull function such as 
	 * 	<code>begin()</code> which starts the tree of nodes off on there
	 * 	execution run.
	 */ 
	public interface DependencyTree
	{
		/**
		 * 	returns the number of nodes within the tree
		 */ 
		function getNodeCount ():int;
		
		/**
		 * 	provides the instance of <code>DependencyTree</code> with a reference
		 * 	to a node in the tree.  Although the tree itself is described by the 
		 * 	interdependencies between the nodes
		 */ 
		function add ( dependencyNode:DependencyNode ):void;
		
		/**
		 * All nodes wrap some sort of object, this could be an
		 * entity, or a relationship etc.  this method determines
		 * is a node already exists for the give unique object
		 */  
		function contains ( unique:Object ):Boolean;
		
		/**
		 * 	if there is a node that wraps the passed object, this function will
		 * 	locate and return it
		 */ 
		function getNode ( unique:Object ):DependencyNode;
		
		/**
		 * 	used to begin the execution of the nodes in the order their
		 * 	dependencies dictate
		 */ 
		function begin ():void;
					
		/**
		 * 	provides the tree with a reference to the statement queue, which it
		 * 	can in turn give to the nodes, so they can add their sql to the queue
		 * 	of sql to be executed
		 */ 
		function setStatementQueue ( statementQueue:StatementQueue ):void;
		
		/**
		 * 	returns the provided reference to the statement queue
		 */ 
		function getStatementQueue ():StatementQueue;
	}
}




