package uk.co.ziazoo.reflection 
{
	public class VariableImpl implements Variable
	{
		private var _name:String;
		private var _type:String;
		
		public function VariableImpl()
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
	}
}

