package org.projectsnooze.impl.dependency
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
	import org.projectsnooze.scheme.SchemeBuilder;

	public class DependencyTreeCreatorImplTest extends TestCase
	{
		private var _treeCreator : DependencyTreeCreatorImpl;
		
		public function DependencyTreeCreatorImplTest(methodName:String=null)
		{
			super(methodName);
		}
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGettingTheEntities" ) );
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
   		
   		public function testGettingTheEntities () : void
   		{
   			
   			var school : SchoolClass = new SchoolClass();
   			
   			assertTrue( "just the one object" , _treeCreator.getAllContainedEntities( school ).length == 5 );
   		}
   		
   		
   		/* public function testDependencyMap () : void
   		{
			assertTrue( false );
	
   			var school : SchoolClass = new SchoolClass();
   			
   			var mother : Mother = new Mother();
   			mother.setName( "its all gone wrong" );
   			mother.setConcerns( [ new Concern() ] );
   			
   			var c1 : Child = new Child();
   			c1.setHeight( 3 );
   			c1.setMother( mother );
   			
   			school.addChild( c1 );
   			
   			var deps : Array = _treeCreator.getSaveDependencyTree( school );
   			
   			for ( var i : int = 0; i < deps.length ; i++ )
   			{
   				var dep : DependencyNode = deps[i] as DependencyNode;
   				trace ( dep.getEntityDataMap().getTableName() );
   			} 
   		} */
	}
}