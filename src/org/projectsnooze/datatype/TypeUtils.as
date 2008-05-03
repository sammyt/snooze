package org.projectsnooze.datatype
{
	public interface TypeUtils
	{
		function isBaseType ( type : String ) : Boolean;
		
		function isCollection ( object : Object ) : Boolean;
		
		function isCollectionType ( type : String ) : Boolean;
		
		function getTypeWithinCollection ( method : XML ) : String;
	}
}