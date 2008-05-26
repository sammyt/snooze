package org.projectsnooze.impl.execute
{
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.execute.StatementQueue;

	public class QueueManagerImpl implements QueueManager
	{
		protected var _connectionPool : ConnectionPool;
		
		public function QueueManagerImpl()
		{
		}
		
		public function setConnectionPool ( connectionPool : ConnectionPool ) : void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool () : ConnectionPool
		{
			return _connectionPool;
		}

		public function getQueue():StatementQueue
		{
			var queue : StatementQueue = new StatementQueueImpl();
			queue.setConnectionPool( getConnectionPool() ); 
			return queue;
		}
		
	}
}