package org.projectsnooze.connections
{
	import flash.data.SQLConnection;
	
	/**
	 * Defines getter and setters for any object
	 * that requires a <code>SQLConnection</code?>
	 * 
	 * @author Samuel Williams
	 * @since 25.08.08
	 */ 
	public interface RequiresConnection
	{
		/**
		 * Set the SQLConnection instace
		 */ 
		function setConnection( connection:SQLConnection ):void;
		
		/**
		 * Returns the SQLConnection instance
		 */ 
		function getConnection():SQLConnection;		
	}
}