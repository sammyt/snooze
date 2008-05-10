
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
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.impl.execute.StatementExecutorImpl;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		private static var logger : ILogger = Log.getLogger( "DependencyTreeCreatorImpl" ) ;
		
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _typeUtils : TypeUtils;
		private var _statementCreator : StatementCreator;
		private var _connectionPool : ConnectionPool;
		
		public function DependencyTreeCreatorImpl()
		{
		}
		
		
		public function getSaveDependencyTree ( entity : Object ) : Array
		{
			var saveTree : Array = new Array();
			createDataMap( entity , saveTree );
			return saveTree;
		}
		
		private function createDataMap ( entity : Object , tree : Array , lastDepNode : DependencyNode = null , isPrevEntityFKContiner : Boolean = true ) : void
		{
			var dataMap : EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			var depNode : DependencyNode = new DependancyNodeImpl();
			depNode.setEnity( entity );
			depNode.setEntityDataMap( dataMap );
			depNode.setStatementCreator( getStatementCreator() );
			depNode.setActionType( "insert" );
			
			var executor : StatementExecutor = new StatementExecutorImpl();
			executor.setConnection( getConnectionPool().getConnection() );
			depNode.setStatementExecutor( executor );
			
			if ( isPrevEntityFKContiner && lastDepNode )
			{
				//logger.debug( "depNode = {0} , lastDepNode = {1}" , depNode.getEntity() , lastDepNode.getEntity() );
				
				depNode.addDependentNode( lastDepNode );
				lastDepNode.addDependency( depNode )
			}
			else if ( lastDepNode )
			{
				//logger.debug( "depNode = {0} , lastDepNode = {1}" , depNode.getEntity() , lastDepNode.getEntity() );
				
				lastDepNode.addDependentNode( depNode );
				depNode.addDependency( lastDepNode )
			}
			
			tree.push( depNode );
			
			for ( var iterator : Iterator = dataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship  : Relationship = iterator.next() as Relationship;
				
				if ( relationship.getIsEntityContainer() )
				{
					var getter : Function = entity[ "get" + relationship.getPropertyName() ] as Function;
					var data : * = getter.apply( entity );
					
					if ( getTypeUtils().isCollection( data ) )
					{
						for ( var i : Iterator = new SmartIterator( data ) ; i.hasNext() ; )
						{
							createDataMap( i.next() , tree , depNode , relationship.getType().getForeignKeyContainer() );
						}
					}
					else
					{
						createDataMap( data , tree , depNode , relationship.getType().getForeignKeyContainer() );
					}
				}
			}
			
		}
		
		public function setEntityDataMapProvider ( entityDataMap : EntityDataMapProvider ) : void
		{
			_entityDataMapProvider = entityDataMap;
		}
		
		public function getEntitDataMapProvider ( ) : EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		public function setTypeUtils ( typeUtils : TypeUtils ) : void
		{
			_typeUtils = typeUtils;
		}
		
		public function getTypeUtils () : TypeUtils
		{
			return _typeUtils;
		}
	
		public function setStatementCreator ( statementCreator : StatementCreator ) : void
		{
			_statementCreator = statementCreator
		}
		
		public function getStatementCreator () : StatementCreator
		{
			return _statementCreator;
		}
		
		public function setConnectionPool ( connectionPool : ConnectionPool ) : void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool () : ConnectionPool
		{
			return _connectionPool;
		}
	}
}