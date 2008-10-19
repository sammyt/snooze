package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	
	public interface ParameterList
	{
		function addParameter( param:Parameter ):void;
		
		function getParameterIterator():Iterator;
	}
}

