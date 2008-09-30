package uk.co.ziazoo.reflection 
{
	public interface Accessor 
		extends NameAndTypeReference, MetaDataList
	{
		function getAccess():String;
		function setAccess( access:String ):void;
		
		function read():Boolean;
		function write():Boolean;
		function readWrite():Boolean
	}
}

