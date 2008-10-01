package uk.co.ziazoo.reflection 
{
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.collections.ArrayIterator;
	
	public class MethodImpl implements Method
	{	
		protected var _name:String;
		protected var _type:String;
		protected var _metaData:Array;
		
		public function MethodImpl()
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
		
		public function addMetaData( data:MetaData ):void
		{
			metaData.push( data );
		}
		
		public function hasMetaData( name:String = null ):Boolean
		{
			if( !name )
			{
				return metaData.length > 0;
			}
			return getMetaDataByName( name ) != null;
		}
		
		public function getMetaDataByName( name:String ):MetaData
		{
			for each( var data:MetaData in _metaData )
			{
				if( data.getName() == name )
				{
					return data;
				}
			}
			return null;
		}
		
		protected function get metaData():Array
		{
			if( !_metaData )
			{
				_metaData = new Array();
			}
			return _metaData;
		}
		
		public function getMetaDataIterator():Iterator
		{
			return new ArrayIterator( _metaData );
		}
	}
}

