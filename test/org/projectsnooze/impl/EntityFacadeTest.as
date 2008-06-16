package org.projectsnooze.impl
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import some.other.domain.*;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.events.DynamicEvent;
	
	import org.projectsnooze.impl.execute.ResponderImpl;
	import org.projectsnooze.session.Session;

	public class EntityFacadeTest extends TestCase
	{
		private var facade : EntityFacadeImpl;
		
		public function EntityFacadeTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite () : TestSuite
		{
			var ts : TestSuite = new TestSuite();
			//ts.addTest( new EntityFacadeTest( "testGetSession" ) );
			//ts.addTest( new EntityFacadeTest( "testCreateDB" ) );
			//ts.addTest( new EntityFacadeTest( "testDropDB" ) );
			//ts.addTest( new EntityFacadeTest( "testBuildDataMap" ) );
			ts.addTest( new EntityFacadeTest( "testBuildDataMap1" ) );
			
			return ts;
		}
		
		override public function setUp():void
		{
			facade = new EntityFacadeImpl();
		}
		
		override public function tearDown():void
		{
			facade.dropDatabase()
			facade = null;
		}
		
		public function myAddAsync(f:Function):Function 
		{
			var f1:Function = function(e:DynamicEvent):void 
			{ 
				f.call(this,e.result);
			}

			var f2:Function = addAsync(f1, 5000);

			var f3:Function = function(a:*):void 
			{
				var e:DynamicEvent = new DynamicEvent("MyDynamicEvent");
				e.result = a;
				f2.call(this, e);
			}
			return f3;
		}
		
		public function testGetSession () : void
		{
			var session : Session = facade.getSession();
			assertNotNull( "session returned" , session );
		}
		
		public function testCreateDB () : void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.createDatabase();
		}
		
		public function testDropDB () : void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.createDatabase();
			
			facade.dropDatabase();
		}
		
		public function testBuildDataMap () : void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.createDatabase();
			
			var school : SchoolClass = new SchoolClass();
			school.setName( "My School" );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "Sarah" );
   			
   			var concern : Concern = new Concern();
   			concern.setConcern( "OMG" );
   			
   			var concern2 : Concern = new Concern();
   			concern2.setConcern( "cheese" );
   			
   			mother.addConcern( concern );
   			mother.addConcern( concern2 );
   			
   			for ( var i : int = 0 ; i < 4 ; i ++  )
   			{
	   			var child : Child = new Child();
	   			child.setHeight( i );
	   			child.setMother( mother );
	   			school.addChild( child );
   			}
   			
   			facade.getSession().save( school );
		}
		
		
		public function testBuildDataMap1 () : void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.createDatabase();
			
			var school : SchoolClass = new SchoolClass();
			school.setName( "Big School Place" );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "jane" );
   			
   			var concern : Concern = new Concern();
   			concern.setConcern( "blah blah" );
   			
   			var concern2 : Concern = new Concern();
   			concern2.setConcern( "blah2 blah2" );
   			
   			mother.addConcern( concern );
   			mother.addConcern( concern2 );
   			
   			for ( var i : int = 0 ; i < 100 ; i ++  )
   			{
	   			var child : Child = new Child();
	   			child.setHeight( i );
	   			child.setMother( mother );
	   			school.addChild( child );
   			}
   			
   			function fault ( info : Object ) : void {}
   			function result ( data : Object ) : void
   			{
   				var s : SchoolClass = data as SchoolClass;
   				
   				assertTrue( "is a schoolclass " , s is SchoolClass );
   				assertTrue( "is the id 1 " , s.getId() >= 0 );
   				
   				var connection : SQLConnection = facade.getConnectionPool().getConnection();
   				connection.open( facade.getConnectionPool().getFile() );
   				
   				var select1 : SQLStatement = new SQLStatement();
   				select1.sqlConnection = connection;
   				
   				select1.text = "select count ( * ) as kids from Child";
   				select1.execute();
   				
   				var result : Array = select1.getResult().data;
   				
   				assertTrue( "100 kids" , result[0]["kids"] == 100 );
   			}
   			
   			facade.getSession().save( school , new ResponderImpl ( myAddAsync ( result ) , fault , this ) );
		}
		
		public function testBuildDataMap1 () : void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.createDatabase();
			
			var connection : SQLConnection = facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			
		}
		
	}
}