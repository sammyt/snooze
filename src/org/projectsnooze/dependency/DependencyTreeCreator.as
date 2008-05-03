package org.projectsnooze.dependency
{
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public interface DependencyTreeCreator
	{
		function getSaveDependencyTree ( entity : Object ) : Array;
		
		function setEntityDataMapProvider ( entityDataMap : EntityDataMapProvider ) : void
		
		function getEntitDataMapProvider ( ) : EntityDataMapProvider
		
		function setTypeUtils ( typeUtils : TypeUtils ) : void
		
		function getTypeUtils () : TypeUtils
	}
}