package org.projectsnooze
{
	import flash.data.SQLStatement;
	
	import org.projectsnooze.scheme.EntityDataMap;
	
	public interface StatementCreator
	{
		function getSelectSql ( data : EntityDataMap ) : SQLStatement;
		
		function getInsertSql ( data : EntityDataMap ) : SQLStatement;
		
		function getUpdateSql ( data : EntityDataMap ) : SQLStatement;
		
		function getDeleteSql ( data : EntityDataMap ) : SQLStatement;
	}
}