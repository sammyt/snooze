
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
 
package org.projectsnooze.impl.generator
{
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;

	public class DDLGeneratorImpl implements DDLGenerator
	{
		private var _entityDataMapProvider : EntityDataMapProvider;
		
		public function DDLGeneratorImpl()
		{
		}

		public function setEntityDataMapProvider(entityDataMapProvider:EntityDataMapProvider):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function getEntityDataMapProvider():EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		public function getDDL():Statement
		{
			var sqlSkeleton : String = "";
			 
			for ( var iterator : Iterator = getEntityDataMapProvider().getIterator() ; iterator.hasNext() ; )
			{
				var values : Array = new Array();
				var entityDataMap : EntityDataMap = iterator.next() as EntityDataMap;
				
				sqlSkeleton += "\n CREATE TABLE IF NOT EXISTS " + entityDataMap.getTableName() + " ( "; 
				
				addPrimaryKey ( entityDataMap , values );
				addForignKeys ( entityDataMap , values );
				addNatrualProperties( entityDataMap , values );
				
				sqlSkeleton += getCsvFromArray( values );
				
				sqlSkeleton += " );";
			}
			
			var statement : Statement = new StatementImpl()
			statement.setSqlSkeleton( sqlSkeleton );
			
			return statement;
		}
		
		private function addPrimaryKey ( entityDataMap : EntityDataMap , values : Array ) : void
		{
			var mapping : NameTypeMapping = entityDataMap.getPrimaryKey();
			values.push( mapping.getLowerCaseName() + " " + mapping.getType().getSQLType() + " PRIMARY KEY AUTOINCREMENT" ) ;
		}
		
		private function addForignKeys ( entityDataMap : EntityDataMap , values : Array ) : void
		{
			
			for ( var iterator : Iterator = entityDataMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var tableName : String = relationship.getEntityDataMap().getTableName().toLowerCase();
					var idName : String = relationship.getEntityDataMap().getPrimaryKey().getLowerCaseName();
					values.push( tableName + "_" + idName + " " + relationship.getEntityDataMap().getPrimaryKey().getType().getSQLType() );
				}
			}
			
		}
		
		private function addNatrualProperties ( entityDataMap : EntityDataMap , values : Array ) : void
		{
			for ( var iterator : Iterator = entityDataMap.getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				values.push( mapping.getLowerCaseName() + " " + mapping.getType().getSQLType() );
			}
		}
		
		
		private function getCsvFromArray ( list : Array ) : String
		{
			var csv : String = "";
			for ( var i : int = 0 ; i < list.length ; i++ )
			{
				csv += list[i];
				csv += i < list.length - 1 ? "," : "";
			}
			return csv;
		}
		
	}
}