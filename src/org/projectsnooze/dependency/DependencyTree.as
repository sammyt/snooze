package org.projectsnooze.dependency
{
	public interface DependencyTree
	{
		function getNodeCount () : int;
		
		function addDependencyNode ( dependencyNode : DependencyNode ) : void;
		
		function doesTreeContain ( entity : Object ) : Boolean;
		
		function getNodeByEntity ( entity : Object ) : DependencyNode;
		
		function begin () : void;
	}
}