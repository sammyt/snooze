package org.projectsnooze.scheme
{
	import org.projectsnooze.patterns.Iterator;
	
	public interface EntityDataMapProvider
	{
		function getEntityDataMap ( entity : Object ) : EntityDataMap
		
		function setEntityDataMap ( name : String , dataMap : EntityDataMap ) : void;
		
		function getEntityDataMapByClassName ( name : String ) : EntityDataMap;
		
		function getIterator () : Iterator;
	}
}