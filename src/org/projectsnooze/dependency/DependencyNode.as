package org.projectsnooze.dependency
{
	import org.projectsnooze.patterns.Command;
	import org.projectsnooze.patterns.Observer;
	import org.projectsnooze.patterns.Subject;
	import org.projectsnooze.scheme.EntityDataMap;
	
	public interface DependencyNode extends Subject , Observer , Command
	{
		function isDependent () : Boolean;
		
		function dependenciesAreMet () : Boolean;
		
		function setEnity ( entity : Object ) : void;
		
		function getEntity () : Object;
		
		function setEntityDataMap ( entityDataMap : EntityDataMap ) : void;
		
		function getEntityDataMap () : EntityDataMap;
	}
}