
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
	import flash.events.SQLEvent;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;

	public class StatementQueueImpl implements StatementQueue
	{
		protected var _queue : Array;
		protected var _transactional : Boolean;
		protected var _iterator : Iterator;
		protected var _connectionPool : ConnectionPool;
		protected var _connection : SQLConnection;
		
		public function StatementQueueImpl()
		{
			_queue = new Array();
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

		public function addToExecutionQueue( wrapper : StatementWrapper ):void
		{
			_queue.push( wrapper );
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
			_connection.addEventListener( SQLEvent.OPEN , onConnectionOpen );
			_connection.open( getConnectionPool().getFile() );
		}
		
		public function beginProcessingQueue():void
		{
			_iterator = new ArrayIterator( _queue );
		}
		
		public function finishProcessingQueue () : void
		{
			
		}
		
		public function processNext () : void
		{
			var wrapper : StatementWrapper = _iterator.next() as StatementWrapper;
			var executor : StatementExecutor = new StatementExecutorImpl();
			
			executor.setResponder( wrapper.getResponder() );
			executor.setStatement( wrapper.getStatement() );
			
			executor.addEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
			executor.addEventListener( StatementExecutorEvent.FAULT , onExecuteFault );
			
			executor.execute();
		}
		
		public function beginTransaction () : void
		{
			
		}
		
		public function commitTransaction () : void
		{
			
		}
		
		public function rollbackTransaction () : void
		{
			
		}
		
		private function onConnectionOpen ( event : SQLEvent ) : void
		{
			beginProcessingQueue();
		}
		
		private function onExecuteResult ( event : StatementExecutorEvent ) : void
		{
			removeEventListeners( event.getStatementExecutor() );
		}
		
		private function onExecuteFault ( event : StatementExecutorEvent ) : void
		{
			removeEventListeners( event.getStatementExecutor() );
		}
		
		private function removeEventListeners ( executor : StatementExecutor ) : void
		{ 
			executor.removeEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
			executor.removeEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
		}
	}
}