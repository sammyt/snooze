
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
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.NameTypeMapping;

	/**
	 * 	@inheritDoc
	 */ 
	public class StatementCreaterImpl implements StatementCreator
	{
		private static var logger:ILogger = Log.getLogger( "StatementCreaterImpl" );
		
		private const ValuePrefix:String = ":";
		
		public function StatementCreaterImpl()
		{
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getRelationshipInsert ( relationship:Relationship ,
			dataOne:EntityDataMap , dataTwo:EntityDataMap ):Statement
		{
			
			return null;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getSelectStatement( data:EntityDataMap ):Statement
		{
			return null;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getInsertStatement( data:EntityDataMap ):Statement
		{
			var statement:Statement = new StatementImpl();
			var sql:String = "";
			
			sql = "INSERT INTO "; 
			sql += data.getTableName();
			sql +=  " (";
			
			var names:Array = new Array();
			addForeignKeys( names , data );
			addArgList( names , data );
			
			sql += getCsvFromArray( names );
			sql += ") ";
			sql += " VALUES ("
			
			var valueNames:Array = new Array();
			addForeignKeys( valueNames , data , ValuePrefix );
			addArgList( valueNames , data , ValuePrefix );
			
			sql += getCsvFromArray( valueNames );
			sql += ");";
			
			statement.setSqlSkeleton( sql );
			
			return statement;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getUpdateStatement( data:EntityDataMap ):Statement
		{
			return null;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getDeleteStatement( data:EntityDataMap ):Statement
		{
			return null;
		}
		
		private function addPrimaryKey ( values:Array , 
			data:EntityDataMap , preFix:String = "" ):String
		{
			var mapping:NameTypeMapping = data.getPrimaryKey()
			values.push( preFix + mapping.getLowerCaseName() );
			
			return getCsvFromArray( values );
		}
		
		private function addForeignKeys ( values:Array , 
			data:EntityDataMap , preFix:String = "" ):String
		{
			//logger.debug ( "addForeignKeys( {0} , {1} , {2} )" , 
			//	values , data , preFix );
				
			for ( var i:Iterator = data.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship:Relationship = i.next() as Relationship;
				
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var tableName:String = 
						relationship.getEntityDataMap().getTableName().toLowerCase();
						 
					var idName:String = 
						relationship.getEntityDataMap().getPrimaryKey().getLowerCaseName();
						
					values.push( preFix + tableName + "_" + idName );
				}
			}
			return getCsvFromArray( values );
		}
		
		private function addArgList ( values:Array , 
			data:EntityDataMap , preFix:String = "" ):String
		{
			for ( var i:Iterator = data.getPropertyIterator() ; i.hasNext() ; )
			{
				var mapping:NameTypeMapping = i.next() as NameTypeMapping;
				if ( ! mapping.isPrimaryKey() )
				{
					values.push( preFix + mapping.getLowerCaseName() );
				}
			}
			return  getCsvFromArray( values );
		}
		
		private function getCsvFromArray ( list:Array ):String
		{
			var csv:String = "";
			for ( var i:int = 0 ; i < list.length ; i++ )
			{
				csv += list[i];
				csv += i < list.length - 1 ? ",":"";
			}
			return csv;
		}
		
		/**
		 * 	@inheritDoc
		 */
		public function getStatementByType ( type:String , data:EntityDataMap ):Statement
		{
			switch ( type )
			{
				case "insert":
					return getInsertStatement( data );
					break;
				case "update":
					return getUpdateStatement( data );
					break;
				case "select":
					return getSelectStatement( data );
					break;
				case "delete":
					return getDeleteStatement( data );
					break;
			}
			return null;
		}
	}
}