package org.projectsnooze.execute
{
	import org.projectsnooze.generator.Statement;
	
	public interface StatementWrapper
	{
		function setResponder ( responder:Responder ):void;
		
		function getResponder ():Responder;
		
		function setStatement ( statement:Statement ):void;
		
		function getStatement ():Statement;
	}
}