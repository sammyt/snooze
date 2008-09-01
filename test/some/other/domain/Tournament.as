package some.other.domain
{
	public class Tournament
	{
		private var _id:int;
		private var _name:String;
		private var _clubs:Array;
		
		public function Tournament()
		{
		}

		[Id]
		public function getId ():int
		{
			return _id;
		}
		
		public function setId ( id:int ):void
		{
			_id = id;
		}
		
		public function getName ():String
		{
			return _name;
		}
		
		public function setName ( name:String ):void
		{
			_name = name;
		}
		
		[ManyToMany(ref="some.other.domain::Club")]
		public function getClubs ():Array
		{
			return _clubs;
		}
		
		public function setClubs ( clubs:Array ):void
		{
			_clubs = clubs;
		}
	}
}