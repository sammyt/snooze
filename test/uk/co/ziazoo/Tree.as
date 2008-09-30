package uk.co.ziazoo 
{
	[Entity]
	public class Tree
	{
		[id]
		public var id:int;
		
		public var name:String;
		
		[ManyToMany(ref="uk.co.ziazoo::Branch")]
		private var _branches:Array;
		
		private var _roots:Array;
		
		private var _leaves:Object;
		
		public function Tree()
		{
		}
		
		public function get branches():Array
		{ 
			return _branches; 
		}

		public function set branches(value:Array):void
		{
			_branches = value;
		}
		
		[ManyToMany(ref="uk.co.ziazoo::Branch")]
		public function get roots():Array
		{ 
			return _roots; 
		}

		public function set roots(value:Array):void
		{
			_roots = value;
		}
		
		[Transient]
		public function getLeaves():Object
		{ 
			return _leaves; 
		}

		public function setLeaves(value:Object):void
		{
			_leaves = value;
		}
		
	}
}
