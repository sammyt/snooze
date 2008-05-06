package org.projectsnooze.impl.generator
{
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.generator.Statement;

	public class StatementImpl implements Statement
	{
		private static var logger : ILogger = Log.getLogger( "StatementImpl" );
		
		private var _skeleton : String;
		private var _params : Object;
		
		public function StatementImpl()
		{
			_params = {};
		}

		public function getSqlSkeleton():String
		{
			return _skeleton;
		}
		
		public function setSqlSkeleton(sqlSkelton:String):void
		{
			_skeleton = sqlSkelton;
		}
		
		public function get sqlSkeleton () : String
		{
			return _skeleton;
		}
		
		public function set sqlSkeleton ( sql : String ) : void
		{
			_skeleton = sql;
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
			return getSqlSkeleton();
			//return substitute( getSqlSkeleton() , getParamaters() );
		}
		
		private function substitute(str:String, ... rest):String
    	{
	        return str;
	    }
		
	}
}