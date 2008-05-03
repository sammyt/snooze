package org.projectsnooze.impl.connections
{
	import flash.data.SQLConnection;
	
	import org.projectsnooze.connections.ConnectionPool;

	public class ConnectionPoolImpl implements ConnectionPool
	{
		private var _maxConnections : uint = 0;
		private var _minConnections : uint = 1;
		private var _connections : Array;
		
		public function ConnectionPoolImpl()
		{
			_connections = new Array();
		}

		public function getConnection():SQLConnection
		{
			for ( var i : int = 0 ; i < _connections.length ; i ++ )
			{
				var conn : SQLConnection = _connections[i] as SQLConnection;
				if ( !conn.connected ) return conn
			}
			
			if ( ! isMaxConnectionsReached( _connections.length ) ) 
			{
				var newConn : SQLConnection = new SQLConnection()
				_connections.push( newConn );
				return newConn;
			}
				
			return null;
		}
		
		public function setMaxConnections(maxConnections:uint):void
		{
			_maxConnections = maxConnections;
		}
		
		public function getMaxConnections():uint
		{
			return _maxConnections;
		}
		
		public function setMinConnections(minConnections:uint):void
		{
			_minConnections = minConnections;
		}
		
		public function getMinConnections():uint
		{
			return _minConnections;
		}
		
		private function isMaxConnectionsReached ( connections : int ) : Boolean
		{
			if ( getMaxConnections() == 0 ) return false;
			
			if ( connections >= connections )
			{
				return true;
			}
			return false;
		}
		
	}
}