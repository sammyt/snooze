package domain
{
	[Entity]
	public class SchoolClass
	{
		private var _id : int;
		private var _pupils : Array;
		
		public function SchoolClass()
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
		
		public function addChild ( child : Child ) : void
		{
			if ( _pupils == null ) _pupils = new Array();
			_pupils.push( child );
		}
		
		[OneToMany(many="domain::Child")]
		public function getPupils () : Array
		{
			return _pupils;
		}
		
		public function setPupils ( pupils : Array ) : void
		{
			_pupils = pupils;
		}

	}
}