
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

package org.projectsnooze.impl.dependency
{	
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.EntityDataMap;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import flash.utils.*;
	
	public class RetrieveDepNode extends AbstractDependencyNodeImpl
	{
		private static var _logger:ILogger = Log.getLogger( "RetrieveDepNode" );
		
		protected var _entityDataMapProvider:EntityDataMapProvider;
		protected var _entity:Object;
		protected var _id:Object;
		
		/**
		*	Creates instance of <code>RetrieveDepNode</code>
		*/	
		public function RetrieveDepNode()
		{
			super();
		}
		
		protected function addParameters():void
		{
			var dataMap:EntityDataMap = getEntityDataMapProvider().getEntityDataMap( _entity );
			
			getStatement().addValue( dataMap.getPrimaryKey().getColumnName() , _id );
		}
		
		/**
		*	@inheritDoc
		*/	
		override public function begin():void
		{
			super.begin();
			addParameters();
			var wrapper:StatementWrapper = new StatementWrapperImpl( getStatement() , this );
			getStatementQueue().add( wrapper );
		}
		
		public function setEntity( entity:Object ):void
		{
			_entity = entity;
		}
		
		public function setId( id:Object ):void
		{
			_id = id;
		}
		
		/**
		*	@inheritDoc
		*/
		override public function result( result:Object ):void
		{	
			var list:Array = result.data as Array;
			
			if ( list.length > 0 )
			{
				for( var obj:String in list[0] )
				{
					_logger.debug( "obj:" + obj + " = " + list[0][obj] );
				}
			}
			else
			{
				throw new Error( "Entity of class " + 
				 	getQualifiedClassName( _entity ) + " and id "
				  	+ _id + " could not be found" );
			}
			super.result( result );
		}
		
		/**
		* 	@inheritDoc
		*/ 
		override public function getUniqueObject ():Object
		{
			return _entity;
		}
		
		public function getEntityDataMapProvider():EntityDataMapProvider
		{ 
			return _entityDataMapProvider; 
		}

		public function setEntityDataMapProvider( entityDataMapProvider:EntityDataMapProvider ):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
	}
}