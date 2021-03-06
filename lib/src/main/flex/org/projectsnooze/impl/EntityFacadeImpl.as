
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
	import flash.filesystem.File;
	
	import org.projectsnooze.EntityFacade;
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.connections.ConnectionPool;
	import org.projectsnooze.datatype.TypeFactory;
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.execute.QueueManager;
	import org.projectsnooze.generator.DDLGenerator;
	import org.projectsnooze.generator.StatementCreator;
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.connections.ConnectionPoolImpl;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.dependency.DependencyTreeCreatorImpl;
	import org.projectsnooze.impl.execute.QueueManagerImpl;
	import org.projectsnooze.impl.generator.DDLGeneratorImpl;
	import org.projectsnooze.impl.generator.StatementCreaterImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.impl.session.DispatcherImpl;
	import org.projectsnooze.impl.session.SessionImpl;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.SchemeBuilder;
	import org.projectsnooze.session.Dispatcher;
	import org.projectsnooze.session.Session;

	public class EntityFacadeImpl implements EntityFacade
	{
		protected var _databaseName:String = "snooze.db";
		protected var _schemeBuilder:SchemeBuilder;
		protected var _entityDataMapProvider:EntityDataMapProvider;
		protected var _typeUtils:TypeUtils;
		protected var _typeFactory:TypeFactory;
		protected var _linkTypeFactory:LinkTypeFactory;
		protected var _statementCreator:StatementCreator;
		protected var _connectionPool:ConnectionPool;
		protected var _dependencyTreeCreator:DependencyTreeCreator;
		protected var _ddlGenerator:DDLGenerator;
		protected var _queueManager:QueueManager;
		protected var _dispatcher:Dispatcher;
		
		public function EntityFacadeImpl( createDDL:Boolean = true , 
			initilise:Boolean = true )
		{
			if ( initilise ) init();
		}
		
		public function init ():void
		{
			_entityDataMapProvider = new EntityDataMapProviderImpl();
			_typeUtils = new TypeUtilsImpl();
			_typeFactory = new TypeFactoryImpl();
			_linkTypeFactory = new LinkTypeFactoryImpl();
			_statementCreator = new StatementCreaterImpl();
			_connectionPool = new ConnectionPoolImpl();
			_connectionPool.setFile( 
				File.applicationDirectory.resolvePath( getDatabaseName() ) );
			
			_queueManager = new QueueManagerImpl(); 
			_queueManager.setConnectionPool( getConnectionPool() );
			
			_ddlGenerator = new DDLGeneratorImpl();
			_ddlGenerator.setEntityDataMapProvider( getEntityDataMapProvider() );
			
			_dependencyTreeCreator = new DependencyTreeCreatorImpl();
			_dependencyTreeCreator.setTypeUtils( getTypeUtils() );
			_dependencyTreeCreator.setEntityDataMapProvider( getEntityDataMapProvider() );
			_dependencyTreeCreator.setStatementCreator( getStatementCreator() );
			_dependencyTreeCreator.setQueueManager( getQueueManager() );
			
			_schemeBuilder = new SchemeBuilderImpl();
			_schemeBuilder.setEntityDataMapProvider( getEntityDataMapProvider() );
			_schemeBuilder.setLinkTypeFactory( getLinkTypeFactory() );
			_schemeBuilder.setTypeFactory( getTypeFactory() );
			_schemeBuilder.setTypeUtils( getTypeUtils() );
		}
		
		public function setDatabaseName ( databaseName:String ):void
		{
			_databaseName = databaseName;
		}
		
		public function getDatabaseName ():String
		{
			return _databaseName;
		}
		
		public function setQueueManager ( queueManager:QueueManager ):void
		{
			_queueManager = queueManager;
		}
		
		public function getQueueManager ():QueueManager
		{
			return _queueManager;
		}
		
		public function addEntityClass(clazz:Class):void
		{
			getSchemeBuilder().addEntityClass( clazz );
		}
		
		public function setSchemeBuilder(schemeBuilder:SchemeBuilder):void
		{
			_schemeBuilder = schemeBuilder;
		}
		
		public function getSchemeBuilder():SchemeBuilder
		{
			return _schemeBuilder;
		}
		
		public function setEntityDataMapProvider(
			entityDataMapProvider:EntityDataMapProvider):void
		{
			_entityDataMapProvider = entityDataMapProvider;
		}
		
		public function getEntityDataMapProvider():EntityDataMapProvider
		{
			return _entityDataMapProvider;
		}
		
		public function setTypeUtils(typeUtils:TypeUtils):void
		{
			_typeUtils = typeUtils;
		}
		
		public function getTypeUtils():TypeUtils
		{
			return _typeUtils;
		}
		
		public function setTypeFactory(typeFactory:TypeFactory):void
		{
			_typeFactory = typeFactory;
		}
		
		public function getTypeFactory():TypeFactory
		{
			return _typeFactory;
		}
		
		public function setLinkTypeFactory(linkTypeFactory:LinkTypeFactory):void
		{
			_linkTypeFactory = linkTypeFactory;
		}
		
		public function getLinkTypeFactory ():LinkTypeFactory
		{
			return _linkTypeFactory;
		}
		
		public function setStatementCreator(statementCreator:StatementCreator):void
		{
			_statementCreator = statementCreator;
		}
		
		public function getStatementCreator():StatementCreator
		{
			return _statementCreator;
		}
		
		public function setConnectionPool(connectionPool:ConnectionPool):void
		{
			_connectionPool = connectionPool;
		}
		
		public function getConnectionPool():ConnectionPool
		{
			return _connectionPool;
		}
		
		public function setDependencyTreeCreator(
			dependencyTreeCreator:DependencyTreeCreator):void
		{
			_dependencyTreeCreator = dependencyTreeCreator;
		}
		
		public function getDependencyTreeCreator():DependencyTreeCreator
		{
			return _dependencyTreeCreator;
		}
		
		public function setDDLGenerator(ddlGenerator:DDLGenerator):void
		{
			_ddlGenerator = ddlGenerator;
		}
		
		public function getDDLGenerator():DDLGenerator
		{
			return _ddlGenerator;
		}
		
		public function prepare ():void
		{
			if ( ! getSchemeBuilder().areEntityDataMapsGenerated() )
			{
				getSchemeBuilder().generateEntityDataMaps();
			}
		}
		
		public function getSession():Session
		{
			prepare();
			
			var session:Session = new SessionImpl();
			session.setDependencyTreeCreator( getDependencyTreeCreator() );
			session.setDDLGenerator( getDDLGenerator() );
			session.setQueueManager( getQueueManager() );
			session.setDispatcher( dispatcher );
			
			return session;
		}
		
		public function get dispatcher():Dispatcher
		{
			if ( !_dispatcher )
			{
				_dispatcher = new DispatcherImpl();
			}
			return _dispatcher;
		}
	}
}