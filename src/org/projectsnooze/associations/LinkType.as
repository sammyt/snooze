package org.projectsnooze.associations
{
	public interface LinkType
	{
		function getName () : String;
		
		function setName ( name : String ) : void;
		
		function getForeignKeyContainer () : Boolean;
		
		function setForeignKeyContainer ( foreignKeyContainer : Boolean ) : void;
	}
}