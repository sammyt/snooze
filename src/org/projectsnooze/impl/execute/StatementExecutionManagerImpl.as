
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
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.execute.StatementExecutionManager;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.generator.Statement;

	public class StatementExecutionManagerImpl implements StatementExecutionManager
	{
		private static var logger : ILogger = Log.getLogger( "StatementExecutionManagerImpl" );
		
		private var _connectionPool : ConnectionPool;
		private var _queue : Array;
		private var _connection : SQLConnection;
		private var _prepared : Boolean;
		private var _executing : Boolean;
		
		public function StatementExecutionManagerImpl()
		{
			_prepared = false;
			_executing = false;
			_queue = new Array();
		}

		public function setConnectionPool( connectionPool : ConnectionPool ) : void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool () : ConnectionPool
		{
			return _connectionPool;
		}
		
		public function addToExecutionQueue( statement : Statement, responder : Responder = null ) : void
		{
			_queue.push( new StatementAndResponder( statement , responder ) );
			processQueue();
		}
		
		public function prepare () : void
		{
			_connection = getConnectionPool().getConnection();
			_connection.addEventListener( SQLEvent.OPEN , onConnectionOpen );
			_connection.openAsync( getConnectionPool().getFile() );
		}
		
		public function processQueue () : void
		{
			if ( _prepared && ! _executing && _queue.length > 0 )
			{
				var statementAndResponder : StatementAndResponder = getNext();
				
				var executor : StatementExecutor = new StatementExecutorImpl();
				executor.addEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
				executor.addEventListener( StatementExecutorEvent.FAULT , onExecuteFault );
				
				executor.setConnection( _connection );
				executor.setStatement( statementAndResponder.getStatement() );
				executor.setResponder( statementAndResponder.getResponder() );
				
				_executing = true;
				executor.execute();
			}
		}
		
		private function onExecuteResult ( event : StatementExecutorEvent ) : void
		{
			_executing = false;
			removeExecutorListeners( event.getStatementExecutor() );
		}
		
		private function onExecuteFault ( event : StatementExecutorEvent ) : void
		{
			removeExecutorListeners( event.getStatementExecutor() );
		}
		
		private function removeExecutorListeners ( executor : StatementExecutor ) : void
		{
			executor.removeEventListener( StatementExecutorEvent.RESULT , onExecuteResult );
			executor.removeEventListener( StatementExecutorEvent.FAULT , onExecuteFault );
		}
		
		private function onConnectionOpen ( event : SQLEvent ) : void
		{
			_connection.addEventListener( SQLEvent.BEGIN , onBegin );
			_connection.begin();
		}
		
		private function onBegin ( event : SQLEvent ) : void
		{
			logger.info( "onBegin" );
			_prepared = true;
			processQueue();
		}
		
		private function getNext () : StatementAndResponder
		{
			if ( _queue.length > 0 )
			{
				return _queue.pop() as StatementAndResponder;
			}
			return null;
		}
	}
}


import org.projectsnooze.generator.Statement;
import org.projectsnooze.execute.Responder;
	
class StatementAndResponder
{
	private var _statement : Statement;
	private var _responder : Responder;
	
	public function StatementAndResponder ( statement : Statement = null , responder : Responder = null ) 
	{
		_statement = statement;
		_responder = responder;
	}
	
	public function setStatement( statement : Statement ) : void
	{
		_statement = statement;
	}
	
	public function getStatement() : Statement
	{
		return _statement;
	}
	
	public function setResponder ( responder : Responder ) : void
	{
		_responder = responder;
	}
	
	public function getResponder () : Responder
	{
		return _responder;
	}
}  




