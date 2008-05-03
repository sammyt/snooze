package org.projectsnooze
{
	import org.projectsnooze.datatype.Type;
	
	public interface NameTypeMapping
	{
		function isPrimaryKey () : Boolean;
		
		function setIsPrimaryKey ( value : Boolean ) : void;
		
		function getIsPrimaryKey () : Boolean;
		
		function setName ( name : String ) : void;
		
		function getName () : String;
		
		function setType ( type : Type ) : void;
		
		function getType () : Type;
		
		function getLowerCaseName () : String;
	
	}
}