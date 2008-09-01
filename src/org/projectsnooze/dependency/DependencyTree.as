package org.projectsnooze.dependency
{
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.execute.StatementQueue;
	
	/**
	 * 	The <code>DependencyTree</code> contains references to many
	 * 	<code>DependencyNode</code>s, whos interdependencies give them a tree
	 * 	shape.  This class allow for the whole tree to be simple passes around
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
		function addDependencyNode ( dependencyNode:DependencyNode ):void;
		
		/**
		 * 	Nodes offten <i>wrap</i> the objects they are providing the action
		 * 	for.  For example, many nodes will contain a entity, whos insertion/
		 * 	retrevial they are responsible for.  This function determines if there
		 * 	is  node in the tree that wraps the provided object
		 */  
		function doAnyNodesWrap ( obj:Object ):Boolean;
		
		/**
		 * 	if there is a node that wraps the passed object, this function will
		 * 	locate and return it
		 */ 
		function getNodeByWrappedObject (  obj:Object ):DependencyNode;
		
		/**
		 * 	returns whether or not the provided node has completed its action
		 */ 
		function nodeHasCompleted ( node:DependencyNode ):void;
		
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
		/**
		 * 	many to many relationships should only be followed in one direction
		 * 	when creating dependency trees, otherwise snooze will get stuck
		 * 	in infinite loops.  Use this method whenever a many to many 
		 * 	relationship is followed
		 */ 
		function setManyToManyPathFollowed ( relationship:Relationship ):void;
		
		/**
		 * 	use this to check if a many to many relationship has been followed
		 * 	before.  If it has, do no follow if again
		 */ 
		function getManyToManyPathFollowed( relationship:Relationship ):Boolean;
	}
}




