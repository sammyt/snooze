package org.projectsnooze.datatype
{

	public class AbstractType implements Type
	{
		private var _sqlType : String;
		private var _asType : String;
		
		public function AbstractType( sqlType : String , asType : String )
		{
			_asType = asType;
			_sqlType = sqlType;
		}

		public function getSQLType():String
		{
			return _sqlType;
		}
		
		public function setSQLType(type:String):void
		{
			_sqlType = type;
		}
		
		public function getASType():String
		{
			return _asType;
		}
		
		public function setASType(type:String):void
		{
			_asType = type;
		}
		
		public function toString () : String
		{
			return "AbstractType";
		}
		
	}
}