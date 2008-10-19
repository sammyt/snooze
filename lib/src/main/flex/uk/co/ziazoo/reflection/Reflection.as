package uk.co.ziazoo.reflection 
{
	/**
	*	Generates an object hierarchy based on the 
	*	output of flash.utils.describeType
	*/	
	public interface Reflection 
		extends NameAndTypeReference, MetaDataList
	{
		/**
		*	Get the class name of the object.  For a
		*	object with a fully qualified name of 
		*	some.domain::MyClass this returns MyCLass
		*	
		*	@return the class name
		*/
		function getClassName():String;
		
		/**
		*	Generates the reflection data
		*/	
		function reflect():void;
		
		/**
		*	returns an array of <code>Variable</code> objects
		*	representing the public variables of the object
		*	
		*	returns Array of <code>Variable</code>'s
		*/	
		function getVariables():Array;
		
		function getMethods():Array;
		
		function getAccessors():Array;
		
		function createMetaData( 
			metaData:XMLList, list:MetaDataList ):void;
		
		function getPropertiesWithType( type:String = null ):Array;
		
		function getPropertiesWithMetaData( name:String = null ):Array;
		
		function getPropertyByName( name:String ):NameAndTypeReference;
	}
}
