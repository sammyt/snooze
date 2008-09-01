package some.other.domain
{
	public class Club
	{
		private var _id:int;
		private var _name:String;
		private var _players:Array;
		private var _tournaments:Array;
		
		public function Club()
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

		[OneToMany(ref="some.other.domain::Player")]
		public function getPlayers ():Array
		{
			return _players;
		}
		
		public function setPlayers ( players:Array ):void
		{
			_players = players;
		}
		
		[ManyToMany(ref="some.other.domain::Tournament")]
		public function getTournaments ():Array
		{
			return _tournaments;
		}
		
		public function setTournaments ( tournaments:Array ):void
		{
			_tournaments = tournaments;
		}
	}
}