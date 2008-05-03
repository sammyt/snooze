package org.projectsnooze.impl.associations
{
	import org.projectsnooze.associations.LinkType;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.scheme.EntityDataMap;

	public class RelationshipImpl implements Relationship
	{
		private var _type : LinkType;
		private var _dataMap : EntityDataMap;
		private var _name : String;
		
		public function RelationshipImpl()
		{
		}

		public function setType(type:LinkType):void
		{
			_type = type;
		}
		
		public function getType():LinkType
		{
			return _type;
		}
		
		public function setEntityDataMap(dataMap:EntityDataMap):void
		{
			_dataMap = dataMap;
		}
		
		public function getEntityDataMap():EntityDataMap
		{
			return _dataMap;
		}
		
		public function setPropertyName ( name : String ) : void
		{
			_name = name;
		}
		
		public function getPropertyName () : String
		{
			return _name;
		}
	}
}