package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	
	public interface MetaData extends NameReference
	{
		function addArg( key:String, value:String ):void;
		
		function hasArg( key:String ):Boolean;
		
		function getArgByKey( key:String ):String;
		
		function getArgsIterator():Iterator;
	}
}

