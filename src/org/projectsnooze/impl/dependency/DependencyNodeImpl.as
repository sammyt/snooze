
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
	import org.projectsnooze.execute.StatementExecutor;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.impl.patterns.SubjectImpl;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.NameTypeMapping;

	public class DependancyNodeImpl extends SubjectImpl implements DependencyNode
	{
		private static var logger : ILogger = Log.getLogger( "DependancyNodeImpl" );
		
		private var _statementExecutor : StatementExecutor;
		private var _statementCreator : StatementCreator;
		private var _statement : Statement;
		private var _dependencies : Array;
		private var _entityDataMap : EntityDataMap;
		private var _entity : Object;
		private var _isComplete : Boolean;
		private var _actionType : String;
		
		public function DependencyNodeImpl()
		{
			_isComplete = false;
			_dependencies = new Array();
		}
		
		public function update( obj : Object = null ) : void
		{
			execute();
		}
		
		// ---
		// wrappers around observer functions for clarity
		// --
		public function addDependentNode ( dependencyNode : DependencyNode ) : void
		{
			registerObserver( dependencyNode );
		}
		
		public function addDependency ( dependencyNode : DependencyNode ) : void
		{
			_dependencies.push( dependencyNode );
		}
		
		public function addParams () : void
		{
			addNaturalParams();
			addPrimaryKeyParams();
			addForeignKeyParams();
		}
		
		private function addNaturalParams () : void
		{
			for ( var iterator : Iterator = getEntityDataMap().getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				
				var getter : Function = _entity[ "get" + mapping.getName() ] as Function;
				
				var data : * = getter.apply( _entity );
				
				var mark : String = mapping.getType().getSQLType() == "TEXT" ? '"' : "";
				
				_statement.addValue( ":" + mapping.getLowerCaseName() , mark + data + mark );
			}
		}
		
		private function addPrimaryKeyParams () : void
		{
			var mapping : NameTypeMapping = getEntityDataMap().getPrimaryKey();
			
			var getter : Function = _entity[ "get" + mapping.getName() ] as Function;
			var data : * = getter.apply( _entity );
			_statement.addValue( ":" + mapping.getLowerCaseName() + "_value" , data );
		}
		
		private function addForeignKeyParams () : void
		{
			for ( var iterator : Iterator = getEntityDataMap().getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var depNode : DependencyNode = getDependencyNodeByDataMap( relationship.getEntityDataMap() );
					
					if ( depNode.isComplete() )
					{
						var getter : Function = depNode.getEntity()[ "get" + depNode.getEntityDataMap().getPrimaryKey().getName() ] as Function;
						
						var data : * = getter.apply( depNode.getEntity() );
						
						var tableName : String =  relationship.getEntityDataMap().getTableName().toLowerCase();
						var idName : String = relationship.getEntityDataMap().getPrimaryKey().getLowerCaseName();
						
						_statement.addValue( ":" + tableName + "_" + idName , data );
					}
				}
			}
		}
		
		
		private function getDependencyNodeByDataMap ( entityDataMap : EntityDataMap ) : DependencyNode
		{
			for ( var iterator : Iterator = new ArrayIterator( _dependencies ) ; iterator.hasNext() ; )
			{
				var depNode : DependencyNode = iterator.next() as DependencyNode;
				if ( depNode.getEntityDataMap() == entityDataMap ) return depNode;
			}
			return null;
		}
					
		public function execute( data : * = null ):void
		{
			_statement = getStatementCreator().getStatementByType( getActionType() , getEntityDataMap() );
			
			if ( dependenciesAreMet() )
			{
				addParams();
				getStatementExecutor().setStatement( _statement );
				getStatementExecutor().setResponder( this );
				getStatementExecutor().execute();
			}
		}
		
		public function result( data : Object ):void
		{
			_isComplete = true;
			// set the new id
			getEntity().setId ( Math.round( Math.random() * 10 ) );
			
			// notify observers
			notifyObservers();
		}
	
		public function fault( info : Object ):void
		{
			// throw some kind of snooze error
		}
		
		public function isComplete () : Boolean
		{
			return _isComplete;
		}
		
		public function isDependent() : Boolean
		{
			return ( _dependencies.length > 0 );
		}
		
		public function dependenciesAreMet() : Boolean
		{
			var depsMet : Boolean = true;
			for ( var iterator : Iterator = new ArrayIterator( _dependencies ) ; iterator.hasNext() ; )
			{
				var depNode : DependencyNode = iterator.next() as DependencyNode;
				if ( ! depNode.isComplete() ) depsMet = false;
			}
			return depsMet;
		}
		
		
		
		// -----
		// getters and setters
		// -----
		public function setEnity ( entity : Object ) : void
		{
			_entity = entity;
		}
		
		public function getEntity () : Object
		{
			return _entity;
		}
		
		public function setEntityDataMap ( entityDataMap : EntityDataMap ) : void
		{
			_entityDataMap = entityDataMap;
		}
		
		public function getEntityDataMap () : EntityDataMap
		{
			return _entityDataMap;			
		}
		
		public function setStatementCreator ( statementCreator : StatementCreator ) : void
		{
			_statementCreator = statementCreator;
		}
		
		public function getStatementCreator () : StatementCreator
		{
			return _statementCreator;
		}
		
		public function setStatementExecutor ( statementExecutor : StatementExecutor ) : void
		{
			_statementExecutor = statementExecutor
		}
		
		public function getStatementExecutor () : StatementExecutor
		{
			return _statementExecutor;	
		}
		
		public function getActionType () : String
		{
			return _actionType;
		}
		
		public function setActionType ( actionType : String ) : void
		{
			_actionType = actionType;
		}
	}
}