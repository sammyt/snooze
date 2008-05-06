package org.projectsnooze.execute
{
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.generator.Statement;
	
	public interface StatementExecutor
	{
		function setConnectionPool ( connectionPool : ConnectionPool ) : void;
		
		function getConnectionPool () : ConnectionPool;
		
		function setStatement ( statement : Statement ) : void;
		
		function getStatement () : Statement;
		
		function setResponder ( responder : Responder ) : void;
		
		function getResponder () : Responder;
		
		function execute () : void; 
	}
}