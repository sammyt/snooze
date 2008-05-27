
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
	import flash.data.SQLConnection;
	import flash.events.EventDispatcher;
	import flash.events.SQLEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;

	public class StatementQueueImpl extends EventDispatcher implements StatementQueue
	{
		private var logger : ILogger = Log.getLogger( "StatementQueueImpl" );
		
		protected var _queue : Array;
		protected var _transactional : Boolean;
		protected var _iterator : Iterator;
		protected var _connectionPool : ConnectionPool;
		protected var _connection : SQLConnection;
		protected var _processing : Boolean;
		protected var _executing : Boolean;
		protected var _allStatementsAdded : Boolean;
		
		public function StatementQueueImpl()
		{
			// the queue has not yet begun processing
			_processing = false;
			
			// nothing is yet excuting
			_executing = false;
			
			// true when the queue can expect no more
			_allStatementsAdded = false;
			
			// create the array to hold the queue
			_queue = new Array();
			
			_iterator = new ArrayIterator( _queue ); 
		}
		

		public function addToExecutionQueue( wrapper : StatementWrapper ):void
		{
			// add the wrapper to the queue
			_queue.push( wrapper );
			
			if ( _processing ) processNext();
		}
		
		public function setAllStatementsAdded ( allAdded : Boolean ) : void
		{
			_allStatementsAdded = allAdded;
			
			if ( areAllStatementsAdded() && ! _iterator.hasNext() && ! _executing )
			{
				finishProcessingQueue();
			}
		}
		
		public function areAllStatementsAdded () : Boolean
		{
			return _allStatementsAdded;
		}
		
		public function isInQueue(statement:Statement):Boolean
		{
			for ( var iterator : Iterator = new ArrayIterator ( _queue ) ; iterator.hasNext() ; )
			{
				var wrapper : StatementWrapper = iterator.next() as StatementWrapper;
				if ( wrapper.getStatement() == statement ) return true;
			}
			return false;
		}
		
		public function openConnection () : void
		{
			_connection = getConnectionPool().getConnection();
			_connection.addEventListener( SQLEvent.OPEN , onOpen );
			_connection.open( getConnectionPool().getFile() );
		}
		
		public function beginProcessingQueue():void
		{
			if ( ! _processing )
			{
				_processing = true;
				
				if ( getTransactional() )
				{
					beginTransaction();
				}
				else
				{
					processNext();
				}
			}
			else
			{
				processNext();
			}
		}
		
		public function finishProcessingQueue () : void
		{
			if ( getTransactional() )
			{
				commitTransaction();
			}
			else
			{
				dispatchEvent( new StatementQueueEvent ( StatementQueueEvent.COMPLETE , this ) );
			}
		}
		
		public function errorProcessingQueue () : void
		{
			rollbackTransaction();
		}
		
		public function processNext () : void
		{
			var queueHasNext : Boolean = _iterator.hasNext();
			var connectionOpen : Boolean = _connection.connected;
			
			if ( queueHasNext && connectionOpen && ! _executing )
			{
				_executing = true;
				
				var wrapper : StatementWrapper = _iterator.next() as StatementWrapper;
				var executor : StatementExecutor = new StatementExecutorImpl();
				
				executor.setResponder( wrapper.getResponder() );
				executor.setStatement( wrapper.getStatement() );
				executor.setConnection( _connection );
				
				executor.addEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
				executor.addEventListener( StatementExecutorEvent.FAULT , onExecuteFault );
				
				executor.execute();
			}
			else if ( ! queueHasNext && areAllStatementsAdded() )
			{
				finishProcessingQueue();
			}
		}
		
		public function beginTransaction () : void
		{
			_connection.addEventListener( SQLEvent.BEGIN , onBegin );
			_connection.begin();
		}
		
		protected function onBegin ( event : SQLEvent ) : void
		{
			logger.debug( "Transaction Started" );
			
			// now the transaction has started remove the listener
			_connection.removeEventListener( SQLEvent.BEGIN , onBegin );
			
			processNext();
		}
		
		public function commitTransaction () : void
		{
			_connection.addEventListener( SQLEvent.COMMIT , onCommit );
			_connection.commit()	
		}
		
		protected function onCommit ( event : SQLEvent ) : void
		{
			logger.debug( "Transaction Commited" );
			
			// remove the event listener now the event has fired
			_connection.removeEventListener( SQLEvent.COMMIT , onCommit );
			
			dispatchEvent( new StatementQueueEvent ( StatementQueueEvent.COMPLETE , this ) );
		}
		
		public function rollbackTransaction () : void
		{
			_connection.addEventListener( SQLEvent.ROLLBACK , onRollback );
			_connection.rollback()
		}
		
		protected function onRollback ( event : SQLEvent ) : void
		{
			_connection.removeEventListener( SQLEvent.ROLLBACK , onRollback );
			
			// perform some ending/canceling action
		}
		
		protected function onOpen ( event : SQLEvent ) : void
		{
			logger.debug( "Connection Open" );
			
			// remove the event as it has now fired
			_connection.removeEventListener( SQLEvent.OPEN , onOpen );
			
			dispatchEvent( new StatementQueueEvent ( StatementQueueEvent.OPEN , this ) );
		}
		
		protected function onExecuteResult ( event : StatementExecutorEvent ) : void
		{
			// remove the executor event listeners
			removeEventListeners( event.getStatementExecutor() );
			
			// executing statement complete
			_executing = false;
			
			// proccess the next item in the queue
			processNext()
		}
		
		protected function onExecuteFault ( event : StatementExecutorEvent ) : void
		{
			// remove the executor event listeners
			removeEventListeners( event.getStatementExecutor() );
			
			// cancel operation
			errorProcessingQueue();
		}
		
		protected function removeEventListeners ( executor : StatementExecutor ) : void
		{ 
			executor.removeEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
			executor.removeEventListener( StatementExecutorEvent.FAULT , onExecuteFault );
		}
		
		public function setConnectionPool ( connectionPool : ConnectionPool ) : void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool () : ConnectionPool
		{
			return _connectionPool;
		}
		
		public function setTransactional ( transactional : Boolean ) : void
		{
			_transactional = transactional;
		}
		
		public function getTransactional ( ) : Boolean
		{
			return _transactional;
		}
	}
}