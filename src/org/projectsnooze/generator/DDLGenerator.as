package org.projectsnooze.generator
{
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public interface DDLGenerator
	{
		function setEntityDataMapProvider ( entityDataMapProvider : EntityDataMapProvider ) : void;
		
		function getEntityDataMapProvider () : EntityDataMapProvider;
		
		function getDDL () : Statement;
	}
}