
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
	import org.projectsnooze.patterns.Queue;
	import org.projectsnooze.impl.patterns.QueueImpl;
	
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.execute.StatementQueue;
	import uk.co.ziazoo.collections.ArrayIterator;
	import uk.co.ziazoo.collections.Iterator;
	import org.projectsnooze.patterns.Observer;

	/**
	*	Instance of <code>QueueManager</code>. Used to manage
	*	the execution of <code>StatementQueue</code> objects
	*	
	*	@author Samuel Williams
	*	@since 12.08.08
	*/	
	public class QueueManagerImpl extends QueueImpl implements QueueManager
	{
		/**
		 *	@private
		 *	
		 *	connection pool for application
		 */	
		protected var _connectionPool:ConnectionPool;
		
		/**
		 * @private
		 */
		protected var _observers:Array;  
		
		/**
		*	Creates instance an of <code>QueueManagerImpl</code>
		*/	
		public function QueueManagerImpl()
		{
			_observers = new Array();
		}
		
		/**
		*	@inheritDoc
		*/	
		public function getStatementQueue():StatementQueue
		{
			// create the statement queue
			var queue:StatementQueue = new StatementQueueImpl();
			queue.setConnectionPool( _connectionPool );
			
			// add the StatementQueue to the management queue
			addElement( queue );
			
			if ( _elements.length == 1 )
			{
				processNext();
			}
			
			return queue;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function onElementFinish( queue:Queue ):void
		{
			super.onElementFinish( queue );
			notifyObservers( queue );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function registerObserver( observer:Observer ):void
		{
			_observers.push( observer );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function removeObserver( observer:Observer ):void
		{
			for( var iterator:Iterator = new ArrayIterator( _observers ); iterator.hasNext() ; )
			{
				var o:Observer = iterator.next() as Observer;
				if ( observer == o ) iterator.remove();
			}
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function notifyObservers( obj:Object=null ):void
		{
			for( var iterator:Iterator = new ArrayIterator( _observers ); iterator.hasNext() ; )
			{
				var observer:Observer = iterator.next() as Observer;
				observer.update( obj );
			}
		}
		
		/**
		*	@inheritDoc
		*/	
		public function setConnectionPool ( connectionPool:ConnectionPool ):void
		{
			_connectionPool = connectionPool;
		}
	}
}