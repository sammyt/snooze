
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
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.impl.dependency.RetrieveDepNode;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class DependencyTreeCreatorImpl implements DependencyTreeCreator
	{
		private static var _logger:ILogger = Log.getLogger( "DependencyTreeCreatorImpl" );
		
		/**
		 * @private
		 */ 
		protected var _entityDataMapProvider:EntityDataMapProvider;
		
		/**
		 * @private
		 */
		protected var _typeUtils:TypeUtils;
		
		/**
		 * @private
		 */
		protected var _statementCreator:StatementCreator;
		
		/**
		 * @private
		 */
		protected var _ddlGenerator:DDLGenerator;
		
		/**
		 * @private
		 */
		protected var _queueManager:QueueManager; 
		
		/**
		 * Creates instance of <code>DependencyTreeCreatorImpl</code>
		 */ 
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
		* 	which are then added to a dependency tree in the order they need
		* 	to be executed.
		*/ 
		protected function createInsertTree ( entity:Object , depTree:DependencyTree , 
			lastDepNode:DependencyNode = null , isPrevEntityFKContiner:Boolean = true ):void
		{
			// get the entity data map for the entity provided
			var dataMap:EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			var depNode:EntityInsertDepNode;
			
			// has this entity already been wrapped in a node
			if ( depTree.contains( entity ) )
			{
				// if a DependencyNode has already been created for this
				// entity then retrieve it from the tree 
				depNode = depTree.getNode( entity ) as EntityInsertDepNode;
			}
			
			// if this is the first the depTree has heard of
			// this entity, then a new node is needed
			else
			{
				depNode = new EntityInsertDepNode();
				depNode.setEnity( entity );
				depNode.setEntityDataMap( dataMap );
				depNode.setStatement( getStatementCreator().getInsertStatement( dataMap ) );
				depTree.add( depNode );
			}
			
			// if the last entity was the foreign key container
			// then it is dependent on this node
			if ( isPrevEntityFKContiner && lastDepNode )
			{
				depNode.addChildNode( lastDepNode );
			}
			// if the last entity was not the foreign key container
			// then this entity node depends on the previous one
			else if ( lastDepNode && ! isPrevEntityFKContiner )
			{
				lastDepNode.addChildNode( depNode );
			}
			
			// loop though all the relationships of the entity
			for ( var i:Iterator = dataMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship:Relationship = i.next() as Relationship;
				
				// if this entity is the entity container for this relationship
				if ( relationship.getIsEntityContainer() && 
					!depTree.contains( relationship.getJoinTableName() ) )
				{
					// get a reference to the getter for the contained object
					// or objects, if it is a collection
					var getter:Function = entity[ "get" + relationship.getPropertyName() ] as Function;
					
					// apply the getter, this returning the date
					var data:Object = getter.apply( entity );
					
					// is the data a collection, ie an Array or ArrayCollection
					if ( data && getTypeUtils().isCollection( data ) )
					{
						// if the entity contains a collection of other entities
						// each of them neecs to be recursed through
						for ( var j:Iterator = new SmartIterator( data ) ; j.hasNext() ; )
						{
							var obj:Object = j.next();
							var node:DependencyNode;
							
							// add any relationship dep nodes here... which will
							// be dependent on both the entites j.next and entity
							if ( relationship.getType().getName() == MetaData.MANY_TO_MANY )
							{
								
								node = getManyToManyInsertNode( relationship , entity , obj );
								
								depNode.addChildNode( node );
								
								depTree.add( node );
							}		
							
							createInsertTree( obj , depTree , depNode , 
								relationship.getType().getForeignKeyContainer() );
								
							if( node )
							{
								depTree.getNode( obj ).addChildNode( node );
							}
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
			
		protected function getManyToManyInsertNode( relationship:Relationship , 
			entity1:Object , entity2:Object ):DependencyNode
		{
			var node:ManyToManyInsertDepNode = new ManyToManyInsertDepNode();
			
			var dataMap1:EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity1 );
			var dataMap2:EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity2 );
			
			var statement:Statement = 
				getStatementCreator().getRelationshipInsert( relationship , dataMap1 , dataMap2 );

			node.setStatement ( statement );
			node.setFirstEntity( entity1 );
			node.setSecondEntity( entity2 );
			node.setEntityDataMapProvider( getEntitDataMapProvider() );
			node.setRelationship( relationship );
			
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRetrieveDependencyTree( clazz:Class , id:Object ):DependencyTree
		{ 
			_logger.info( "getRetrieveDependencyTree " + clazz + " " + id );
			
			var depTree:DependencyTree = new DependencyTreeImpl();
			depTree.setStatementQueue( getQueueManager().getStatementQueue() );
			
			var entity:Object = new clazz();
			var dataMap:EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			var setter:Function = entity[ "set" + dataMap.getPrimaryKey().getName() ] as Function;
			
			setter.apply( entity , [ id ] );
			
			createRetrieveTree( depTree , entity , id );
			
			return depTree;
		}
		
		protected function createRetrieveTree( depTree:DependencyTree , entity:Object , id:Object ):void
		{
			var dataMap:EntityDataMap = getEntitDataMapProvider().getEntityDataMap( entity );
			
			_logger.info( "createRetrieveTree " + dataMap + " " + entity );
			
			var node:RetrieveDepNode = new RetrieveDepNode();
			node.setStatement( getStatementCreator().getSelectStatement( dataMap ) );
			node.setEntityDataMapProvider( getEntitDataMapProvider() );
			node.setEntity( entity );
			node.setId( id );
			
			depTree.add( node );
			
			// loop though all the relationships of the entity
			for ( var i:Iterator = dataMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship:Relationship = i.next() as Relationship;
				
				// if this entity is the entity container for this relationship
				if ( relationship.getIsEntityContainer() && 
					!depTree.contains( relationship.getJoinTableName() ) )
				{
					
				}
			}
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setEntityDataMapProvider ( entityDataMap:EntityDataMapProvider ):void
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
		public function setStatementCreator ( statementCreator:StatementCreator ):void
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