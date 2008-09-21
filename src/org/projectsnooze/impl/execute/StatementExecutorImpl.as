
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
	import org.projectsnooze.impl.patterns.QueueImpl;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.generator.Statement;
	
	/**
	 * Given a <code>StatementWrapper</code> and a <code>SQLConnection</code>
	 * StatementExecutorImpl will create a <code>SQLStatement</code> object
	 * ad execute it.  Once the SQL has executed the result is passed onto
	 * the responder from the <code>StatementWrapper</code>
	 * 
	 * @author Samuel Williams
	 * @since 25.08.08
	 */
	public class StatementExecutorImpl extends QueueImpl implements StatementExecutor
	{
		/**
		 * @private
		 */ 
		protected var _sqlStatement:SQLStatement;
		
		/**
		 * @private
		 */
		protected var _conection:SQLConnection;
		
		/**
		 * @private
		 */
		protected var _statementWrapper:StatementWrapper;
		
		/**
		 * Creates instance of <code>StatementExecutorImpl</code>
		 */ 
		public function StatementExecutorImpl()
		{
		}
		
		override public function start():void
		{
			execute();
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			_sqlStatement = new SQLStatement();
			
			_sqlStatement.addEventListener( SQLEvent.RESULT , onResult );
			_sqlStatement.addEventListener( SQLErrorEvent.ERROR , onFault );
			
			_sqlStatement.sqlConnection = getConnection();
			_sqlStatement.text = getStatement().getSQL();
			
			trace( "StatementExecutorImpl::execute" , getStatement().getSQL() );
			
			_sqlStatement.execute();
		}
		
		private function onResult ( event:SQLEvent ):void
		{
			if ( getResponder() ) 
			{
				getResponder().result( _sqlStatement.getResult() );
			}
			onComplete();
		}
		
		private function onFault ( event:SQLErrorEvent ):void
		{
			if ( getResponder() ) 
			{
				getResponder().fault( event );
			}
			onComplete();
		}
		
		private function onComplete():void
		{
			cleanup();
			super.start();
		}
		
		private function cleanup():void
		{
			_sqlStatement.removeEventListener( SQLEvent.RESULT , onResult );
			_sqlStatement.removeEventListener( SQLErrorEvent.ERROR , onFault );
		}
		
		private function getResponder():Responder
		{
			return _statementWrapper.getResponder();
		}
		
		private function getStatement():Statement
		{
			return _statementWrapper.getStatement();
		}
		
		/**
		 * @inheritDoc
		 */
		public function setConnection ( connection:SQLConnection ):void
		{
			_conection = connection;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getConnection ():SQLConnection
		{
			return _conection;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function setStatementWrapper( statementWrapper:StatementWrapper ):void
		{
			_statementWrapper = statementWrapper;
		}
		
	}
}