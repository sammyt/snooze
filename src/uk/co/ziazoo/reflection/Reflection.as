package uk.co.ziazoo.reflection 
{
	public interface Reflection
	{
		function reflect():void;
		
		function getVariables():Array;
		
		function getMethods():Array;
		
		function getAccessors():Array;
		
		function addMetaData( metaData:XMLList, list:MetaDataList ):void;
		
		function getPropertiesWithType( genre:Class = null ):Array;
	}
}