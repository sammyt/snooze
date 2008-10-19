package org.projectsnooze.events
{
	public class SessionEvent extends AbstractSnoozeEvent
	{
		public static const DATABASE_CREATED:String = "databaseCreated";
		
		public function SessionEvent( type:String )
		{
			super( type , false , false );
		}
	}
}