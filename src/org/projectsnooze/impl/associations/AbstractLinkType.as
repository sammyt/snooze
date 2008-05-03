package org.projectsnooze.impl.associations
{
	import org.projectsnooze.associations.LinkType;

	public class AbstractLinkType implements LinkType
	{
		protected var _name : String;
		protected var _foreignKeyContainer : Boolean;
		
		public function AbstractLinkType( name : String , foreignKeyContainer : Boolean )
		{
			_name = name;
			_foreignKeyContainer = foreignKeyContainer;
		}

		public function getName():String
		{
			return _name;
		}
		
		public function setName(name:String):void
		{
			_name = name;
		}
		
		public function getForeignKeyContainer () : Boolean
		{
			return _foreignKeyContainer;
		}
		
		public function setForeignKeyContainer ( foreignKeyContainer : Boolean ) : void
		{
			_foreignKeyContainer = foreignKeyContainer;
		}
	}
}