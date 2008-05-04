package org.projectsnooze.utils
{
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class SnoozeLog
	{
		public static function getLogger ( obj : * ) : ILogger
		{
			return Log.getLogger( getClassName( obj ) );
		}
		
		public static function getClassName( obj : * ):String
	    {
	        var name:String = getQualifiedClassName( obj );
	        
	        // If there is a package name, strip it off.
	        var index:int = name.indexOf("::");
	        if (index != -1)
	            name = name.substr(index + 2);
	                
	        return name;
	    }
	}
}