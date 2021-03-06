package domain
{
	[Entity]
	public class SchoolClass
	{
		private var _id:int;
		private var _pupils:Array;
		private var _name:String;
		
		public function SchoolClass()
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
		
		public function addChild ( child:Child ):void
		{
			if ( _pupils == null ) _pupils = new Array();
			_pupils.push( child );
		}
		
		[OneToMany(ref="domain::Child")]
		public function getPupils ():Array
		{
			return _pupils;
		}
		
		public function setPupils ( pupils:Array ):void
		{
			_pupils = pupils;
		}
		
		public function getName ():String
		{
			return _name;
		}
		
		public function setName( name:String ):void
		{
			_name = name;
		}

	}
}