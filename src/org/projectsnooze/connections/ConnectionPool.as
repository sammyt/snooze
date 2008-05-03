package org.projectsnooze.connections
{
	import flash.data.SQLConnection;
	
	public interface ConnectionPool
	{
		function getConnection () : SQLConnection;
		
		function setMaxConnections ( maxConnections : uint ) : void;
		
		function getMaxConnections () : uint;
		
		function setMinConnections ( minConnections : uint ) : void;
		
		function getMinConnections () : uint; 
	}
}