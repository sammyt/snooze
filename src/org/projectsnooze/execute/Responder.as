package org.projectsnooze.execute
{
	public interface Responder
	{
		function result( data : Object ):void;
	
		function fault( info : Object ):void;
	}
}