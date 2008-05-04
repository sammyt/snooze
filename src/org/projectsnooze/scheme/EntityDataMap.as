package org.projectsnooze.scheme
{
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.patterns.Iterator;
	
	public interface EntityDataMap
	{
		function addProperty ( mapping : NameTypeMapping ) : void;
		
		function addRelationship ( relationship : Relationship ) : void;
		
		function getRelationship ( dataMap : EntityDataMap ) : Relationship;
		
		function setPrimaryKey ( mapping : NameTypeMapping ) : void;
		
		function getPrimaryKey () : NameTypeMapping;
		
		function getPropertyIterator () : Iterator;
		
		function getRelationshipIterator () : Iterator;
		
		function getTableName () : String;
		
		function setTableName ( name : String ) : void;
		
	}
}