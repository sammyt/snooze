
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
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		protected static var logger : ILogger = Log.getLogger( "DependencyTreeCreatorImpl" ) ;
		
		protected var _entityDataMapProvider : EntityDataMapProvider;
		protected var _typeUtils : TypeUtils;
		protected var _statementCreator : StatementCreator;
		protected var _ddlGenerator : DDLGenerator;
		protected var _queueManager : QueueManager; 
		
		public function DependencyTreeCreatorImpl()
		{
		}
		
		public function setQueueManager ( queueManager : QueueManager ) : void
		{
			_queueManager = queueManager;
		}
		
		public function getQueueManager () : QueueManager
		{
			return _queueManager;
		}
		
		public function getSaveDependencyTree ( entity : Object ) : DependencyTree
		{
			var depTree : DependencyTree = new DependencyTreeImpl();
			depTree.setStatementQueue( getQueueManager().getQueue() );
			createInsertTree( entity , depTree );
			
			return depTree;
		}
		
		private function createInsertTree ( entity : Object , depTree : DependencyTree , lastDepNode : DependencyNode = null , isPrevEntityFKContiner : Boolean = true ) : void
		{
			var dataMap : EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			var depNode : DependencyNode;
			
			// has this entity already been wrapped in a node
			if ( depTree.doesTreeContain( entity ) )
			{
				depNode = depTree.getNodeByEntity( entity );
			}
			
			// if this is the first the depTree has heard of
			// this entity, then a new node is needed
			else
			{
				depNode = new DependencyNodeImpl();
				depNode.setEnity( entity );
				depNode.setEntityDataMap( dataMap );
				depNode.setStatement( getStatementCreator().getStatementByType( "insert" , dataMap ) );
				depNode.setStatementQueue( depTree.getStatementQueue() );
				depNode.setDependencyTree( depTree );
				
				depTree.addDependencyNode( depNode );
			}
			
			
			// if the last entity was the foreign key container
			// then it is dependent on this node
			if ( isPrevEntityFKContiner && lastDepNode )
			{
				depNode.addDependentNode( lastDepNode );
				lastDepNode.addDependency( depNode )
			}
			// if the last entity was not the foreign key container
			// then this entity node depends on the previous one
			else if ( lastDepNode && ! isPrevEntityFKContiner )
			{
				lastDepNode.addDependentNode( depNode );
				depNode.addDependency( lastDepNode )
			}
			
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
							createInsertTree( i.next() , depTree , depNode , relationship.getType().getForeignKeyContainer() );
						}
					}
					else
					{
						createInsertTree( data , depTree , depNode , relationship.getType().getForeignKeyContainer() );
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
	}
}