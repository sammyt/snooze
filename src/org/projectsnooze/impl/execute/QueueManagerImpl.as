
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
 
package org.projectsnooze.impl.execute
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;

	public class QueueManagerImpl implements QueueManager
	{
		private var logger : ILogger = Log.getLogger( "QueueManagerImpl" );
		
		protected var _connectionPool : ConnectionPool;
		protected var _queue : Array;
		protected var _index : int;
		protected var _inTransaction : Boolean;
		
		public function QueueManagerImpl()
		{
			_queue = new Array();
			
			_index = - 1;
			
			_inTransaction = false;
		}
			
		public function processNext () : void
		{
			if ( ! _inTransaction && _queue.length > 0 )
			{
				
				_index ++;
			
				var queue : StatementQueue = _queue[ _index ] as StatementQueue;
				
				_inTransaction = queue.getTransactional();
				
				queue.beginProcessingQueue();
				
				processNext();
			}
		}
		
		public function getQueue():StatementQueue
		{
			// create the new statement queue
			var queue : StatementQueue = new StatementQueueImpl();
			queue.setConnectionPool( getConnectionPool() ); 
			queue.addEventListener( StatementQueueEvent.COMPLETE , onQueueComplete );
			queue.addEventListener( StatementQueueEvent.OPEN , onQueueConnectionOpen );
			
			// add the statement queue to the parent queue 
			_queue.push( queue );
			return queue;
		}
		
		protected function onQueueConnectionOpen ( event : StatementQueueEvent ) : void
		{
			processNext();
		}
		
		protected function onQueueComplete ( event : StatementQueueEvent ) : void
		{
			// remove the event listener
			event.getStatementQueue().removeEventListener( StatementQueueEvent.COMPLETE , onQueueComplete );
			
			// remove from queue
			removeFromQueue( event.getStatementQueue() );
			
			if ( event.getStatementQueue().getTransactional() )
			{
				_inTransaction = false;
			}
			
			// continue processing queue
			processNext();
		}
		
		public function removeFromQueue ( statementQueue : StatementQueue ) : void
		{
			for ( var iterator : Iterator = new ArrayIterator ( _queue ) ; iterator.hasNext() ; )
			{
				var queue : StatementQueue = iterator.next() as StatementQueue;
				if ( queue == statementQueue )
				{
					iterator.remove();
					_index --;
					break;
				}
			}
		}
		
		public function setConnectionPool ( connectionPool : ConnectionPool ) : void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool () : ConnectionPool
		{
			return _connectionPool;
		}
	}
}