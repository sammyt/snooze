
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
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.generator.Statement;

	public class StatementExecutorImpl extends EventDispatcher implements StatementExecutor
	{
		private static var logger : ILogger = Log.getLogger( "StatementExecutorImpl" );
		
		protected var _connectionPool : ConnectionPool;
		protected var _statement : Statement;
		protected var _sqlStatement : SQLStatement;
		protected var _conection : SQLConnection;
		protected var _responder : Responder;
		
		public function StatementExecutorImpl()
		{
		}
		
		public function execute():void
		{
			_sqlStatement = new SQLStatement();
			
			_sqlStatement.addEventListener( SQLEvent.RESULT , onResult );
			_sqlStatement.addEventListener( SQLErrorEvent.ERROR , onFault );
			
			_sqlStatement.sqlConnection = getConnection();
			_sqlStatement.text = getStatement().getSQL();
			
			_sqlStatement.execute();
			
			logger.info( "execute this sql {0}" , getStatement().getSQL() );
		}
		
		private function onResult ( event : SQLEvent ) : void
		{
			//logger.debug( "onResult {0}" , event );
			dispatchEvent( new StatementExecutorEvent ( StatementExecutorEvent.RESULT , this ) );
			if ( getResponder() ) getResponder().result( _sqlStatement.getResult() );
		}
		
		private function onFault ( event : SQLErrorEvent ) : void
		{
			//logger.debug( "onFault {0}" , event );
			dispatchEvent( new StatementExecutorEvent ( StatementExecutorEvent.FAULT , this ) );
			if ( getResponder() ) getResponder().fault( event );
		}
		
		public function setResponder ( responder : Responder ) : void
		{
			_responder = responder;
		}
		
		public function getResponder () : Responder
		{
			return _responder;
		}
		
		public function setConnection ( connection : SQLConnection ) : void
		{
			_conection = connection;
		}
		
		public function getConnection () : SQLConnection
		{
			return _conection;
		}
		
		public function setStatement(statement:Statement):void
		{
			_statement = statement;
		}
		
		public function getStatement():Statement
		{
			return _statement;
		}
		
	}
}