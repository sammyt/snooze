package org.projectsnooze.impl
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.logging.ILogger;
	
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.generator.StatementCreaterImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.scheme.EntityDataMap;
	import org.projectsnooze.scheme.SchemeBuilder;
	import org.projectsnooze.utils.SnoozeLog;

	public class StatementCreatorImplTest extends TestCase
	{
		private var _creator : StatementCreaterImpl;
		private var _builder : SchemeBuilder;
		private static var logger : ILogger;
		
		public function StatementCreatorImplTest(methodName:String=null)
		{
			super(methodName);
			logger = SnoozeLog.getLogger ( this );
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new StatementCreatorImplTest( "testGetSomeSQL" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_builder = new SchemeBuilderImpl()
   			_builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			_builder.setTypeUtils( new TypeUtilsImpl () );
			_builder.setTypeFactory( new TypeFactoryImpl () );
			_builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
			
			_builder.addEntityClass( SchoolClass );
			_builder.addEntityClass( Child );
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
   			_creator = new StatementCreaterImpl();
   		}
   		
   		override public function tearDown():void
   		{
   			_creator = null;
   			_builder = null;
   		}
		
		public function testGetSomeSQL () : void
		{
			var data : EntityDataMap = _builder.getEntityDataMapProvider().getEntityDataMap( new SchoolClass () );
			//logger.info( _creator.getInsertSql( data ).getSQL() );
			assertTrue( false );
			
		}
				
	}
}