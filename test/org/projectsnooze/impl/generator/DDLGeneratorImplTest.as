package org.projectsnooze.impl.generator
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.scheme.SchemeBuilder;

	public class DDLGeneratorImplTest extends TestCase
	{
		private var _generator : DDLGeneratorImpl;
		
		public function DDLGeneratorImplTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new DDLGeneratorImplTest( "testGetDDL" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			var builder : SchemeBuilder = new SchemeBuilderImpl()
   			builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			builder.setTypeUtils( new TypeUtilsImpl () );
			builder.setTypeFactory( new TypeFactoryImpl () );
			builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
			
			builder.addEntityClass( SchoolClass );
			builder.addEntityClass( Child );
			builder.addEntityClass( Mother );
			builder.addEntityClass( Concern );
			builder.generateEntityDataMaps();
			
   			_generator = new DDLGeneratorImpl();
   			_generator.setEntityDataMapProvider( builder.getEntityDataMapProvider() );
   		}
   		
   		override public function tearDown():void
   		{
   			_generator = null;
   		}
   		
   		public function testGetDDL () : void
   		{
   			//trace ( _generator.getDDL().getSQL() );
   			assertTrue( true );
   		}
	}
}