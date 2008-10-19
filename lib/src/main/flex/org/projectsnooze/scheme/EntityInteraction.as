package org.projectsnooze.scheme 
{
	import uk.co.ziazoo.reflection.NameReference;
		
	public interface EntityInteraction
	{
		function setValue( reflection:NameReference, value:Object , entity:Object ):void;
   
		function getValue( reflection:NameReference, entity:Object ):Object;
	}
}