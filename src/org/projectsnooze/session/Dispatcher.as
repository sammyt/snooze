package org.projectsnooze.session
{
	import flash.events.IEventDispatcher;
	
	import org.projectsnooze.events.AbstractSnoozeEvent;
	import org.projectsnooze.execute.StatementQueue;
	
	/**
	 * Dispatcher caches StatementQueues against the events
	 * that should be dispatched in the event of a success
	 * or a failure
	 * 
	 * @author Samuel Williams
	 * @since 31.08.08
	 */ 
	public interface Dispatcher extends IEventDispatcher
	{
		/**
		 * Caches a StatementQueue against the events that
		 * should be dispatched when the queue is complete
		 * 
		 * @param queue:StatementQueue the queue in question
		 * @param successEvent:AbstractSnoozeEvent the event to dispatch 
		 * if the queue executes successfully
		 * @param failEvent:AbstractSnoozeEvent the event to dispatch
		 * should the queue fail to execute
		 */ 
		function addTrigger( queue:StatementQueue , 
			successEvent:AbstractSnoozeEvent , failEvent:AbstractSnoozeEvent = null ):void;
		
		/**
		 * The queue has completed so the relevent event should be 
		 * dispatched
		 * 
		 * @param queue:StatementQueue the queue that has finished
		 * @param success:Boolean true is the StatementQueue was able to
		 * execute successfully, else false
		 */ 
		function trigger( queue:StatementQueue , success:Boolean ):void;
	}
}