package domain
{
	[Entity]
	public class Concern
	{
		private var _id : int;
		
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

	}
}