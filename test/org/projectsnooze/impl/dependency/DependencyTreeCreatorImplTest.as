package org.projectsnooze.impl.dependency
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
	import org.projectsnooze.scheme.SchemeBuilder;
	import org.projectsnooze.utils.SnoozeLog;

	public class DependencyTreeCreatorImplTest extends TestCase
	{
		private var _treeCreator : DependencyTreeCreatorImpl;
		private static var logger : ILogger
		
		public function DependencyTreeCreatorImplTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGetSaveTree" ) );
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
			
			_treeCreator = new DependencyTreeCreatorImpl();
			_treeCreator.setEntityDataMapProvider( builder.getEntityDataMapProvider() );
			_treeCreator.setTypeUtils( builder.getTypeUtils() );
			
   		}
   		
   		override public function tearDown():void
   		{
   			_treeCreator = null;
   		}
   		
   		public function testGetSaveTree () : void
   		{
   			var school : SchoolClass = new SchoolClass();
   			
   			var child : Child = new Child();
   			child.setHeight( 55 );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "mummy" );
   			
   			var concern : Concern = new Concern();
   			
   			mother.addConcern( concern );
   			child.setMother( mother );
   			school.addChild( child );
   			
   			var list : Array = _treeCreator.getSaveDependencyTree( school )
   			 
   			logger = SnoozeLog.getLogger( this );
   			logger.debug( "the dependency tree contains {0} node(s) , there should be 4" , list.length ); 
   			
   			assertTrue( "has length of 4" , list.length == 4 );
   			
   		}
	}
}