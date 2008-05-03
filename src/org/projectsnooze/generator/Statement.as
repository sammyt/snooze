package org.projectsnooze.generator
{
	public interface Statement
	{
		function getSqlSkeleton () : String;
		
		function setSqlSkeleton ( sqlSkelton : String ) : void;
		
		function getParamaters () : Object;
		
		function setParameters ( params : Object ) : void;
		
		function getSQL () : String;
	}
}