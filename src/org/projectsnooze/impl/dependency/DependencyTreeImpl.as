package org.projectsnooze.impl.dependency
{
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;

	public class DependencyTreeImpl implements DependencyTree
	{
		protected var _nodes : Array;
		protected var _completedCount : uint;
		
		public function DependencyTreeImpl()
		{
			_nodes = new Array();
			_completedCount = 0;
		}
		
		public function getNodeCount () : int
		{
			return _nodes.length;
		}
		
		public function addDependencyNode( dependencyNode : DependencyNode ) : void
		{
			_nodes.push( dependencyNode );
		}
		
		public function begin():void
		{
			for( var iterator : Iterator = new SmartIterator( _nodes ) ; iterator.hasNext() ; )
			{
				var depNode : DependencyNode = iterator.next() as DependencyNode;
				depNode.setDependencyTree( this );
				
				// the node has no unfilled dependencies, so can begin
				if ( ! depNode.isDependent() ) depNode.begin();
			}
		}
		
		public function nodeHasCompleted ( node : DependencyNode ) : void
		{
			_completedCount ++;
			if ( _completedCount == _nodes.length )
			{
				
			}
		}
		
		public function doesTreeContain ( entity : Object ) : Boolean
		{
			return getNodeByEntity( entity ) != null;
		}
		
		public function getNodeByEntity ( entity : Object ) : DependencyNode
		{
			for ( var iterator : Iterator = new ArrayIterator ( _nodes ) ; iterator.hasNext() ; )
			{
				var node : DependencyNode = iterator.next() as DependencyNode;
				if ( node.getEntity() == entity ) return node;
			}
			return null;
		}
		
	}
}