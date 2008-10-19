
/* 
 * The MIT License
 * 
 * Copyright (c) 2008 Samuel Williams
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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