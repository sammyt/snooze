package org.projectsnooze.execute
{
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.patterns.Subject;
	
	/**
	*	A Queue manager is a <code>com.lbi.queue.Queue</code>
	*	which manages the execution of StatementQueues, which are
	*	also <code>com.lbi.queue.Queue</code> instances
	*	
	*	@author Samuel Williams
	*	@since 12.08.08
	*/	
	public interface QueueManager extends Subject
	{
		/**
		*	Provides a new emply <code>StatementQueue</code>
		*	which can be provided to a <code>DependencyTree</code>
		*	
		*	@return statementQueue:StatementQueue the queue
		*/	
		function getStatementQueue ():StatementQueue;
		
		/**
		*	Sets the instance of <code>ConnectionPool</code>
		*	for the application.
		*	
		*	@param connectionPool:ConnectionPool the pool
		*/	
		function setConnectionPool ( connectionPool:ConnectionPool ):void;
		
	}
}