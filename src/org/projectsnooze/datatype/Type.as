package org.projectsnooze.datatype
{
	public interface Type
	{
		function getSQLType () : String; 
		
		function setSQLType ( type : String ) : void;
		
		function getASType () : String;
		
		function setASType ( type : String ) : void;
		
		function toString () : String;
	}
}