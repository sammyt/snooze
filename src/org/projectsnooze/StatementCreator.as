package org.projectsnooze
{
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.scheme.EntityDataMap;
	
	public interface StatementCreator
	{
		function getSelectSql ( data : EntityDataMap ) : Statement;
		
		function getInsertSql ( data : EntityDataMap ) : Statement;
		
		function getUpdateSql ( data : EntityDataMap ) : Statement;
		
		function getDeleteSql ( data : EntityDataMap ) : Statement;
	}
}