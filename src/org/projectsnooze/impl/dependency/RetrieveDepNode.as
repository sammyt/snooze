package org.projectsnooze.impl.dependency
{	
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.impl.execute.StatementWrapperImpl;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	
	public class RetrieveDepNode extends AbstractDependencyNodeImpl
	{
		protected var _entityDataMapProvider:EntityDataMapProvider;
		protected var _entity:Object;
		
		/**
		*	Creates instance of <code>RetrieveDepNode</code>
		*/	
		public function RetrieveDepNode()
		{
			super();
		}
		
		/**
		*	@inheritDoc
		*/	
		override public function begin():void
		{
			super.begin();
			
			var wrapper:StatementWrapper = new StatementWrapperImpl( getStatement() , this );
			getStatementQueue().add( wrapper );
		}
		
		public function setEntity( entity:Object ):void
		{
			_entity = entity;
		}
		
		/**
		*	@inheritDoc
		*/
		override public function result( data:Object ):void
		{	
			//TODO: pass the sql result into the entity
			
			super.result( data );
		}
		
		/**
		* 	@inheritDoc
		*/ 
		override public function getUniqueObject ():Object
		{
			return entity;
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