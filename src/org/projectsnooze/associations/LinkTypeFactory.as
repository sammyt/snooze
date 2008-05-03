package org.projectsnooze.associations
{
	public interface LinkTypeFactory
	{
		function getLinkType ( name : String , owner : Boolean = true ) : LinkType;
	}
}