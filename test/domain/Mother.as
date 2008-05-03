package domain
{
	[Entity]
	public class Mother
	{
		private var _id : int;
		private var _name : String;
		private var _concerns : Array;
		
		public function Mother()
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

		public function getName () : String
		{
			return _name;
		}
				
		public function setName ( name : String ) : void
		{
			_name = name;
		}
		
		[OneToMany(ref="domain::Concern")]
		public function getConcerns () : Array
		{
			return _concerns;
		}
		
		public function setConcerns ( concerns : Array ) : void
		{
			_concerns = concerns;
		}
		
		[Transient]
		public function getSillyValue () : Number
		{
			return Math.random() * new Date().getMilliseconds();
		}

	}
}