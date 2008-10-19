
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
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.scheme.EntityInteraction;
	import org.projectsnooze.impl.scheme.EntityInteractionImpl;

	public class ManyToManyInsertDepNode extends AbstractDependencyNodeImpl 
		implements DependencyNode
	{
		/**
		 * @private
		 */ 
		protected var _relationship:Relationship;
		
		/**
		 * @private
		 */
		protected var _firstEntity:Object;
		
		/**
		 * @private
		 */
		protected var _secondEntity:Object;
		
		/**
		 * @private
		 */
		protected var _entityDataMapProvider:EntityDataMapProvider; 
		
		/**
		*	@private
		*/
		protected var _entityInteraction:EntityInteraction;	
		
		/**
		 * Creates instance of <code>ManyToManyInsertDepNode</code>
		 */ 	
		public function ManyToManyInsertDepNode()
		{
			super();
		}

		protected function addParams ():void
		{
			var map1:EntityDataMap = _entityDataMapProvider.getEntityDataMap( _firstEntity );
			var map2:EntityDataMap = _entityDataMapProvider.getEntityDataMap( _secondEntity );
			
			var data1:Object = getEntityInteration().getValue( 
			 	map1.getPrimaryKey().getGetter() ,  _firstEntity );
			
			var data2:Object = getEntityInteration().getValue( 
			 	map2.getPrimaryKey().getGetter() ,  _secondEntity );
			
			_statement.addValue( 
				map1.getForeignKeyName() , data1 );
			
			_statement.addValue( 
				map2.getForeignKeyName() , data2 );
		}
		
		/**
		 * 	@inheritDoc
		 */ 
		override public function begin ():void
		{
			super.begin();
			addParams();
			
			var wrapper:StatementWrapper = new StatementWrapperImpl( getStatement() , this );
			getStatementQueue().add( wrapper );
		}
		
		public function setFirstEntity( entity:Object ):void
		{
			_firstEntity = entity;
		}

		public function setSecondEntity( entity:Object ):void
		{
			_secondEntity = entity;
		}
		
		public function setEntityDataMapProvider( entityDataMapProvider:EntityDataMapProvider ):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function setRelationship( relationship:Relationship ):void
		{
			_relationship = relationship; 
		}
		
		/**
		 * 	@inheritDoc
		 */
		override public function result( data:Object ):void
		{	
			super.result( data );
		}
		
		/**
		 * 	@inheritDoc
		 */ 
		override public function getUniqueObject ():Object
		{
			return _relationship.getJoinTableName();
		}
		
		public function getEntityInteration():EntityInteraction
		{
			if( !_entityInteraction )
			{
				return new EntityInteractionImpl();
			}
			return _entityInteraction;
		}
	}
}