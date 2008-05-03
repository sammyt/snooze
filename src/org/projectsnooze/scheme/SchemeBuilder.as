package org.projectsnooze.scheme
{
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	
	public interface SchemeBuilder
	{
		function setTypeFactory ( typeFactory : TypeFactory ) : void;
		
		function getTypeFactory () : TypeFactory;
		
		function setTypeUtils ( typeUtils : TypeUtils ) : void;
		
		function getTypeUtils () : TypeUtils;
		
		function setLinkTypeFactory ( linkTypeFactory : LinkTypeFactory ) : void;
		
		function getLinkTypeFactory () : LinkTypeFactory; 
		
		function setEntityDataMapProvider ( entityDataMapProvider : EntityDataMapProvider ) : void;
		
		function getEntityDataMapProvider ( ) : EntityDataMapProvider;
		
		function addEntityClass ( clazz : Class ) : void;
		
		function generateEntityDataMaps () : void;
	}
}