
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
	import com.lbi.queue.IQueue;
	
	import org.projectsnooze.connections.RequiresConnection;
	
	/**
	 * Executes the SQL contained in a <code>StatementWrapper</code
	 * against the connection provided
	 * 
	 * @author Samuel Williams
	 * @since 25.08.08
	 */ 
	public interface StatementExecutor extends RequiresConnection, IQueue
	{
		/**
		 * Sets the <code>StatementWrapper</code> which contain the sql
		 * the SQL that should be executed
		 */ 
		function setStatementWrapper( statementWrapper:StatementWrapper ):void;
		
		/**
		 * executes a <code>SQLStament</code> against the connection provided
		 * using the SQL found in the <code>StatementWrapper</code>
		 */ 
		function execute ():void;
	}
}