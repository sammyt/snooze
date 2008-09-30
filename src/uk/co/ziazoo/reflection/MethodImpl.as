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
	}
}

