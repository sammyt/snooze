package uk.co.ziazoo.reflection 
{
	public interface Reflection 
		extends NameAndTypeReference, MetaDataList
	{
		function getClassName():String;
		
		function reflect():void;
		
		function getVariables():Array;
		
		function getMethods():Array;
		
		function getAccessors():Array;
		
		function createMetaData( metaData:XMLList, list:MetaDataList ):void;
		
		function getPropertiesWithType( type:String = null ):Array;
		
		function getPropertiesWithMetaData( name:String = null ):Array;
		
		function getPropertyByName( name:String ):NameAndTypeReference;
	}
}