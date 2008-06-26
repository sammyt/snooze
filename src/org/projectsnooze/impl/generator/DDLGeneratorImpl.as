
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
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.constants.MetaData;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.Statement;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.NameTypeMapping;
	

	public class DDLGeneratorImpl implements DDLGenerator
	{
		private static var logger : ILogger = Log.getLogger( "DDLGeneratorImpl" );
		
		private var _entityDataMapProvider : EntityDataMapProvider;
		
		/**
		*	@inheritDoc
		*/
		public function DDLGeneratorImpl()
		{
		}
		
		/**
		*	@inheritDoc
		*/
		public function setEntityDataMapProvider(
			entityDataMapProvider:EntityDataMapProvider):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getEntityDataMapProvider():EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getDDLStatements () : Array
		{
			var statements : Array = new Array();
			
			// for each entity data map create the necessary tables
			for ( var i : Iterator = getEntityDataMapProvider().getIterator() ; 
				i.hasNext() ; )
			{
				// a list cotaining the line of sql that make up the 
				// create table command for the given entity
				var values : Array = new Array();
				
				// the entity data map being inspected 
				var entityDataMap : EntityDataMap = i.next() as EntityDataMap;
				
				// the string that will contain the sql
				var sqlSkeleton : String = "";
				
				// create the table from the table name in the entity data map
				sqlSkeleton += " CREATE TABLE IF NOT EXISTS " + 
					entityDataMap.getTableName() + " ( "; 
				
				// add the primary key for the table
				addPrimaryKey ( entityDataMap , values );
				
				// add any foreign keys required by the relationships 
				// described in the entity data map
				addForeignKeys ( entityDataMap , values );
				
				// add all the properties that map directly to 
				// columns in the database (the natural properties)
				addNaturalProperties( entityDataMap , values );
				
				// add the values created above to the sql
				sqlSkeleton += getCsvFromArray( values );
				sqlSkeleton += " );";
				
				// create a Statement object from the generated sql
				// and add it to the statements array to be returned 
				var statement : Statement = new StatementImpl();
				statement.setSqlSkeleton( sqlSkeleton );
				statements.push( statement );
			}
			
			// creating tables for each entity data map is not enough
			// as manay to many relationships cannot be descibed without
			// a seperate joining table.  Statements to create such joining
			// tables are added now
			addManyToManyTables( statements ); 
			
			return statements;
		}
		
		/**
		*	@inheritDoc
		*/	
		public function getDropStatements () : Array
		{
			var statements : Array = new Array();
			
			for ( var iterator : Iterator = getEntityDataMapProvider().getIterator() ; 
				iterator.hasNext() ; )
			{
				var entityDataMap : EntityDataMap = iterator.next() as EntityDataMap;
				
				var sqlSkeleton : String = "";
				
				sqlSkeleton += " DROP TABLE IF EXISTS " + entityDataMap.getTableName(); 
				
				sqlSkeleton += "; ";
				
				var statement : Statement = new StatementImpl();
				statement.setSqlSkeleton( sqlSkeleton );
				statements.push( statement );			
			}
			
			removeManyToManyTables( statements );
			
			return statements;
		}
		
		private function removeManyToManyTables ( statements : Array ) : void
		{
			// holds the name of the tables already dropped
			var droppedNames : Dictionary = new Dictionary();
			
			// loop through all the entity data maps
			for ( var i : Iterator = getEntityDataMapProvider().getIterator() ; i.hasNext() ; )
			{
				var entityDataMap : EntityDataMap = i.next() as EntityDataMap;
				
				// loop through all the relationships each entity data map contains
				for ( var j : Iterator = entityDataMap.getRelationshipIterator() ; j.hasNext() ; )
				{
					var relationship : Relationship = j.next() as Relationship;
					
					// where the relationship is many-to-many
					if ( relationship.getType().getName() == MetaData.MANY_TO_MANY )
					{
						// only need to drop the tables once, so need to keep
						// track of which ones have been dropped
						if ( ! droppedNames[ relationship.getJoinTableName() ] )
						{
							// create the statement object
							var statement : Statement = new StatementImpl();
							
							// set the create table statement for the join table
							statement.setSqlSkeleton( "DROP TABLE IF EXISTS " + 
							 	relationship.getJoinTableName() + ";" );
							
							// record that this table has been created
							droppedNames[ relationship.getJoinTableName() ] = true;
							
							// add the statement to the statements array
							statements.push( statement );
						}
					}
				}
			}
		}
		
		private function addManyToManyTables ( statements : Array ) : void
		{	
			// holds the name of the tables already created
			var addedNames : Dictionary = new Dictionary();
			
			// loop through all the entity data maps
			for ( var i : Iterator = getEntityDataMapProvider().getIterator() ; i.hasNext() ; )
			{
				var entityDataMap : EntityDataMap = i.next() as EntityDataMap;
				
				// loop through all the relationships each entity data map contains
				for ( var j : Iterator = entityDataMap.getRelationshipIterator() ; j.hasNext() ; )
				{
					var relationship : Relationship = j.next() as Relationship;
					
					// where the relationship is many-to-many
					if ( relationship.getType().getName() == MetaData.MANY_TO_MANY )
					{
						// only need to create the tables once, so need to keep
						// track of which ones have been created
						if ( ! addedNames[ relationship.getJoinTableName() ] )
						{
							// create the statement object
							var statement : Statement = new StatementImpl();
							
							// set the create table statement for the join table
							statement.setSqlSkeleton( "CREATE TABLE IF NOT EXISTS " + 
							 	relationship.getJoinTableName() + " ( " +
								entityDataMap.getForeignKeyName() + " INTEGER NOT NULL," +
								relationship.getEntityDataMap().getForeignKeyName() + " INTEGER NOT NULL" +
							 	" ); " );
							
							// record that this table has been created
							addedNames[ relationship.getJoinTableName() ] = true;
							
							// add the statement to the statements array
							statements.push( statement );
						}
					}
				}
			}
		}
		
		private function addIndexes () : void
		{
			
		}
		
		private function addPrimaryKey ( entityDataMap : EntityDataMap , values : Array ) : void
		{
			var mapping : NameTypeMapping = entityDataMap.getPrimaryKey();
			values.push( mapping.getLowerCaseName() + " " + 
				mapping.getType().getSQLType() + " PRIMARY KEY AUTOINCREMENT" ) ;
		}
		
		private function addForeignKeys ( entityDataMap : EntityDataMap , values : Array ) : void
		{
			for ( var iterator : Iterator = entityDataMap.getRelationshipIterator() ; 
				iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				if ( relationship.getType().getForeignKeyContainer() )
				{
					var tableName : String = relationship.getEntityDataMap().getTableName().toLowerCase();
					var idName : String = relationship.getEntityDataMap().getPrimaryKey().getLowerCaseName();
					values.push( tableName + "_" + idName + " " +
						relationship.getEntityDataMap().getPrimaryKey().getType().getSQLType() + "  NOT NULL" );
				}
			}
		}
		
		private function addNaturalProperties ( entityDataMap : EntityDataMap , values : Array ) : void
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
