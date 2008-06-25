
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
	
	/**
	 * 	@inheritDoc
	 */ 
	public class DependencyTreeImpl extends EventDispatcher 
									implements DependencyTree
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
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getNodeCount () : int
		{
			return _nodes.length;
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function addDependencyNode( 
			dependencyNode : DependencyNode ) : void
		{
			_nodes.push( dependencyNode );
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function begin():void
		{
			_statementQueue.setTransactional( true );
			_statementQueue.openConnection();
			
			for( var i : Iterator = new SmartIterator( _nodes ) ; i.hasNext() ; )
			{
				var depNode : DependencyNode = i.next() as DependencyNode;
				depNode.setDependencyTree( this );
				
				// the node has no unfilled dependencies, so can begin
				if ( ! depNode.isDependent() ) depNode.begin();
			}
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
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
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function doAnyNodesWrap ( obj : Object ) : Boolean
		{
			return getNodeByWrappedObject( obj ) ? true : false;
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getNodeByWrappedObject ( obj : Object ) : DependencyNode
		{
			for ( var i : Iterator = new ArrayIterator ( _nodes ) ; i.hasNext() ; )
			{
				var node : DependencyNode = i.next() as DependencyNode;
				if ( node.getWrappedObject() == obj ) return node;
			}
			return null;
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function setStatementQueue ( 
			statementQueue : StatementQueue ) : void
		{
			_statementQueue = statementQueue; 
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getStatementQueue () : StatementQueue
		{
			return _statementQueue;
		}
	}
}