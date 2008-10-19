
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
	import flash.data.SQLResult;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.NameTypeMapping;
	import org.projectsnooze.scheme.EntityInteraction;
	import org.projectsnooze.impl.scheme.EntityInteractionImpl;
	
	import uk.co.ziazoo.collections.ArrayIterator;
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.reflection.NameReference;

	public class EntityInsertDepNode extends AbstractDependencyNodeImpl
	{
		private static var logger:ILogger = Log.getLogger( "DependancyNodeImpl" );
		
		protected var _entityDataMap:EntityDataMap;
		protected var _entity:Object;
		protected var _entityInteraction:EntityInteraction;
		
		public function EntityInsertDepNode()
		{
			super();
		}
		
		public function addParams ():void
		{
			addNaturalParams();
			addPrimaryKeyParams();
			addForeignKeyParams();
		}
		
		protected function addNaturalParams ():void
		{
			for ( var i:Iterator = getEntityDataMap().getPropertyIterator() ; i.hasNext() ; )
			{
				var mapping:NameTypeMapping = i.next() as NameTypeMapping;
				
				var data:Object = getEntityInteraction().getValue( 
				 	mapping.getGetter() , _entity );
				
				var mark:String = mapping.getType().getSQLType() == "TEXT" ? '"':"";
				
				_statement.addValue( mapping.getLowerCaseName() , mark + data + mark );
			}
		}
		
		protected function addPrimaryKeyParams ():void
		{
			var mapping:NameTypeMapping = getEntityDataMap().getPrimaryKey();
			
			var data:Object = getEntityInteraction().getValue( 
			 	mapping.getGetter() , _entity );
			
			_statement.addValue( mapping.getLowerCaseName() + "_value" , data );
		}
		
		protected function addForeignKeyParams ():void
		{
			for ( var i:Iterator = getEntityDataMap().getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship:Relationship = i.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var depNode:EntityInsertDepNode = 
						getDependencyNodeByDataMap( relationship.getEntityDataMap() );
					
					if ( depNode.isComplete() )
					{
						var reflection:NameReference = 
							depNode.getEntityDataMap().getPrimaryKey().getGetter();
						
						var data:Object = getEntityInteraction().getValue( 
							reflection, depNode.getEntity() );
						
						var tableName:String = 
							relationship.getEntityDataMap().getTableName().toLowerCase();
							
						var idName:String = 
							relationship.getEntityDataMap().getPrimaryKey().getLowerCaseName();
						
						_statement.addValue( tableName + "_" + idName , data );
					}
				}
			}
		}
		
		protected function getDependencyNodeByDataMap ( 
			entityDataMap:EntityDataMap ):EntityInsertDepNode
		{	
			for ( var i:Iterator = new ArrayIterator( _dependencies ) ; i.hasNext() ; )
			{
				var depNode:EntityInsertDepNode = i.next() as EntityInsertDepNode;
				
				if ( depNode )
				{
					if ( depNode.getEntityDataMap() == entityDataMap )
					{ 
						return depNode;
					}
				}
			}
			return null;
		}
	
		override public function begin ():void
		{
			super.begin();
			addParams();
			
			var wrapper:StatementWrapper = new StatementWrapperImpl( getStatement() , this );
			getStatementQueue().add( wrapper );
		}
		
		override public function result( data:Object ):void
		{
			var e:SQLResult = data as SQLResult;
			
			getEntityInteraction().setValue( 
				getEntityDataMap().getPrimaryKey().getSetter(), 
				e.lastInsertRowID, getEntity() );
			
			super.result( data );
		}
	
		override public function getUniqueObject ():Object
		{
			return getEntity();
		}
	
		public function setEnity ( entity:Object ):void
		{
			_entity = entity;
		}
		
		public function getEntity ():Object
		{
			return _entity;
		}
		
		public function setEntityDataMap ( entityDataMap:EntityDataMap ):void
		{
			_entityDataMap = entityDataMap;
		}
		
		public function getEntityDataMap ():EntityDataMap
		{
			return _entityDataMap;			
		}
		
		public function getEntityInteraction():EntityInteraction
		{
			if( !_entityInteraction )
			{
				_entityInteraction = new EntityInteractionImpl();
			}
			return _entityInteraction;
		}
	}
}