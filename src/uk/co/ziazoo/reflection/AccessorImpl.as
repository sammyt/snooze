package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.collections.ArrayIterator;
	
	public class AccessorImpl implements Accessor
	{
	   protected var _name:String;
	   protected var _type:String;
		protected var _access:String;
	   protected var _metaData:Array;
	
		public function AccessorImpl()
		{
		}
		
		public function getName():String
		{ 
			return _name; 
		}
      
		public function setName( name:String ):void
		{
			_name = name;
		}
      
		public function getType():String
		{
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
      
		public function hadMetaData( name:String = null ):Boolean
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
		
		public function getAccess():String
		{
			return _access;
		}
		
		public function setAccess( access:String ):void
		{
			_access = access;
		}
		
		public function read():Boolean
		{
			if ( getAccess() == "readwrite" 
			 	|| getAccess() == "read" )
			{
				return true;
			}
			return false;
		}
		
		public function write():Boolean
		{
			if ( getAccess() == "readwrite" 
			 	|| getAccess() == "write" )
			{
				return true;
			}
			return false;
		}
		
		public function readWrite():Boolean
		{
			if ( getAccess() == "readwrite" )
			{
				return true;
			}
			return false;
		}
	}
}

