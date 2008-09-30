package uk.co.ziazoo.reflection 
{
	import flash.utils.describeType;
	
	public class ReflectionImpl implements Reflection
	{
		protected var _object:Object;
		protected var _description:XML;
		protected var _variables:Array;
		protected var _methods:Array;
		protected var _accessors:Array;
		
		public function ReflectionImpl( object:Object )
		{
			_object = object;
			_description = describeType( _object );
		}
		
		public function reflect():void
		{
			var variables:Array = getVariables();
		}
		
		public function getVariables():Array
		{
			if( _variables )
			{
				return _variables;
			}
			
			_variables = new Array();
			for each( var variableData:XML in _description.variable )
			{
				var variable:Variable = new VariableImpl();
				variable.setName( variableData.@name );
				variable.setType( variableData.@type );
				_variables.push( variable );
			}
			return _variables;
		}
		
		public function getMethods():Array
		{
			if( _methods )
			{
				return _methods;
			}
			
			_methods = new Array();
			for each( var methodData:XML in _description.method )
			{
				var method:Method = new MethodImpl();
				method.setName( methodData.@name );
				method.setType( methodData.@returnType );
				
				addMetaData( methodData.metadata , method );
				
				_methods.push( method );
			}
			return _methods;
		}
		
		public function getAccessors():Array
		{
			if( _accessors )
			{
				return _accessors;
			}
			
			_accessors = new Array();
			for each( var accessorData:XML in _description.accessor )
			{
				var accessor:Accessor = new AccessorImpl();
				accessor.setName( accessorData.@name );
				accessor.setType( accessorData.@type );
				accessor.setAccess( accessorData.@access );
				
				addMetaData( accessorData.metaData , accessor );
				
				_accessors.push( accessor );
			}
			return _accessors;
		}
		
		public function addMetaData( metaDataXMLList:XMLList, list:MetaDataList ):void
		{
			for each( var metaDataXML:XML in metaDataXMLList )
			{
				var metaData:MetaData = new MetaDataImpl();
				metaData.setName( metaDataXML.@name );
				
				for each( var arg:XML in metaDataXML.arg )
				{
					metaData.addArg( arg.@key, arg.@value );
				}
			}
		}
		
		public function getPropertiesWithType( genre:Class = null ):Array
		{
			function filter( all:Array, elements:Array, genre:Class = null ):void
			{
				for each( var hasType:TypeReference in elements )
				{
					if( hasType.getType() != "void" )
					{
						if( !genre )
						{
							all.push( hasType );
						}
						else if( hasType is genre )
						{
							all.push( hasType );
						}
					}
				}
			}
			var result:Array = new Array();
			
			filter( result , getVariables() , genre );
			filter( result , getMethods() , genre );
			filter( result , getAccessors() , genre );
			
			return result;
		}
	}
}

