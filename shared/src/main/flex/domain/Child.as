package domain
{
	
	[Entity]
	public class Child
	{
		private var _id:int;
		private var _mother:Mother;
		private var _height:Number
		
		public function Child()
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
		
		[ManyToOne(ref="domain::Mother")]
		public function getMother ():Mother
		{
			return _mother;
		}
		
		public function setMother ( mother:Mother ):void
		{
			_mother = mother;
		}
		
		public function getHeight ():Number
		{
			return _height;
		}
		
		public function setHeight ( height:Number ):void
		{
			_height = height;
		}
	}
}