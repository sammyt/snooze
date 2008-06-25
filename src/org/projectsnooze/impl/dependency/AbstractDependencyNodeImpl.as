package org.projectsnooze.impl.dependency
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.execute.StatementQueue;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SubjectImpl;
	import org.projectsnooze.patterns.Iterator;

	public class AbstractDependencyNodeImpl extends SubjectImpl 
									implements DependencyNode
	{
		private static var logger : ILogger = 
			Log.getLogger( "AbstractDependencyNode" );
		
		protected var _statement : Statement;
		protected var _dependencies : Array;
		protected var _hasStarted : Boolean;
		protected var _isComplete : Boolean;
		protected var _statementQueue : StatementQueue;
		protected var _dependencyTree : DependencyTree; 
		
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
		public function getWrappedObject () : Object
		{
			logger.error( "override this method" );
			return null;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function update( obj : Object = null ) : void
		{
			execute( obj );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function addDependentNode ( 
			dependencyNode : DependencyNode ) : void
		{
			registerObserver( dependencyNode );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function addDependency ( dependencyNode : DependencyNode ) : void
		{
			_dependencies.push( dependencyNode );
		}
		
		/**
		 * 	@inheritDoc
		 */		
		public function execute( data : * = null ):void
		{
			if ( dependenciesAreMet() && ! _hasStarted )
			{
				begin ();
			}
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function begin () : void
		{
			_hasStarted = true;
		}
		
		public function result( data : Object ):void
		{
			_isComplete = true;
			
			// notify observers
			notifyObservers();
			
			getDependencyTree().nodeHasCompleted( this );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function fault( info : Object ):void
		{	
			getDependencyTree().nodeHasCompleted( this );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function isComplete () : Boolean
		{
			return _isComplete;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function isDependent() : Boolean
		{
			return ( _dependencies.length > 0 );
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function dependenciesAreMet() : Boolean
		{
			var depsMet : Boolean = true;
			for ( var i : Iterator = new ArrayIterator( _dependencies ) ; 
				i.hasNext() ; )
			{
				var depNode : DependencyNode = i.next() as DependencyNode;
				if ( ! depNode.isComplete() ) depsMet = false;
			}
			return depsMet;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setDependencyTree ( 
			dependencyTree : DependencyTree ) : void
		{
			_dependencyTree = dependencyTree;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getDependencyTree () : DependencyTree
		{
			return _dependencyTree;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setStatement ( statement : Statement ) : void
		{
			_statement = statement;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatement () : Statement
		{
			return _statement;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function setStatementQueue ( statementQueue : StatementQueue ) : void
		{
			_statementQueue = statementQueue;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatementQueue () : StatementQueue
		{
			return _statementQueue;
		}
	}
}