package org.projectsnooze.execute
{
	import org.projectsnooze.connections.ConnectionPool;
	
	public interface QueueManager
	{
		function getQueue () : StatementQueue;
		
		function setConnectionPool ( connectionPool : ConnectionPool ) : void;
		
		function getConnectionPool () : ConnectionPool;
		
		function processNext () : void;
		
		function removeFromQueue ( statementQueue : StatementQueue ) : void;
		
	}
}