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
	import org.projectsnooze.impl.execute.QueueManagerImpl;
	import org.projectsnooze.impl.generator.StatementCreaterImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	
	import some.other.domain.Club;
	import some.other.domain.Player;
	import some.other.domain.Tournament;

	public class DependencyTreeCreatorImplTest extends TestCase
	{
		private static var logger : ILogger = Log.getLogger( "DependencyTreeCreatorImplTest" );
		
		private var _treeCreator : DependencyTreeCreatorImpl;
		private var builder : SchemeBuilderImpl;
		
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
   			ts.addTest( new DependencyTreeCreatorImplTest( "testGetSaveTree4" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			builder = new SchemeBuilderImpl()
   			builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			builder.setTypeUtils( new TypeUtilsImpl () );
			builder.setTypeFactory( new TypeFactoryImpl () );
			builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
			
			_treeCreator = new DependencyTreeCreatorImpl();
			_treeCreator.setEntityDataMapProvider( builder.getEntityDataMapProvider() );
			_treeCreator.setStatementCreator( new StatementCreaterImpl() );
			_treeCreator.setTypeUtils( builder.getTypeUtils() );
			_treeCreator.setQueueManager( new QueueManagerImpl () );
			
   		}
   		
   		override public function tearDown():void
   		{
   			_treeCreator = null;
   		}
   		
   		public function testGetSaveTree1 () : void
   		{
   			
			builder.addEntityClass( SchoolClass );
			builder.addEntityClass( Child );
			builder.addEntityClass( Mother );
			builder.addEntityClass( Concern );
			builder.generateEntityDataMaps();
			
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
   			 
   			//logger.debug( "the dependency tree contains {0} node(s) , there should be 4" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 4" , depTree.getNodeCount() == 4 );
   			
   		}
   		
   		public function testGetSaveTree2 () : void
   		{
   			
			builder.addEntityClass( SchoolClass );
			builder.addEntityClass( Child );
			builder.addEntityClass( Mother );
			builder.addEntityClass( Concern );
			builder.generateEntityDataMaps();
			
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
   			//logger.debug( "the dependency tree contains {0} node(s) , there should be 5" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 5" , depTree.getNodeCount() == 5 );
   			
   		}
   		
   		public function testGetSaveTree3 () : void
   		{
   			
			builder.addEntityClass( SchoolClass );
			builder.addEntityClass( Child );
			builder.addEntityClass( Mother );
			builder.addEntityClass( Concern );
			builder.generateEntityDataMaps();
			
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
   			//logger.debug( "the dependency tree contains {0} node(s) , there should be 103" , depTree.getNodeCount() ); 
   			
   			assertTrue( "has length of 5" , depTree.getNodeCount() == 103 );
   			
   		}
   		
   		public function testGetSaveTree4 () : void
   		{
   			
			builder.addEntityClass( Player );
			builder.addEntityClass( Tournament );
			builder.addEntityClass( Club );
			builder.generateEntityDataMaps();
			
			var players : Array = [];
			for ( var i : int = 0 ; i < 2 ; i++ )
			{
				var p : Player = new Player ();
				p.setFirstName( "Joe" );
				p.setLastName( "Bloggs" );
				players.push( p );
			}
			
			var club1 : Club = new Club();
			club1.setName( "North" );
			club1.setPlayers( players );
			club1.setTournaments( [] );
						
			var depTree : DependencyTree = _treeCreator.getSaveDependencyTree( club1 )
			
			logger.debug( "what size is it currently? {0} " , depTree.getNodeCount() );
			
			assertTrue( "not finshed" , false );
			
   		}
	}
}