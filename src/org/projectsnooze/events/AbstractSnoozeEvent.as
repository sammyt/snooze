package org.projectsnooze.events
{
	import flash.events.Event;

	public class AbstractSnoozeEvent extends Event
	{
		public function AbstractSnoozeEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
		}
	}
}