package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	
	public interface MetaDataList 
	{
		function addMedataData( metaData:MetaData ):void;
		
		function hadMetaData( name:String ):Boolean;
		
		function getMetaDataByName( name:String ):MetaData;
		
		function getMetaDataIterator():Iterator;
	}
}

