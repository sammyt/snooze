package org.projectsnooze.impl.dependency
{	
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.EntityDataMap;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import flash.utils.*;
	
	public class RetrieveDepNode extends AbstractDependencyNodeImpl
	{
		private static var _logger:ILogger = Log.getLogger( "RetrieveDepNode" );
		
		protected var _entityDataMapProvider:EntityDataMapProvider;
		protected var _entity:Object;
		protected var _id:Object;
		
		/**
		*	Creates instance of <code>RetrieveDepNode</code>
		*/	
		public function RetrieveDepNode()
		{
			super();
		}
		
		protected function addParameters():void
		{
			var dataMap:EntityDataMap = getEntityDataMapProvider().getEntityDataMap( _entity );
			
			_logger.debug( "addParameters " + _entity + " " + dataMap + " " + _id );
			
			_logger.debug( "addParameters " + dataMap.getPrimaryKey() + " " +  getStatement() );
						
			getStatement().addValue( ":" + dataMap.getPrimaryKey().getName() , _id );
		}
		
		/**
		*	@inheritDoc
		*/	
		override public function begin():void
		{
			super.begin();
			addParameters();
			var wrapper:StatementWrapper = new StatementWrapperImpl( getStatement() , this );
			getStatementQueue().add( wrapper );
		}
		
		public function setEntity( entity:Object ):void
		{
			_entity = entity;
		}
		
		public function setId( id:Object ):void
		{
			_id = id;
		}
		
		/**
		*	@inheritDoc
		*/
		override public function result( result:Object ):void
		{	
			var list:Array = result.data as Array;
			
			if ( list.length > 0 )
			{
				for( var obj:String in list[0] )
				{
					_logger.debug( "obj:" + obj + " = " + list[0][obj] );
				}
			}
			else
			{
				throw new Error( "Entity of class " + 
				 	getQualifiedClassName( _entity ) + " and id "
				  	+ _id + " could not be found" );
			}
			super.result( result );
		}
		
		/**
		* 	@inheritDoc
		*/ 
		override public function getUniqueObject ():Object
		{
			return _entity;
		}
		
		public function getEntityDataMapProvider():EntityDataMapProvider
		{ 
			return _entityDataMapProvider; 
		}

		public function setEntityDataMapProvider( entityDataMapProvider:EntityDataMapProvider ):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
	}
}