package org.projectsnooze.impl.execute
{
	import flash.events.Event;
	
	import org.projectsnooze.execute.StatementQueue;

	public class StatementQueueEvent extends Event
	{
		public static const COMPLETE : String = "queueComplete";
		
		private var _queue : StatementQueue
		
		public function StatementQueueEvent( type : String , queue : StatementQueue )
		{
			super( type , false , false );
			_queue = queue;
		}
		
		public function getStatementQueue () : StatementQueue
		{
			return _queue;
		}
	}
}