package org.projectsnooze.impl.dependency
{
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SubjectImpl;
	import org.projectsnooze.patterns.Iterator;

	public class AbstractDependencyNodeImpl extends SubjectImpl implements DependencyNode
	{
		protected var _statement:Statement;
		protected var _dependencies:Array;
		protected var _hasStarted:Boolean;
		protected var _isComplete:Boolean;
		protected var _statementQueue:StatementQueue;
		protected var _dependencyTree:DependencyTree; 
		
		public function AbstractDependencyNodeImpl()
		{
			super();
			_hasStarted = false;
			_isComplete = false;
			_dependencies = new Array();
		}
		
		/**
		 * 	@inheritDoc
		 */ 
		public function getUniqueObject ():Object
		{
			throw new Error( 
				"Override AbstractDependencyNodeImpl.getUniqueObject()" );
				
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDependencyCount():int
		{
			return _dependencies.length;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function update( obj:Object = null ):void
		{
			if ( dependenciesAreMet() && ! _hasStarted )
			{
				begin();
			}
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function addChildNode ( dependencyNode:DependencyNode ):void
		{
			registerObserver( dependencyNode );
			dependencyNode.addParentNode( this );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function addParentNode ( dependencyNode:DependencyNode ):void
		{
			_dependencies.push( dependencyNode );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function begin ():void
		{
			_hasStarted = true;
		}
		
		public function result( data:Object ):void
		{
			_isComplete = true;
			
			notifyObservers();
			
			getDependencyTree().onNodeComplete( this );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function fault( info:Object ):void
		{	
			//getDependencyTree().onNodeComplete( this );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function isComplete ():Boolean
		{
			return _isComplete;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function isDependent():Boolean
		{
			return ( _dependencies.length > 0 );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function dependenciesAreMet():Boolean
		{
			for ( var i:Iterator = new ArrayIterator( _dependencies ) ; i.hasNext() ; )
			{
				var depNode:DependencyNode = i.next() as DependencyNode;
				if ( ! depNode.isComplete() ) 
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setDependencyTree ( dependencyTree:DependencyTree ):void
		{
			_dependencyTree = dependencyTree;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getDependencyTree ():DependencyTree
		{
			return _dependencyTree;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setStatement ( statement:Statement ):void
		{
			_statement = statement;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatement ():Statement
		{
			return _statement;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatementQueue ():StatementQueue
		{
			if ( !_statementQueue )
			{
				_statementQueue = getDependencyTree().getStatementQueue();
			}
			return _statementQueue;
		}
	}
}