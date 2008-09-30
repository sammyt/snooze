package uk.co.ziazoo.reflection 
{
	import flash.utils.describeType;
	
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.collections.ArrayIterator;
	
	public class ReflectionImpl implements Reflection
	{
		protected var _name:String;
		protected var _type:String;
		protected var _metaData:Array;
		protected var _object:Object;
		protected var _description:XML;
		protected var _variables:Array;
		protected var _methods:Array;
		protected var _accessors:Array;
		protected var _all:Array;
		
		public function ReflectionImpl( object:Object )
		{
			_object = object;
			_description = describeType( _object );
			createMetaData( _description.metadata , this );
		}
		
		public function getClassName():String
		{
			return getName().substr( getName().indexOf( "::" ) + 2 , 
				getName().length - getName().indexOf("::") );
		}
		
		public function getName():String
		{ 
			if( !_name )
			{
				setName( _description.@name );
			}
			return _name; 
		}
      
		public function setName( name:String ):void
		{
			_name = name;
		}
      
		public function getType():String
		{
			if( !_type )
			{
				 setType( _description.@type );
			}
			return _type;
		}
      
		public function setType( type:String ):void
		{
			_type = type;
		}
      
		public function addMetaData( metaData:MetaData ):void
		{
			_metaData.push( metaData );
		}
      
		public function hasMetaData( name:String = null ):Boolean
		{
			if( !name )
			{
				return _metaData.length > 0;
			}
			return getMetaDataByName( name ) != null;
		}
      
		public function getMetaDataByName( name:String ):MetaData
		{
			for each( var metaData:MetaData in _metaData )
			{
				if( metaData.getName() == name )
				{
					return metaData;
				}
			}
			return null;
		}
      
		public function getMetaDataIterator():Iterator
		{
			return new ArrayIterator( _metaData );
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
				
				createMetaData( methodData.metadata , method );
				
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
				
				createMetaData( accessorData.metaData , accessor );
				
				_accessors.push( accessor );
			}
			return _accessors;
		}
		
		public function createMetaData( metaDataXMLList:XMLList, list:MetaDataList ):void
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
		
		public function getPropertiesWithType( type:String = null ):Array
		{
			var i:Iterator = new ArrayIterator( getAllProperties() );
			
			var haveType:Array = new Array();
			
			for( ; i.hasNext() ; )
			{
				var prop:NameAndTypeReference = i.next() as NameAndTypeReference;
				if( prop.getType() != "void" )
				{
					if( type )
					{
						if( type == prop.getType() )
						{
							haveType.push( prop );
						}
					}
					else
					{
						haveType.push( prop );	
					}
				}
			}
			return haveType;
		}
		
		public function getPropertiesWithMetaData( name:String = null ):Array
		{
			var i:Iterator = new ArrayIterator( getAllProperties() );
			
			var haveMetaData:Array = new Array();
			
			for( ; i.hasNext() ; )
			{
				var metaDataList:MetaDataList = i.next() as MetaDataList;
				if( metaDataList.hasMetaData( name ) )
				{
					haveMetaData.push( metaDataList );
				}
			}
			return haveMetaData;
		}
		
		public function getPropertyByName( name:String ):NameAndTypeReference
		{
			var i:Iterator = new ArrayIterator( getAllProperties() );
			
			for( ; i.hasNext() ; )
			{
				var prop:NameAndTypeReference = i.next() as NameAndTypeReference;
				if( prop.getName() == name )
				{
					return prop;
				}
			}
			return null;
		}
		
		protected function getAllProperties():Array
		{
			if( !_all )
			{
				if( !_accessors )
				{
					getAccessors();
				}
				if( !_methods )
				{
					getMethods();
				}
				if( !_variables )
				{
					getVariables();
				}

				_all = new Array();
				addElements( _all , _accessors );
				addElements( _all , _methods );
				addElements( _all , _variables );	
			}
			return _all;
		}
		
		protected function addElements( list:Array, toAdd:Array ):void
		{
			for( var i:Iterator = new ArrayIterator( toAdd ); i.hasNext() ; )
			{
				list.push( i.next() );
			}
		}
	}
}

