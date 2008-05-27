
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

package org.projectsnooze.execute
{
	import flash.events.IEventDispatcher;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.generator.Statement;
	
	public interface StatementQueue extends IEventDispatcher
	{
		function setConnectionPool ( connectionPool : ConnectionPool ) : void;
		
		function getConnectionPool () : ConnectionPool;
		
		function setTransactional ( transactional : Boolean ) : void;
		
		function getTransactional ( ) : Boolean;
		
		function addToExecutionQueue( wrapper : StatementWrapper ):void
		
		function setAllStatementsAdded ( allAdded : Boolean ) : void;
		
		function areAllStatementsAdded () : Boolean;
		
		function isInQueue ( statement : Statement ) : Boolean;
		
		function openConnection () : void;
		
		function beginProcessingQueue () : void;
		
		function finishProcessingQueue () : void;
		
		function errorProcessingQueue () : void;
		
		function processNext () : void;
		
		function beginTransaction () : void;
		
		function commitTransaction () : void;
		
		function rollbackTransaction () : void;
	}
}