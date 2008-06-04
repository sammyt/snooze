
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
	
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.constants.MetaData;
	import org.projectsnooze.datatype.Type;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.impl.associations.ManyToMany;
	import org.projectsnooze.impl.associations.RelationshipImpl;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.NameTypeMapping;
	import org.projectsnooze.scheme.SchemeBuilder;
	
	public class SchemeBuilderImpl implements SchemeBuilder
	{
		private var _classes : Array;
		private var _typeFactory : TypeFactory;
		private var _typeUtils : TypeUtils;
		private var _linkTypeFactory : LinkTypeFactory;
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _mapsAreGenerated : Boolean;
		
		public function SchemeBuilderImpl()
		{
			_classes = new Array ();
			_mapsAreGenerated = false;
		}

		public function addEntityClass ( clazz : Class ) : void
		{
			_classes.push( clazz );	
		}
		
		public function generateEntityDataMaps () : void
		{
			createNonRelatedDataMaps();
			relateDataMaps();
			_mapsAreGenerated = true;
		}
		
		private function relateDataMaps () : void
		{
			for ( var iterator : Iterator = new ArrayIterator ( _classes ) ; iterator.hasNext() ; )
			{
				var entity : * = new ( iterator.next() as Class )();
				var reflection : XML = describeType( entity );
				
				addRelationships( reflection , getEntityDataMapProvider().getEntityDataMapByClassName( reflection.@name ) );
			}
		}
		
		private function createNonRelatedDataMaps () : void
		{
			for ( var i : int = 0 ; i < _classes.length ; i ++ )
			{
				var entity : * = new ( _classes[i] as Class )();
				var reflection : XML = describeType( entity );
				var entityDataMap : EntityMapDataImp = new EntityMapDataImp();
				
				var name : String = reflection.@name;
				var tableName : String = name.substr( name.indexOf( "::" ) + 2 , name.length - name.indexOf("::") );
				
				entityDataMap.setTableName( tableName );
				
				addNatralProperties( reflection , entityDataMap );
				addId( reflection , entityDataMap );
				getEntityDataMapProvider().setEntityDataMap( reflection.@name , entityDataMap );
			}	
		}
		
		private function addRelationships (  reflection : XML , entityDataMap : EntityDataMap ) : void
		{
			for each ( var method : XML in reflection.method )
			{
				if ( isRelationship( method.metadata.@name ) )
				{
					var getter : String = method.@name;
					var name : String = getter.substr( 3 , getter.length );
					
					var hasMetadata : Relationship = new RelationshipImpl();
					
					var describedClazz : String = getTypeUtils().getTypeFromMetadata( method );
					var describedEntityDataMap : EntityDataMap = getEntityDataMapProvider().getEntityDataMapByClassName( describedClazz );
					
					if ( getLinkTypeFactory().getLinkType( method.metadata.@name , false ).getName() != new ManyToMany().getName() )
					{
						var describedByMetadata : Relationship = new RelationshipImpl();
						describedByMetadata.setEntityDataMap( entityDataMap );
						describedByMetadata.setType( getLinkTypeFactory().getLinkType( method.metadata.@name , false ) );
						describedByMetadata.setPropertyName( name );
						describedByMetadata.setIsEntityContainer( false );
						describedEntityDataMap.addRelationship( describedByMetadata ); 
					}
					
					hasMetadata.setEntityDataMap( describedEntityDataMap );
					hasMetadata.setType( getLinkTypeFactory().getLinkType( method.metadata.@name , true ) );
					hasMetadata.setPropertyName( name );
					hasMetadata.setIsEntityContainer( true );
					entityDataMap.addRelationship( hasMetadata );
					
					//trace( "creating : " , hasMetadata.getType().getName() , describedByMetadata.getType().getName() , name );
				}
			}
		}
		
		private function isRelationship ( metaDataName : String ) : Boolean
		{
			return ( metaDataName == MetaData.MANY_TO_ONE || metaDataName == MetaData.MANY_TO_MANY || metaDataName == MetaData.ONE_TO_MANY );
		}
		
		private function addId ( reflection : XML , entityDataMap : EntityDataMap ) : void
		{
			for each ( var method : XML in reflection.method )
			{
				if ( method.metadata.@name == MetaData.ID )
				{
					var getter : String = method.@name;
					var name : String = getter.substr( 3 , getter.length );
					var type : Type =  getTypeFactory().getType( method.@returnType );
					
					var mapping : NameTypeMapping = new NameTypeMappingImpl();
					mapping.setName( name );
					mapping.setType( type );
					mapping.setIsPrimaryKey( true );
					entityDataMap.setPrimaryKey( mapping );
				}
			}
		}
		
		private function addNatralProperties ( reflection : XML , entityDataMap : EntityDataMap ) : void
		{
			for each ( var method : XML in reflection.method )
			{
				var getter : String = method.( ! hasOwnProperty( "metadata" ) ).@name;
				if ( getter.substr( 0, 3 ) == "get" )
				{
					var name : String = getter.substr( 3 , getter.length );
					var type : Type =  getTypeFactory().getType( method.@returnType );
					
					var mapping : NameTypeMapping = new NameTypeMappingImpl();
					mapping.setName( name );
					mapping.setType( type );
					entityDataMap.addProperty( mapping );
				} 
			}
		}
		
		public function areEntityDataMapsGenerated () : Boolean
		{
			return _mapsAreGenerated;
		}
		
		public function setTypeFactory ( typeFactory : TypeFactory ) : void
		{
			_typeFactory = typeFactory;
		}
		
		public function getTypeFactory () : TypeFactory
		{
			return _typeFactory;
		}
		
		public function setTypeUtils ( typeUtils : TypeUtils ) : void
		{
			_typeUtils = typeUtils;
		}
		
		public function getTypeUtils () : TypeUtils
		{
			return _typeUtils;
		}
		
		public function setLinkTypeFactory ( linkTypeFactory : LinkTypeFactory ) : void
		{
			_linkTypeFactory = linkTypeFactory;
		}
		
		public function getLinkTypeFactory () : LinkTypeFactory
		{
			return _linkTypeFactory
		} 
		
		public function setEntityDataMapProvider ( entityDataMapProvider : EntityDataMapProvider ) : void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function getEntityDataMapProvider ( ) : EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
	}
}