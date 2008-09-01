
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
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.constants.MetaData;
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
		protected var _entityDataMapProvider:EntityDataMapProvider;
		protected var _typeUtils:TypeUtils;
		protected var _statementCreator:StatementCreator;
		protected var _ddlGenerator:DDLGenerator;
		protected var _queueManager:QueueManager; 
		
		public function DependencyTreeCreatorImpl()
		{
		}
		
		/**
		 * 	@inheritDoc
		 */ 
		public function setQueueManager ( queueManager:QueueManager ):void
		{
			_queueManager = queueManager;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getQueueManager ():QueueManager
		{
			return _queueManager;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getSaveDependencyTree ( entity:Object ):DependencyTree
		{
			var depTree:DependencyTree = new DependencyTreeImpl();
			depTree.setStatementQueue( getQueueManager().getStatementQueue() );
			createInsertTree( entity , depTree );
			
			return depTree;
		}
		
		/**
		 *	@private
		 * 
		 *	this function recursively navigates through the relationships of
		 *	the entity it is provided creating <code>DependencyNode</code>s
		 * which are then added to a dependency tree in the order they need
		 * to be executed.
		 */ 
		protected function createInsertTree ( entity:Object , 
				depTree:DependencyTree , lastDepNode:DependencyNode = null , 
				isPrevEntityFKContiner:Boolean = true ):void
		{
			// get the entity data map for the entity provided
			var dataMap:EntityDataMap = 
				getEntitDataMapProvider().getEntityDataMap( entity );
			
			var depNode:EntityInsertDepNode;
			
			// has this entity already been wrapped in a node
			if ( depTree.doAnyNodesWrap( entity ) )
			{
				// if a DependencyNode has already been created for this
				// entity then retrieve it from the tree 
				depNode = depTree.getNodeByWrappedObject( 
					entity ) as EntityInsertDepNode;
			}
			
			// if this is the first the depTree has heard of
			// this entity, then a new node is needed
			else
			{
				depNode = new EntityInsertDepNode();
				depNode.setEnity( entity );
				depNode.setEntityDataMap( dataMap );
				depNode.setDependencyTree( depTree );
				depNode.setStatement( 
					getStatementCreator().getInsertStatement( dataMap ) );
				
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
			
			// loop though all the relationships of the entity
			for ( var i:Iterator = dataMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship :Relationship = i.next() as Relationship;
				
				// if this entity is the entity container for this relationship
				if ( relationship.getIsEntityContainer()
					&& ! depTree.getManyToManyPathFollowed( relationship ) )
				{
					// get a reference to the getter for the contained object
					// or objects, if it is a collection
					var getter:Function = entity[ "get" + 
						relationship.getPropertyName() ] as Function;
					
					// apply the getter, this returning the date
					var data:* = getter.apply( entity );
					
					// is the data a collection, ie an Array or ArrayCollection
					if ( data && getTypeUtils().isCollection( data ) )
					{
						// if the entity contains a collection of other entities
						// each of them neecs to be recursed through
						for ( var j:Iterator = new SmartIterator( data ) ; j.hasNext() ; )
						{
							var obj:Object = j.next();
								
							// add any relationship dep nodes here... which will
							// be dependent on both the entites j.next and entity
							if ( relationship.getType().getName() == MetaData.MANY_TO_MANY )
							{
								var relDepNode:RelationshipInsertDepNode
											= new RelationshipInsertDepNode();
								
								// provide the dep node with its basic requirements
								relDepNode.setDependencyTree( depTree );
								
								// need to set the statement
								relDepNode.setStatement ( getStatementCreator().getRelationshipInsert( 
									relationship , dataMap , getEntitDataMapProvider().getEntityDataMap( obj ) ) );
								
								// inform the dep tree of another dep node
								depTree.addDependencyNode( relDepNode );
								depTree.setManyToManyPathFollowed( relationship );
							}		
							
							createInsertTree( obj , depTree , depNode , 
								relationship.getType().getForeignKeyContainer() );
								
							//logger.error ( "is {0} null" , depTree.getNodeByWrappedObject( obj ) );
						}
					}
					else if ( data )
					{
						createInsertTree( data , depTree , depNode , 
							relationship.getType().getForeignKeyContainer() );
					}
				}
			}
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setEntityDataMapProvider ( 
			entityDataMap:EntityDataMapProvider ):void
		{
			_entityDataMapProvider = entityDataMap;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getEntitDataMapProvider ( ):EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setTypeUtils ( typeUtils:TypeUtils ):void
		{
			_typeUtils = typeUtils;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getTypeUtils ():TypeUtils
		{
			return _typeUtils;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setStatementCreator ( 
			statementCreator:StatementCreator ):void
		{
			_statementCreator = statementCreator
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatementCreator ():StatementCreator
		{
			return _statementCreator;
		}
	}
}