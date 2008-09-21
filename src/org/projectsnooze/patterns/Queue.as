package org.projectsnooze.patterns
{
	/**
	 * A queue is a way of grouping actions which need
	 *	to be performed one after another.  Queues contain
	 *	queue elements, queues are also element, so queues can
	 *	be created out of queues.
	 *
	 * 
	 *	 @author Samuel Williams
	 *  @since  16.07.2008
	 */
	public interface Queue
	{
		/**
		*	Adds a queue element to the end of the queue
		*	
		*	@param element:Queue the element to add
		*/	
		function addElement( element:Queue ):void;
		
		/**
		*	Called when an element in the queue has started
		*	
		*	@param element:Queue the element that has started
		*/	
		function onElementStart( element:Queue ):void;
		
		/**
		*	Called when an element in the queue has finished
		*	
		*	@param element:Queue the element that has finished
		*/
		function onElementFinish( element:Queue ):void;
		
		/**
		*	This begins the execution of the element
		*/	
		function start():void;
		
		/**
		*	Stops the execution of the elements.  Calling start
		*	after a stop begins execution at the point in the 
		*	queue that it stopped
		*/	
		function stop():void;
		
		/**
		*	When an element is added to a queue to is given
		*	a reference to that queue by the queue.  This is so 
		*	the element can inform the queue of when it begin
		*	and finished working
		*	
		*	@param queue:Queue the queue its been added to
		*/	
		function addedToQueue( queue:Queue ):void;
	}
}