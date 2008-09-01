
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
 
package org.projectsnooze.impl.session
{
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.patterns.Observer;
	import org.projectsnooze.session.Dispatcher;
	import org.projectsnooze.session.Session;
	import org.projectsnooze.events.SessionEvent;
	
	/**
	 * Concrete implementation of the <code>Session</code>
	 * interface.  Manages the saveing and retrieveing of 
	 * entitys to the database etc
	 * 
	 * @author Samuel Williams
	 * @since 31.08.08
	 */ 
	public class SessionImpl implements Session, Observer
	{
		protected var _dependencyTreeCreator:DependencyTreeCreator;
		protected var _queueManager:QueueManager;
		protected var _ddlGenerator:DDLGenerator;
		protected var _dispatcher:Dispatcher;
		
		/**
		 * Creates instance of <code>SessionImpl</code>
		 */ 
		public function SessionImpl()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function createDatabase ():void
		{
			var queue:StatementQueue = getQueueManager().getStatementQueue();

			var success:SessionEvent = new SessionEvent( SessionEvent.DATABASE_CREATED );
			getDispatcher().addTrigger( queue , success );
			
			var statements:Array = getDDLGenerator().getDDLStatements();
			for ( var i:Iterator = new ArrayIterator( statements ) ; i.hasNext() ; )
			{
				queue.add( new StatementWrapperImpl( i.next() as Statement ) );
			}
			
			queue.setFull( true );
		}
		
		/**
		 * @inheritDoc
		 */
		public function dropDatabase ():void
		{
			var queue:StatementQueue = getQueueManager().getStatementQueue();
			var statements:Array = getDDLGenerator().getDropStatements();
			
			for ( var i:Iterator = new ArrayIterator( statements ) ; i.hasNext() ; )
			{
				queue.add( new StatementWrapperImpl( i.next() as Statement ) );
			}
			
			queue.setFull( true );
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function save( entity:Object ):void
		{
			var depTree:DependencyTree = 
				getDependencyTreeCreator().getSaveDependencyTree( entity );
			
			depTree.begin();
		}
		
		/**
		 * @inheritDoc
		 */
		public function update ( obj:Object = null ):void
		{
			trace( "SessionImpl::update" , obj );
			getDispatcher().trigger( obj as StatementQueue , true );
		} 
		
		public function getDependencyTreeCreator ():DependencyTreeCreator
		{
			return _dependencyTreeCreator;
		}
		
		public function setDependencyTreeCreator ( dependencyTreeCreator:DependencyTreeCreator ):void
		{
			_dependencyTreeCreator = dependencyTreeCreator;
		}
		
		public function getQueueManager ():QueueManager
		{
			return _queueManager;
		}
		
		public function setQueueManager ( queueManager:QueueManager ):void
		{
			_queueManager = queueManager;
			getQueueManager().registerObserver( this );
		}
		
		public function getDDLGenerator():DDLGenerator
		{
			return _ddlGenerator;
		}
		
		public function setDDLGenerator(ddlGenerator:DDLGenerator):void
		{
			_ddlGenerator = ddlGenerator;
		}
		
		public function getDispatcher():Dispatcher
		{
			return _dispatcher;
		}
		
		public function setDispatcher( dispatcher:Dispatcher ):void
		{
			_dispatcher = dispatcher;
		}
	}
}