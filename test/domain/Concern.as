package domain
{
	[Entity]
	public class Concern
	{
		private var _id : int;
		private var _concern : String;
		
		public function Concern()
		{
		}
		
		[Id]
		public function getId () : int
		{
			return _id;
		}
		
		public function setId ( id : int ) : void
		{
			_id = id;
		}
		
		public function getConcern () : String
		{
			return _concern;
		}
		
		public function setConcern ( concern : String ) : void
		{
			_concern = concern;
		}

	}
}