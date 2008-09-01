package org.projectsnooze.impl.generator
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
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.utils.SnoozeLog;
	
	import some.other.domain.Club;
	import some.other.domain.Player;
	import some.other.domain.Tournament;

	public class DDLGeneratorImplTest extends TestCase
	{
		private var _generator:DDLGeneratorImpl;
		private var _builder:SchemeBuilderImpl;
		
		private static var logger:ILogger;
		
		public function DDLGeneratorImplTest(methodName:String=null)
		{
			super(methodName);
			logger = SnoozeLog.getLogger ( this );
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			//ts.addTest( new DDLGeneratorImplTest( "testGetDDL" ) );
   			ts.addTest( new DDLGeneratorImplTest( "testGetDDL2" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_builder = new SchemeBuilderImpl()
   			_builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			_builder.setTypeUtils( new TypeUtilsImpl () );
			_builder.setTypeFactory( new TypeFactoryImpl () );
			_builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
			
			
   			_generator = new DDLGeneratorImpl();
   			_generator.setEntityDataMapProvider( _builder.getEntityDataMapProvider() );
   		}
   		
   		override public function tearDown():void
   		{
   			_generator = null;
   		}
   		
   		public function testGetDDL ():void
   		{
   			
			_builder.addEntityClass( SchoolClass );
			_builder.addEntityClass( Child );
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
   			//trace ( _generator.getDDL().getSQL() );
			assertTrue( false );

   		}
   		
   		public function testGetDDL2 ():void
   		{
   			
			_builder.addEntityClass( Tournament );
			_builder.addEntityClass( Player );
			_builder.addEntityClass( Club );
			_builder.generateEntityDataMaps();
			
   			assertTrue( false );
   		}
	}
}














