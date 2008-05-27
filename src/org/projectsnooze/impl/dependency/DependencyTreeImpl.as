package org.projectsnooze.impl.dependency
{
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;

	public class DependencyTreeImpl extends EventDispatcher implements DependencyTree
	{
		private var logger : ILogger = Log.getLogger( "DependencyTreeImpl" );
		
		protected var _nodes : Array;
		protected var _completedCount : uint;
		protected var _statementQueue : StatementQueue;
		
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
			_statementQueue.setTransactional( true );
			_statementQueue.openConnection();
			
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
				// the result method in all the nodes has been called
				logger.debug( "the action is complete" );
				
				_statementQueue.finishProcessingQueue();
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
		
		public function setStatementQueue ( statementQueue : StatementQueue ) : void
		{
			_statementQueue = statementQueue; 
		}
		
		public function getStatementQueue () : StatementQueue
		{
			return _statementQueue;
		}
	}
}