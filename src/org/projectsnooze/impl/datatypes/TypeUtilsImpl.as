package org.projectsnooze.impl.datatypes
{
	import flash.utils.describeType;
	
	import org.projectsnooze.datatype.TypeUtils;

	public class TypeUtilsImpl implements TypeUtils
	{
		public function TypeUtilsImpl()
		{
		}

		public function isBaseType(type:String):Boolean
		{
			return false;
		}
		
		public function isCollection( object : Object ) : Boolean
		{
			
			return isCollectionType( describeType( object ).@name );
		}
		
		public function isCollectionType(type:String):Boolean
		{
			switch ( type )
			{
				case "Array":
					return true;
					break;
			}
			return false;
		}
		
		public function getTypeFromMetadata(method:XML):String
		{
			if ( isCollectionType( method.@returnType ) )
			{
				return method.metadata.arg.@value;
			}
			else
			{
				return method.@returnType;
			}
			return null;
		}
		
	}
}