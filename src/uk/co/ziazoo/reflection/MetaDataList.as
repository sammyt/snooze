package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	
	public interface MetaDataList 
	{
		function addMetaData( metaData:MetaData ):void;
		
		function hadMetaData( name:String ):Boolean;
		
		function getMetaDataByName( name:String = null ):MetaData;
		
		function getMetaDataIterator():Iterator;
	}
}

