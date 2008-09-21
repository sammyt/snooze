package org.projectsnooze.impl.patterns
{
	import org.projectsnooze.patterns.Queue;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	
	/**
	 *  Instance of Queue.  Can be used to queue
	 *	 the execution of any Queue
	 *
	 *  @author Samuel Williams
	 *	
	 *  @since  16.07.2008
	 */
	public class QueueImpl implements Queue
	{
		protected var _elements:Array;
		protected var _queues:Array;
		protected var _paused:Boolean;
		
		public function QueueImpl()
		{
			_elements = new Array();
			_queues = new Array();
			_paused = false;
		}
		
		/**
		*	@inheritDoc
		*/	
		public function start():void
		{
			_paused = false;
			
			// notify any containing queues this queue has started
			onStart();
			
			if ( _elements.length > 0 )
			{
				// process the first element
				processNext();
			}
			else
			{
				// there are no elements, so the queue is finished
				onFinish();
			}
		}
		
		/**
		*	@inheritDoc
		*/
		public function stop():void
		{
			_paused = true;
		}
		
		/**
		*	@private
		*	
		*	Notifies any queues containing the element that
		*	the element has stated its actions.
		*/	
		protected function onStart():void
		{
			for ( var j:Iterator = new ArrayIterator( _queues ) ; j.hasNext() ; )
			{
				var queue:Queue = j.next() as Queue;
				queue.onElementStart( this );
			}
		}
		
		/**
		*	@private
		*	
		*	Notifies any queues containing the element that
		*	the element has finished its actions.
		*/
		protected function onFinish():void
		{
			for ( var j:Iterator = new ArrayIterator( _queues ) ; j.hasNext() ; )
			{
				var queue:Queue = j.next() as Queue;
				queue.onElementFinish( this );
			}
		}
		
		protected function processNext ():void
		{
			var iterator:Iterator = new ArrayIterator( _elements );
			
			// get the first element form the list of elements
			var element:Queue = iterator.next() as Queue;
			
			// remove the element from the queue
			//iterator.remove();
			
			// start the element
			element.start();
		}
		
		/**
		*	@inheritDoc
		*/
		public function addElement( element:Queue ):void
		{
			_elements.push( element );
			element.addedToQueue( this );
		}	
		
		/**
		*	@inheritDoc
		*/
		public function addedToQueue( queue:Queue ):void
		{
			_queues.push( queue );
		}
		
		/**
		*	@inheritDoc
		*/
		public function onElementStart( queue:Queue ):void
		{
		}
		
		/**
		*	@inheritDoc
		*/
		public function onElementFinish( queue:Queue ):void
		{
			var i:Iterator = new ArrayIterator( _elements );
			for ( ; i.hasNext() ; )
			{
				var element:Queue = i.next() as Queue;
				if ( element == queue )
				{
					i.remove();
					break;
				}
			}
			
			if ( _elements.length > 0 && !_paused )
			{
				// if there more elements then process them
				processNext();				
			}
			else
			{
				// if there are no more elements the queue is finished
				onFinish();
			}
		}
	}
}