package org.projectsnooze.associations
{
	import org.projectsnooze.scheme.EntityDataMap;
	
	public interface Relationship
	{
		
		function setType ( type : LinkType ) : void;
		
		function getType () : LinkType;
		
		function setEntityDataMap ( dataMap : EntityDataMap ) : void;
		
		function getEntityDataMap () : EntityDataMap;
		
		function setPropertyName ( name : String ) : void;
		
		function getPropertyName () : String;
		
	}
}