
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
 
package org.projectsnooze.impl.scheme
{
	import flash.utils.describeType;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.constants.MetaData;
	import org.projectsnooze.datatype.Type;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.impl.associations.RelationshipImpl;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.NameTypeMapping;
	import org.projectsnooze.scheme.SchemeBuilder;
	
	import uk.co.ziazoo.collections.ArrayIterator;
	import uk.co.ziazoo.collections.Iterator;
	import uk.co.ziazoo.reflection.Reflection;
	import uk.co.ziazoo.reflection.ReflectionImpl;
	import uk.co.ziazoo.reflection.MetaDataList;
	import uk.co.ziazoo.reflection.NameAndTypeReference;
	import uk.co.ziazoo.reflection.Variable;
	import uk.co.ziazoo.reflection.Accessor;
	
	public class SchemeBuilderImpl implements SchemeBuilder
	{
		private var _logger:ILogger = Log.getLogger( "SchemeBuilderImpl" );
		
		private var _classes:Array;
		private var _typeFactory:TypeFactory;
		private var _typeUtils:TypeUtils;
		private var _linkTypeFactory:LinkTypeFactory;
		private var _entityDataMapProvider:EntityDataMapProvider;
		private var _mapsAreGenerated:Boolean;
		
		public function SchemeBuilderImpl()
		{
			_classes = new Array ();
			_mapsAreGenerated = false;
		}

		public function addEntityClass ( clazz:Class ):void
		{
			_classes.push( clazz );	
		}
		
		public function generateEntityDataMaps ():void
		{
			createNonRelatedDataMaps();
			relateDataMaps();
			_mapsAreGenerated = true;
		}
		
		private function relateDataMaps ():void
		{
			for ( var i:Iterator = new ArrayIterator ( _classes ) ; i.hasNext() ; )
			{
				var clazz:Class = i.next() as Class;
				var entity:Object = new clazz();
				var reflection:Reflection = new ReflectionImpl( entity );
				
				var dataMap:EntityDataMap = 
					getEntityDataMapProvider().getEntityDataMapByClassName( reflection.getName() );
					
				addForeignKeyRelationships( reflection, dataMap );
				addManyToManyRelationships( reflection, dataMap );
			}
		}
		
		private function createNonRelatedDataMaps ():void
		{
			
			var i:Iterator = new ArrayIterator( _classes );
			for( ; i.hasNext() ; )
			{
				var clazz:Class = i.next() as Class;
				var reflection:Reflection = new ReflectionImpl( new clazz() );
				var dataMap:EntityDataMap = new EntityMapDataImpl();
				
				dataMap.setTableName( reflection.getClassName() );
				
				addNatralProperties( reflection, dataMap );
				addId( reflection, dataMap );
			
				getEntityDataMapProvider().setEntityDataMap( reflection.getName() , dataMap );
			}	
		}
		
		private function addManyToManyRelationships ( reflection:Reflection,
		 	entityDataMap:EntityDataMap ):void
		{
			
			var properties:Array = 
				reflection.getPropertiesWithMetaData( MetaData.MANY_TO_MANY );
				
			var i:Iterator = new ArrayIterator( properties );
			
			for( ; i.hasNext() ; )
			{
				var prop:MetaDataList = i.next() as MetaDataList;
				
				// create a Relationship object to describe the relationship 
				// from the perspective of the annotated class
				var hasMetadata:Relationship = new RelationshipImpl();
				
				var describedClazz:String = prop.getMetaDataByName( 
					MetaData.MANY_TO_MANY ).getArgByKey( "ref" );
					
				// get the entity data map for the entity on the 
				// other side of the relationship
				var describedDataMap:EntityDataMap = 
					getEntityDataMapProvider().getEntityDataMapByClassName( describedClazz );
				
				// add the necessary properties to the relationship
				hasMetadata.setEntityDataMap( describedDataMap );
				hasMetadata.setType( getLinkTypeFactory().getLinkType( 
					MetaData.MANY_TO_MANY , true ) );
				hasMetadata.setIsEntityContainer( true );
				hasMetadata.setNameTypeMapping( createNameTypeMapping( prop, reflection ) );
				
				// add the two table names to an array for sorting
				var tableNames:Array = [ entityDataMap.getTableName() , 
					describedDataMap.getTableName() ];
				
				// sort the names
				tableNames.sort();
				
				// create the table names from the sorted tables names
				hasMetadata.setJoinTableName( tableNames[0] + "_" + tableNames[1] );
				
				entityDataMap.addRelationship( hasMetadata );
			}
		}
		
		private function getGetter( prop:NameAndTypeReference, 
			reflection:Reflection ):NameAndTypeReference
		{
			if( prop is Variable
			 	|| prop is Accessor )
			{
				return prop
			}
			if( prop.getName().substr( 0, 3 ) != "get" )
			{
				var name:String  = prop.getName();
				var propName:String = name.substr( 3, name.length );
				
				if( reflection.getPropertyByName( "get" + propName ) )
				{
					return reflection.getPropertyByName( "get" + propName );
				}
				
				throw new Error( "Could not find getter for " + prop.getName() );
				
			}
			return prop;
		}
		
		private function getSetter( prop:NameAndTypeReference,
		 	reflection:Reflection ):NameAndTypeReference
		{
			if( prop is Variable
			 	|| prop is Accessor )
			{
				return prop
			}
			if( prop.getName().substr( 0, 3 ) != "set" )
			{
				var name:String  = prop.getName();
				var propName:String = name.substr( 3, name.length );
				
				if( reflection.getPropertyByName( "set" + propName ) )
				{
					return reflection.getPropertyByName( "set" + propName );
				}
				
				throw new Error( "Could not find setter for " + prop.getName() );
				
			}
			return prop;
		}
		
		private function addForeignKeyRelationships ( reflection:Reflection , 
			entityDataMap:EntityDataMap ):void
		{
			
			var properties:Array = 
				reflection.getPropertiesWithMetaData();
			
			var i:Iterator = new ArrayIterator( properties );
         
			for( ; i.hasNext() ; )
			{
				var prop:MetaDataList = i.next() as MetaDataList;
				if( prop.hasMetaData( MetaData.MANY_TO_ONE )
				 	|| prop.hasMetaData( MetaData.ONE_TO_MANY ) )	
				{
					var typeName:String = prop.hasMetaData( MetaData.MANY_TO_ONE ) ?
						MetaData.MANY_TO_ONE : MetaData.ONE_TO_MANY;
						
					// create a Relationship object to describe the relationship from
					// the perspective of the annotated class
					var hasMetadata:Relationship = new RelationshipImpl();
					
					var describedClazz:String = prop.getMetaDataByName( 
						typeName ).getArgByKey( "ref" );
						
					// get the entity data map for the entity on the 
					// other side of the relationship
					var describedDataMap:EntityDataMap = 
						getEntityDataMapProvider().getEntityDataMapByClassName( describedClazz );
					
					// create the relationship
					var describedByMetadata:Relationship = new RelationshipImpl();
					describedByMetadata.setEntityDataMap( entityDataMap );
					describedByMetadata.setType( 
						getLinkTypeFactory().getLinkType( typeName , false ) );
					describedByMetadata.setNameTypeMapping( createNameTypeMapping( prop, reflection ) );
					describedByMetadata.setIsEntityContainer( false );
					
					// add the relationship
					describedDataMap.addRelationship( describedByMetadata ); 
					
					// add the necessary properties to the relationship
				  	hasMetadata.setEntityDataMap( describedDataMap );
				 	hasMetadata.setType( getLinkTypeFactory().getLinkType( typeName , true ) );
					hasMetadata.setNameTypeMapping( createNameTypeMapping( prop, reflection ) );
				 	hasMetadata.setIsEntityContainer( true );
              
				  	// add the relationship to the metadata
					entityDataMap.addRelationship( hasMetadata );
					
				}
			}
		}
		
		
		private function addId ( reflection:Reflection, dataMap:EntityDataMap ):void
		{
			
			var ids:Array = reflection.getPropertiesWithMetaData( MetaData.ID );
			
			var mapping:NameTypeMapping = new NameTypeMappingImpl();
			var prop:NameAndTypeReference = null;
			
			if( ids.length > 1 )
			{
				throw new Error( "More than one ID specified for " 
					+ reflection.getName() );
			}
			
			if( ids.length == 0 )
			{
				prop = reflection.getPropertyByName( "id" );
					
				if( !prop )
				{
					throw new Error( "No ID defined for " 
						+ reflection.getName() );
				}
				dataMap.setPrimaryKey( createNameTypeMapping( prop, reflection, true ) );
			}
			
			if( ids.length == 1 )
			{
				prop = ids[0] as NameAndTypeReference;
				dataMap.setPrimaryKey( createNameTypeMapping( prop, reflection, true ) );
			}
		}
		
		private function addNatralProperties ( reflection:Reflection, 
			dataMap:EntityDataMap ):void
		{
			var types:Array = reflection.getPropertiesWithType();
			
			for( var i:Iterator = new ArrayIterator( types ) ; i.hasNext() ; )
			{
				var nameAndType:NameAndTypeReference = i.next() as NameAndTypeReference;
				var mapping:NameTypeMapping = new NameTypeMappingImpl();
				
				if( nameAndType is MetaDataList )
				{
					var metaContainer:MetaDataList = nameAndType as MetaDataList;
					if( !metaContainer.hasMetaData() )
					{
						dataMap.addProperty( createNameTypeMapping( nameAndType, reflection ) );
					}
				}
				else if( nameAndType.getName() != "id" )
				{
					dataMap.addProperty( createNameTypeMapping( nameAndType, reflection ) );
				}
			}
		}
		
		private function createNameTypeMapping( prop:NameAndTypeReference, 
			reflection:Reflection, primaryKey:Boolean = false ):NameTypeMapping
		{
			var mapping:NameTypeMapping = new NameTypeMappingImpl();
			mapping.setGetter( getGetter( prop, reflection ) );
			mapping.setSetter( getSetter( prop, reflection ) );
			mapping.setType( getTypeFactory().getType( prop.getType() ) );
			mapping.setPrimaryKey( primaryKey );
			
			return mapping;
		}
		
		public function areEntityDataMapsGenerated ():Boolean
		{
			return _mapsAreGenerated;
		}
		
		public function setTypeFactory ( typeFactory:TypeFactory ):void
		{
			_typeFactory = typeFactory;
		}
		
		public function getTypeFactory ():TypeFactory
		{
			return _typeFactory;
		}
		
		public function setTypeUtils ( typeUtils:TypeUtils ):void
		{
			_typeUtils = typeUtils;
		}
		
		public function getTypeUtils ():TypeUtils
		{
			return _typeUtils;
		}
		
		public function setLinkTypeFactory ( linkTypeFactory:LinkTypeFactory ):void
		{
			_linkTypeFactory = linkTypeFactory;
		}
		
		public function getLinkTypeFactory ():LinkTypeFactory
		{
			return _linkTypeFactory
		} 
		
		public function setEntityDataMapProvider ( 
			entityDataMapProvider:EntityDataMapProvider ):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function getEntityDataMapProvider ( ):EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
	}
}