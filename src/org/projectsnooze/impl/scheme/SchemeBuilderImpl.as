package org.projectsnooze.impl.scheme
{
	import flash.utils.describeType;
	
	import org.projectsnooze.NameTypeMapping;
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.constants.MetaData;
	import org.projectsnooze.datatype.Type;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.impl.NameTypeMappingImpl;
	import org.projectsnooze.impl.associations.RelationshipImpl;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.SchemeBuilder;
	
	public class SchemeBuilderImpl implements SchemeBuilder
	{
		private var _classes : Array;
		private var _typeFactory : TypeFactory;
		private var _typeUtils : TypeUtils;
		private var _linkTypeFactory : LinkTypeFactory;
		private var _entityDataMapProvider : EntityDataMapProvider;
		
		public function SchemeBuilderImpl()
		{
			_classes = new Array ();
		}

		public function addEntityClass ( clazz : Class ) : void
		{
			_classes.push( clazz );	
		}
		
		public function generateEntityDataMaps () : void
		{
			createNonRelatedDataMaps();
			relateDataMaps();
		}
		
		private function relateDataMaps () : void
		{
			for ( var i : int = 0 ; i < _classes.length ; i ++ )
			{
				var entity : * = new ( _classes[i] as Class )();
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
					var describedByMetadata : Relationship = new RelationshipImpl();
						
					var describedClazz : String = getTypeUtils().getTypeFromMetadata( method );
					var describedEntityDataMap : EntityDataMap = getEntityDataMapProvider().getEntityDataMapByClassName( describedClazz );
					
					describedByMetadata.setEntityDataMap( entityDataMap );
					describedByMetadata.setType( getLinkTypeFactory().getLinkType( method.metadata.@name , false ) );
					describedByMetadata.setPropertyName( name );
					describedByMetadata.setIsEntityContainer( false );
					describedEntityDataMap.addRelationship( describedByMetadata ); 

					hasMetadata.setEntityDataMap( describedEntityDataMap );
					hasMetadata.setType( getLinkTypeFactory().getLinkType( method.metadata.@name , true ) );
					hasMetadata.setPropertyName( name );
					hasMetadata.setIsEntityContainer( true );
					entityDataMap.addRelationship( hasMetadata );
					
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