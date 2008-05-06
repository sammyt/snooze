
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
 
package org.projectsnooze.impl
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.StatementCreator;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.impl.generator.StatementImpl;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;

	public class StatementCreaterImpl implements StatementCreator
	{
		private static var logger : ILogger = Log.getLogger( "StatementCreaterImpl" );
		
		private const ValuePrefix : String = ":";
		
		public function StatementCreaterImpl()
		{
		}

		public function getSelectSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		public function getInsertSql( data : EntityDataMap ):Statement
		{
			var statement : Statement = new StatementImpl();
			var sql : String = "";
			
			sql = "INSERT INTO "; 
			sql += data.getTableName();
			sql +=  " (";
			
			var names : Array = new Array();
			addForeignKeys( names , data );
			addArgList( names , data );
			
			sql += getCsvFromArray( names );
			sql += ") ";
			sql += " VALUES ("
			
			var valueNames : Array = new Array();
			addForeignKeys( valueNames , data , ValuePrefix );
			addArgList( valueNames , data , ValuePrefix );
			
			sql += getCsvFromArray( valueNames );
			sql += ");";
			
			statement.setSqlSkeleton( sql );
			
			return statement;
		}
		
		public function getUpdateSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		public function getDeleteSql( data : EntityDataMap ):Statement
		{
			return null;
		}
		
		private function addPrimaryKey ( values : Array , data : EntityDataMap , preFix : String = "" ) : String
		{
			var mapping : NameTypeMapping = data.getPrimaryKey()
			values.push( preFix + mapping.getLowerCaseName() );
			
			return getCsvFromArray( values );
		}
		
		private function addForeignKeys ( values : Array , data : EntityDataMap , preFix : String = "" ) : String
		{
			for ( var iterator : Iterator = data.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var name : String = relationship.getEntityDataMap().getTableName().toLowerCase() + "_" + relationship.getPropertyName().toLowerCase();
					values.push( preFix + name );
				}
			}
			return getCsvFromArray( values );
		}
		
		private function addArgList ( values : Array , data : EntityDataMap , preFix : String = "" ) : String
		{
			for ( var iterator : Iterator = data.getPropertyIterator() ; iterator.hasNext() ; )
			{
				var mapping : NameTypeMapping = iterator.next() as NameTypeMapping;
				if ( ! mapping.isPrimaryKey() )
				{
					values.push( preFix + mapping.getLowerCaseName() );
				}
			}
			return  getCsvFromArray( values );
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