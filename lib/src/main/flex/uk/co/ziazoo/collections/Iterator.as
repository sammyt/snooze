package uk.co.ziazoo.collections 
{
	public interface Iterator
	{
		function hasNext():Boolean;
	
		function next():Object;
	
		function remove ():void;
	}
}

