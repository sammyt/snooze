
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
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.dependency.DependencyNode;

	public class RelationshipInsertDepNode 	extends AbstractDependencyNodeImpl 
											implements DependencyNode
	{
		private static var logger:ILogger = 
			Log.getLogger( "RelationshipInsertDepNode" );
		
		protected var _relationship:Relationship;
		
		public function RelationshipInsertDepNode()
		{
			super();
			logger.debug( "created" );
		}
		
		public function setRelationship ( relationship:Relationship ):void
		{
			_relationship = relationship;
		}
		
		protected function addParams ():void
		{
			/*
			var dm1:EntityDataMap;
			var dm2:EntityDataMap;
			
			var e1:Object;
			var e2:Object;
			
			var getter1:Function = e1[ 
				"get" + dm1.getPrimaryKey().getName() ] as Function;
			
			var getter2:Function = e2[ 
				"get" + dm2.getPrimaryKey().getName() ] as Function;
			
			_statement.addValue( ":" + 
				dm1.getForeignKeyName() , getter1.apply( e1 ) );
			
			_statement.addValue( ":" + 
				dm2.getForeignKeyName() , getter2.apply( e2 ) );
			*/
			logger.debug( "relDep sql {0}" , _statement.getSQL() );
		}
		
		/**
		 * 	@inheritDoc
		 */ 
		override public function begin ():void
		{
			super.begin();
			logger.debug( "begin" );
			addParams();
		}
		
		/**
		 * 	@inheritDoc
		 */
		override public function result( data:Object ):void
		{	
			super.result( data );
		}
	}
}