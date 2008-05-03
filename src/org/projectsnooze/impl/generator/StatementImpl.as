package org.projectsnooze.impl.generator
{
	import mx.utils.StringUtil;
	
	import org.projectsnooze.generator.Statement;

	public class StatementImpl implements Statement
	{
		private var _sql : String;
		private var _params : Object;
		
		public function StatementImpl()
		{
			_params = {};
		}

		public function getSqlSkeleton():String
		{
			return _sql;
		}
		
		public function setSqlSkeleton(sqlSkelton:String):void
		{
			_sql = sqlSkelton;
		}
		
		public function getParamaters():Object
		{
			return _params;
		}
		
		public function setParameters(params:Object):void
		{
			_params = params;
		}
		
		public function getSQL () : String
		{
			return _sql;
		}
		
	}
}