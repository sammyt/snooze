
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
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	
	/**
	 * 	@inheritDoc
	 */ 
	public class DependencyTreeImpl implements DependencyTree
	{
		/**
		 * @private
		 */
		protected var _nodes:Array;
		
		/**
		 * @private
		 */ 
		protected var _statementQueue:StatementQueue;
		
		/**
		 * 	@protected
		 * 	
		 * 	contains references to all the many to many 
		 * 	relationships that have been followed to
		 * 	create the dependency tree
		 */ 
		protected var _followedRelationships:Array;
		
		public function DependencyTreeImpl()
		{
			_nodes = new Array();
			_followedRelationships = new Array();
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getNodeCount ():int
		{
			return _nodes.length;
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function add( dependencyNode:DependencyNode ):void
		{
			_nodes.push( dependencyNode );
			dependencyNode.setDependencyTree( this );
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function begin():void
		{
			for( var i:Iterator = new SmartIterator( _nodes ) ; i.hasNext() ; )
			{
				var depNode:DependencyNode = i.next() as DependencyNode;
				depNode.setDependencyTree( this );
				
				// the node has no unfilled dependencies, so can begin
				if ( ! depNode.isDependent() ) depNode.begin();
			}
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function contains ( obj:Object ):Boolean
		{
			return getNode( obj ) ? true:false;
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getNode ( obj:Object ):DependencyNode
		{
			for ( var i:Iterator = new ArrayIterator ( _nodes ) ; i.hasNext() ; )
			{
				var node:DependencyNode = i.next() as DependencyNode;
				if ( node.getUniqueObject() == obj ) return node;
			}
			return null;
		}
		/**
	 	* 	@inheritDoc
	 	*/
		public function setStatementQueue ( statementQueue:StatementQueue ):void
		{
			_statementQueue = statementQueue; 
		}
		
		/**
	 	* 	@inheritDoc
	 	*/
		public function getStatementQueue ():StatementQueue
		{
			return _statementQueue;
		}
		/**
	 	* 	@inheritDoc
	 	*/
		public function setManyToManyPathFollowed ( 
			relationship:Relationship ):void
		{
			_followedRelationships.push( relationship );
		}
		
		/**
	 	* 	@inheritDoc
	 	*/ 
		public function getManyToManyPathFollowed( relationship:Relationship ):Boolean
		{	
			for ( var i:Iterator = new ArrayIterator( _followedRelationships ) ; i.hasNext() ; )
			{
				var r:Relationship = i.next() as Relationship;
				
				if ( r.getJoinTableName() == relationship.getJoinTableName() && r.getJoinTableName() != null )
				{
					return true;
				}	
			}
			return false;
		}
	}
}