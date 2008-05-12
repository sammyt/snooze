package org.projectsnooze.impl.execute
{
	import flash.events.Event;
	
	import org.projectsnooze.execute.StatementExecutor;

	public class StatementExecutorEvent extends Event
	{
		public static const RESULT : String = "executeResult";
		public static const FAULT : String = "executeFault";;
		
		private var _statementExecutor : StatementExecutor;
		
		public function StatementExecutorEvent( type : String , statementExecutor : StatementExecutor )
		{
			_statementExecutor = statementExecutor;
			super( type , false , false );
		}
		
		public function getStatementExecutor () : StatementExecutor
		{
			return _statementExecutor;
		}
	}
}