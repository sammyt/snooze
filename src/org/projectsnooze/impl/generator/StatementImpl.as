
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
 
package org.projectsnooze.impl.generator
{
	
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.generator.Statement;

	public class StatementImpl implements Statement
	{
		private static var logger : ILogger = Log.getLogger( "StatementImpl" );
		
		private var _dict : Dictionary;
		private var _skeleton : String;
		
		public function StatementImpl()
		{
			_dict = new Dictionary;
		}

		public function getSqlSkeleton():String
		{
			return _skeleton;
		}
		
		public function setSqlSkeleton(sqlSkelton:String):void
		{
			_skeleton = sqlSkelton;
		}
		
		public function getParamaters():Object
		{
			var params : Object = new Object();
			for  (var key : Object in _dict )
	        {
	        	params[ key ] = _dict[ key ]
	        }
			return params;
		}
		
		public function getSQL () : String
		{
			return substitute( getSqlSkeleton() , _dict );
		}
		
		private function substitute( str : String , dict : Dictionary ):String
    	{
    		for (var key : Object in dict)
	        {
	        	var k : String = key as String;
	            str = str.replace( new RegExp ( k , "g" ) , dict[ key ] );
	        }
	        return str;
	    }
	    
		public function addValue ( key : String , value : * ) : void
		{
			_dict[ key ] = value;
		}
		
		public function getValuebyKey ( key : String ) : *
		{
			return _dict[ key ];
		}
		
		public function toString () : String
		{
			return _skeleton;
		}
		
	}
}