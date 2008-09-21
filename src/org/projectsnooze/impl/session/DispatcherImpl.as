package org.projectsnooze.impl.session
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.projectsnooze.events.AbstractSnoozeEvent;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.session.Dispatcher;
	
	/**
	 * Used within the session to dispatch events back to the 
	 * user about the status of there actions
	 */ 
	public class DispatcherImpl extends EventDispatcher implements Dispatcher
	{
		protected var _events:Dictionary;
		
		public function DispatcherImpl()
		{
			
		}
		
		private function get events():Dictionary
		{
			if ( ! _events )
			{
				_events = new Dictionary();
			}
			return _events;
		}

		/**
		 * @inheritDoc
		 */ 
		public function addTrigger( queue:StatementQueue, 
			successEvent:AbstractSnoozeEvent, failEvent:AbstractSnoozeEvent=null ):void
		{
			var data:QueueEventMap = new QueueEventMap();
			data.successEvent = successEvent;
			data.failEvent = failEvent;
			events[ queue ] = data;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function trigger( queue:StatementQueue, success:Boolean ):void
		{
			var data:QueueEventMap = events[ queue ] as QueueEventMap;
			if ( data )	
			{
				var event:AbstractSnoozeEvent = success ? data.successEvent : data.failEvent; 

				dispatchEvent( event );

				delete event[ queue ];				
			}
		}
	}
}

import org.projectsnooze.execute.StatementQueue;
import org.projectsnooze.events.AbstractSnoozeEvent;
	
class QueueEventMap
{
	public var successEvent:AbstractSnoozeEvent;
	public var failEvent:AbstractSnoozeEvent;
}