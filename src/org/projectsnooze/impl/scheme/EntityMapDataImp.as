package org.projectsnooze.impl.scheme
{
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;

	public class EntityMapDataImp implements EntityDataMap
	{
		private var _properties : Array;
		private var _relationships : Array;
		private var _tableName : String;
		private var _pkMapping : NameTypeMapping;
		
		public function EntityMapDataImp()
		{
			_properties = new Array();
			_relationships = new Array();
		}
		
		public function setPrimaryKey ( mapping : NameTypeMapping ) : void
		{
			_pkMapping = mapping;
		}
		
		public function getPrimaryKey () : NameTypeMapping
		{
			return _pkMapping;
		}

		public function addProperty( mapping : NameTypeMapping ):void
		{
			_properties.push( mapping );
		}
		
		public function getPropertyIterator () : Iterator
		{
			return new ArrayIterator ( _properties );
		}
		
		public function getRelationshipIterator () : Iterator
		{
			return new ArrayIterator ( _relationships );
		}
		
		public function getTableName () : String
		{
			return _tableName;
		}
		
		public function setTableName ( name : String ) : void
		{
			_tableName = name;
		}
		
		public function addRelationship ( relationship : Relationship ) : void
		{
			_relationships.push( relationship );
		}
		
		public function getRelationship ( dataMap : EntityDataMap ) : Relationship
		{
			for ( var iterator : Iterator = getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getEntityDataMap() == dataMap ) return relationship;
			}
			return null;
		}
		
	}
}


