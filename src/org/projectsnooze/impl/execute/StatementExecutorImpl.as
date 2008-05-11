
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
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.generator.Statement;

	public class StatementExecutorImpl implements StatementExecutor
	{
		private var _connectionPool : ConnectionPool;
		private var _statement : Statement;
		private var _conection : SQLConnection;
		private var _responder : Responder
		
		public function StatementExecutorImpl()
		{
		}
		
		public function execute():void
		{
			var sqlStatement : SQLStatement = new SQLStatement();
			
			sqlStatement.addEventListener( SQLEvent.RESULT , onResult );
			sqlStatement.addEventListener( SQLErrorEvent.ERROR , onFault );
			
			sqlStatement.sqlConnection = getConnection();
			sqlStatement.text = getStatement().getSQL();
			
			sqlStatement.execute( -1 );
		}
		
		private function onResult ( event : SQLEvent ) : void
		{
			
			
		}
		
		private function onFault ( event : SQLErrorEvent ) : void
		{
			
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