package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	
	public interface MetaDataList extends NameAndTypeReference
	{
		function addMetaData( metaData:MetaData ):void;
		
		function hasMetaData( name:String = null ):Boolean;
		
		function getMetaDataByName( name:String ):MetaData;
		
		function getMetaDataIterator():Iterator;
	}
}

