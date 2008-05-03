package org.projectsnooze.session
{
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public interface Session
	{
		function save ( entity : Object ) : Object;
		
		function retrieve ( entity : Object  ) : Object;
		
	}
}