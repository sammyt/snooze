package org.projectsnooze.dependency
{
	import flash.events.IEventDispatcher;
	
	import org.projectsnooze.execute.StatementQueue;
	
	public interface DependencyTree extends IEventDispatcher
	{
		function getNodeCount () : int;
		
		function addDependencyNode ( dependencyNode : DependencyNode ) : void;
		
		function doesTreeContain ( entity : Object ) : Boolean;
		
		function getNodeByEntity ( entity : Object ) : DependencyNode;
		
		function nodeHasCompleted ( node : DependencyNode ) : void;
		
		function begin () : void;
		
		function setStatementQueue ( statementQueue : StatementQueue ) : void;
		
		function getStatementQueue () : StatementQueue;
	}
}