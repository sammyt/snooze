package org.projectsnooze.impl.dependency
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.dependency.DependencyTree;
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.execute.StatementExecutionManagerFactoryImpl;
	import org.projectsnooze.impl.generator.StatementCreaterImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.scheme.SchemeBuilder;

	public class DependencyTreeCreatorImplTest extends TestCase
	{
		private static var logger : ILogger = Log.getLogger( "DependencyTreeCreatorImplTest" );
		
		private var _treeCreator : DependencyTreeCreatorImpl;
		
		public function DependencyTreeCreatorImplTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
			
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGetSaveTree1" ) );
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGetSaveTree2" ) );
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGetSaveTree3" ) );
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
			_treeCreator.setStatementCreator( new StatementCreaterImpl() );
			_treeCreator.setStatementExecutionManagerFactory( new StatementExecutionManagerFactoryImpl () );
			_treeCreator.setTypeUtils( builder.getTypeUtils() );
			
   		}
   		
   		override public function tearDown():void
   		{
   			_treeCreator = null;
   		}
   		
   		public function testGetSaveTree1 () : void
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
   			
   			var depTree : DependencyTree = _treeCreator.getSaveDependencyTree( school )
   			 
   			//logger = SnoozeLog.getLogger( this );
   			logger.debug( "the dependency tree contains {0} node(s) , there should be 4" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 4" , depTree.getNodeCount() == 4 );
   			
   		}
   		
   		public function testGetSaveTree2 () : void
   		{
   			var school : SchoolClass = new SchoolClass();
   			
   			var child : Child = new Child();
   			child.setHeight( 55 );
   			
   			var child2 : Child = new Child();
   			child2.setHeight( 56 );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "mummy" );
   			
   			var concern : Concern = new Concern();
   			
   			mother.addConcern( concern );
   			child.setMother( mother );
   			child2.setMother( mother );
   			
   			school.addChild( child );
   			school.addChild( child2 );
   			
   			var depTree : DependencyTree = _treeCreator.getSaveDependencyTree( school )
   			 
   			//logger = SnoozeLog.getLogger( this );
   			logger.debug( "the dependency tree contains {0} node(s) , there should be 5" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 5" , depTree.getNodeCount() == 5 );
   			
   		}
   		
   		public function testGetSaveTree3 () : void
   		{
   			var school : SchoolClass = new SchoolClass();
			school.setName( "Big School Place" );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "mummy" );
   			
   			var concern : Concern = new Concern();
   			concern.setConcern( "to fat" );
   			
   			mother.addConcern( concern );
   			
   			for ( var i : int = 0 ; i < 100 ; i ++  )
   			{
	   			var child : Child = new Child();
	   			child.setHeight( i );
	   			child.setMother( mother );
	   			school.addChild( child );
   			}
   			
   			var depTree : DependencyTree = _treeCreator.getSaveDependencyTree( school )
   				//logger = SnoozeLog.getLogger( this );
   			logger.debug( "the dependency tree contains {0} node(s) , there should be 103" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 5" , depTree.getNodeCount() == 103 );
   			
   		}
	}
}