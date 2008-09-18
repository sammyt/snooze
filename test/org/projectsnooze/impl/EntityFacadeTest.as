package org.projectsnooze.impl
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.events.DynamicEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.impl.execute.ResponderImpl;
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.session.Session;
	
	import some.other.domain.*;
	import org.projectsnooze.events.SessionEvent;

	public class EntityFacadeTest extends TestCase
	{
		private static var logger:ILogger = 
			Log.getLogger( "EntityFacadeTest" );
		
		private var facade:EntityFacadeImpl;
		
		public function EntityFacadeTest(methodName:String=null)
		{
			logger.info( "running test {0}" , methodName );
			super(methodName);
		}
		
		public static function suite ():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			//ts.addTest( new EntityFacadeTest( "testGetSession" ) );
			//ts.addTest( new EntityFacadeTest( "testCreateSchoolDB" ) );
			//ts.addTest( new EntityFacadeTest( "testDropSchoolDB" ) );
			//ts.addTest( new EntityFacadeTest( "testInsertSchool" ) );
			//ts.addTest( new EntityFacadeTest( "testCreateFootballDB" ) );
			//ts.addTest( new EntityFacadeTest( "testClubTable" ) );
			//ts.addTest( new EntityFacadeTest( "testPlayerTable" ) );
			//ts.addTest( new EntityFacadeTest( "testTournamentTable" ) );
			//ts.addTest( new EntityFacadeTest( "testClubTournamentTable" ) );
			//ts.addTest( new EntityFacadeTest( "testInsertionWithFootballDomain" ) );
			
			return ts;
		}
		
		override public function setUp():void
		{
			facade = new EntityFacadeImpl();
		}
		
		override public function tearDown():void
		{
			//facade.getSession().dropDatabase()
			facade = null;
		}
		
		public function smartAddAsync(f:Function):Function 
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
		
		public function testGetSession ():void
		{
			var session:Session = facade.getSession();
			assertNotNull( "session returned" , session );
		}
		
		public function testCreateSchoolDB ():void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.dispatcher.addEventListener( SessionEvent.DATABASE_CREATED , onCreated );
			facade.getSession().createDatabase();
			
			//var connection:SQLConnection = 
			//	facade.getConnectionPool().getConnection();
			
			//connection.loadSchema();
			
			//assertTrue( "has all the tables it should " , 
			//	connection.getSchemaResult().tables , 
			//	[ "SchoolClass" , "Child" , "Mother" , "Concern" ]); 
				
		}
		
		private function onCreated( event:SessionEvent ):void
		{
			trace( "EntityFacadeTest::onCreated" , event );
		}
		
		public function testDropSchoolDB ():void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.getSession().createDatabase();
			
			facade.getSession().dropDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema();
			
			assertTrue( "has all the tables it should " , 
				connection.getSchemaResult().tables , 
				[  ]); 
		}
		
		public function testInsertSchool ():void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.getSession().createDatabase();
			
			var school:SchoolClass = new SchoolClass();
			school.setName( "Big School Place" );
   			
   			var mother:Mother = new Mother();
   			mother.setName( "jane" );
   			
   			var concern:Concern = new Concern();
   			concern.setConcern( "blah blah" );
   			
   			var concern2:Concern = new Concern();
   			concern2.setConcern( "blah2 blah2" );
   			
   			mother.addConcern( concern );
   			mother.addConcern( concern2 );
   			
   			for ( var i:int = 0 ; i < 100 ; i ++  )
   			{
	   			var child:Child = new Child();
	   			child.setHeight( i );
	   			child.setMother( mother );
	   			school.addChild( child );
   			}
   			
   			function fault ( info:Object = null ):void
   			{
   				logger.debug( "testInsertSchool.fault {0}" , info );
   				assertFalse( true ); 
			}
   			function result ( data:Object ):void
   			{
   				logger.debug( "testInsertSchool.result {0}" , data ); 
   
   				var s:SchoolClass = data as SchoolClass;
   				
   				assertTrue( "is a schoolclass " , s is SchoolClass );
   				assertTrue( "is the id 1 " , s.getId() >= 0 );
   				
   				var connection:SQLConnection = 
   					facade.getConnectionPool().getConnection();
   				connection.open( facade.getConnectionPool().getFile() );
   				
   				var select1:SQLStatement = new SQLStatement();
   				select1.sqlConnection = connection;
   				
   				select1.text = "select count ( * ) as kids from Child";
   				select1.execute();
   				
   				var result:Array = select1.getResult().data;
   				
   				assertTrue( "100 kids" , result[0]["kids"] == 100 );
   			}
   			
   			facade.getSession().save( school );
   			//	ResponderImpl ( smartAddAsync ( result ) , fault , this ) );
		}
		
		public function testCreateFootballDB ():void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema();
			
			var tableNames:Array = new Array();
			for ( var i:Iterator = new ArrayIterator( 
				connection.getSchemaResult().tables ); i.hasNext() ; )
			{
				var t:SQLTableSchema = i.next() as SQLTableSchema;
				tableNames.push( t.name );
			}
			
			assertTrue( "has all the tables it should " , testListContents(
				tableNames , 
				[ "Club_Tournament" , "Club" , "Player" , "Tournament" ] ) ); 
		}
		
		public function testClubTable ():void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema( SQLTableSchema , "Club" );
			
			var club:SQLTableSchema =  
				connection.getSchemaResult().tables [0] as SQLTableSchema;
			
			for ( var i:Iterator = new ArrayIterator( club.columns ) ; 
				i.hasNext() ; )
			{
				var column:SQLColumnSchema = i.next() as SQLColumnSchema;
				switch ( column.name ) 
				{
					case "id" :
						assertTrue( "is primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertTrue( "does autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
						
					case "name" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is text" , column.dataType == "TEXT" );
						assertTrue( "does allow null" , column.allowNull );
						break;
				}
			}
		}
		
		public function testPlayerTable ():void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema( SQLTableSchema , "Player" );
			
			var player:SQLTableSchema =  
				connection.getSchemaResult().tables [0] as SQLTableSchema;
			
			for ( var i:Iterator = new ArrayIterator( player.columns ) ; 
				i.hasNext() ; )
			{
				var column:SQLColumnSchema = i.next() as SQLColumnSchema;
				
				switch ( column.name ) 
				{
					case "id" :
						assertTrue( "is primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertTrue( "does autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
						
					case "club_id" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertFalse( "does not autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
						
					case "firstname" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is text" , column.dataType == "TEXT" );
						assertTrue( "does allow null" , column.allowNull );
						break;
						
					case "lastname" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is text" , column.dataType == "TEXT" );
						assertTrue( "does allow null" , column.allowNull );
						break;
				}
			}
		}
		
		public function testTournamentTable ():void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema( SQLTableSchema , "Club" );
			
			var tournament:SQLTableSchema =  
				connection.getSchemaResult().tables [0] as SQLTableSchema;
			
			for ( var i:Iterator = new ArrayIterator( tournament.columns ) ; 
				i.hasNext() ; )
			{
				var column:SQLColumnSchema = i.next() as SQLColumnSchema;
				
				switch ( column.name ) 
				{ 
					case "id" :
						assertTrue( "is primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertTrue( "does autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
						
					case "name" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is text" , column.dataType == "TEXT" );
						assertTrue( "does allow null" , column.allowNull );
						break;
				}
			}
		}
		
		public function testClubTournamentTable ():void
		{
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var connection:SQLConnection = 
				facade.getConnectionPool().getConnection();
			connection.open( facade.getConnectionPool().getFile() );
			
			connection.loadSchema( SQLTableSchema , "Club_Tournament" );
			
			var tournament:SQLTableSchema =  
				connection.getSchemaResult().tables [0] as SQLTableSchema;
			
			for ( var i:Iterator = new ArrayIterator( tournament.columns ) ; 
				i.hasNext() ; )
			{
				var column:SQLColumnSchema = i.next() as SQLColumnSchema;
				
				switch ( column.name ) 
				{ 
					case "club_id" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertFalse( "does not autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
						
					case "tournament_id" :
						assertFalse( "is not primary key" , column.primaryKey );
						assertTrue( "is integer" , column.dataType == "INTEGER" );
						assertFalse( "does not autoincrement" , column.autoIncrement );
						assertFalse( "does not allow null" , column.allowNull );
						break;
				}
			}
		}
		
		public function testInsertionWithFootballDomain ():void
		{
			facade = new EntityFacadeImpl( true , false );
			facade.setDatabaseName( "football.db" );
			facade.init();
			
			facade.addEntityClass( Club );
			facade.addEntityClass( Player );
			facade.addEntityClass( Tournament );
			facade.getSession().createDatabase();
			
			var p1:Player = new Player()
			p1.setFirstName( "sam" );
			p1.setLastName( "williams" );
			
			var p2:Player = new Player()
			p2.setFirstName( "becky" );
			p2.setLastName( "howes" );
			
			var p3:Player = new Player()
			p3.setFirstName( "justin" );
			p3.setLastName( "clarke" );
			
			var club:Club = new Club();
			club.setName( "some peeps" );
			
			club.setPlayers( [ p1 , p2 , p3 ] );
			
			var prem:Tournament = new Tournament()
			prem.setName( "prem" );
			prem.setClubs( [ club ] );
			
			club.setTournaments( [ prem ] );
			
			//facade.getSession().save( club , new
			//  	ResponderImpl ( smartAddAsync ( result ) , fault , this ) );
			   	
			function result ( ...data ):void
			{
				logger.debug( "testInsertionWithFootballDomain.result {0}" , data );				
			}
			
			function fault ( ...args ):void
			{
				logger.debug( "testInsertionWithFootballDomain.fault {0}" , args );					
			}
		}
		
		
		private function testListContents ( 
			testList:Array , correctList:Array ):Boolean
		{
			var containsAll:Boolean = true;
			
			for ( var i:Iterator = new ArrayIterator ( correctList ) ;
				i.hasNext() ; )
			{
				var name:String = i.next() as String;
				if ( ! listContains( testList , name ) )
				{
					return false;
				}	
			}
			
			function listContains ( list:Array , item:String ):Boolean
			{
				for ( var i:Iterator = new ArrayIterator ( list ) ;
					i.hasNext() ; )
				{
					var name:String = i.next() as String;
					if ( name == item ) return true;
				}
				return false;
			}
			
			return true;
		}
	}
}


