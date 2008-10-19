
/* 
 * The MIT License
 * 
 * Copyright (c) 2008 Samuel Williams
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package org.projectsnooze.impl.connections
{
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	
	import org.projectsnooze.connections.ConnectionPool;
	

	public class ConnectionPoolImpl implements ConnectionPool
	{
		private var _file:File;
		private var _maxConnections:uint = 0;
		private var _minConnections:uint = 1;
		private var _connections:Array;
		
		public function ConnectionPoolImpl()
		{
			_connections = new Array();
		}

		public function getConnection():SQLConnection
		{
			for ( var i:int = 0 ; i < _connections.length ; i ++ )
			{
				var conn:SQLConnection = _connections[i] as SQLConnection;
				if ( !conn.connected ) return conn
			}
			
			if ( ! isMaxConnectionsReached( _connections.length ) ) 
			{
				var newConn:SQLConnection = new SQLConnection()
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
		
		private function isMaxConnectionsReached ( connections:int ):Boolean
		{
			if ( getMaxConnections() == 0 ) return false;
			
			if ( connections >= getMaxConnections() )
			{
				return true;
			}
			return false;
		}
		
		public function setFile ( file:File ):void
		{
			_file = file;
		}
		
		public function getFile ():File
		{
			return _file;
		}
		
	}
}