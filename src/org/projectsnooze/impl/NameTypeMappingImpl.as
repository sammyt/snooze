package org.projectsnooze.impl
{
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.datatype.Type;
	
	
	public class NameTypeMappingImpl implements NameTypeMapping 
	{
		private var _name : String;
		private var _type : Type;
		private var _value : Object;
		private var _isPrimaryKey : Boolean = false;
		
		public function NameTypeMappingImpl ()
		{
		}
		
		public function isPrimaryKey () : Boolean
		{
			return _isPrimaryKey;
		}
		
		public function setIsPrimaryKey ( value : Boolean ) : void
		{
			_isPrimaryKey = value;
		}
		
		public function getIsPrimaryKey () : Boolean
		{
			return _isPrimaryKey;
		}
		
		public function setName ( name : String ) : void
		{
			_name = name;
		}
		
		public function getName () : String
		{
			return _name;
		}
		
		public function setType ( type : Type ) : void
		{
			_type = type;
		}
		
		public function getType () : Type
		{
			return _type;
		}
		
		public function getValue () : Object
		{
			return _value;
		}
		
		public function setValue ( value : Object ) : void
		{
			_value = value;
		}
		
		public function getLowerCaseName () : String
		{
			return getName().toLowerCase();
		}
		
	}

}