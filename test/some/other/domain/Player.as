package some.other.domain
{
	public class Player
	{
		public var id:int;
		private var _firstName:String;
		private var _lastName:String;
		
		public function Player()
		{
		}
		/*
		[Id]
		public function getId ():int
		{
			return _id;
		}
		
		public function setId ( id:int ):void
		{
			_id = id;
		}
		*/
		
		public function getFirstName ():String
		{
			return _firstName;
		}
		
		public function setFirstName ( firstName:String ):void
		{
			_firstName = firstName;
		}
		
		public function getLastName ():String
		{
			return _lastName;
		}
		
		public function setLastName ( lastName:String ):void
		{
			_lastName = lastName;
		}
	}
}