package org.projectsnooze.impl.scheme
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.associations.ManyToOneBelongs;
	import org.projectsnooze.impl.associations.ManyToOneOwns;
	import org.projectsnooze.impl.associations.OneToManyBelongs;
	import org.projectsnooze.impl.associations.OneToManyOwns;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMap;
	
	import some.other.domain.Club;
	import some.other.domain.Player;
	import some.other.domain.Tournament;

	public class SchemeBuilderImplTest extends TestCase
	{
		private var _builder : SchemeBuilderImpl;
		private static var logger : ILogger = Log.getLogger( "SchemeBuilderImplTest" );
		
		public function SchemeBuilderImplTest(methodName:String=null)
		{
			super(methodName);
			
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new SchemeBuilderImplTest( "testMotherAdded" ) );
   			ts.addTest( new SchemeBuilderImplTest( "testMotheresRelationships" ) );
     		ts.addTest( new SchemeBuilderImplTest( "testConcernRelationships" ) );
     		ts.addTest( new SchemeBuilderImplTest( "testSchoolClassRelationships" ) );
     		ts.addTest( new SchemeBuilderImplTest( "testChildRelationships" ) );
     		ts.addTest( new SchemeBuilderImplTest( "testMotherChildRelationships" ) );
     		ts.addTest( new SchemeBuilderImplTest( "testClubDomainClub" ) );
			ts.addTest( new SchemeBuilderImplTest( "testClubDomainPlayer" ) );
			ts.addTest( new SchemeBuilderImplTest( "testClubDomainTournament" ) );
     		
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_builder = new SchemeBuilderImpl()
   			_builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			_builder.setTypeUtils( new TypeUtilsImpl () );
			_builder.setTypeFactory( new TypeFactoryImpl () );
			_builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
   		}
   		
   		override public function tearDown():void
   		{
   			_builder = null;
   		}
		
		public function testMotherAdded () : void
		{
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			assertNotNull( "Dont be null!" , 
				_builder.getEntityDataMapProvider().getEntityDataMapByClassName( "domain::Mother" ) );
		}
		
		public function testMotheresRelationships () : void
		{
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
			var motherMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Mother () );
			
			for ( var iterator : Iterator = motherMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				assertTrue( "Has concern" , relationship.getEntityDataMap().getTableName() == "Concern" );
				assertTrue( "Mother is owner" , relationship.getType().getName() == OneToManyOwns.Name ); 
			}
		}
		
		public function testConcernRelationships () : void
		{
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
			var concernMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Concern() );
			
			for ( var iterator : Iterator = concernMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				assertTrue( "Has mother" , relationship.getEntityDataMap().getTableName() == "Mother" );
				assertTrue( "Concern belongs" , relationship.getType().getName() == OneToManyBelongs.Name ); 
			}
		}
		
		public function testSchoolClassRelationships () : void
		{
			_builder.addEntityClass( SchoolClass );
			_builder.addEntityClass( Child );
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
			var schoolMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new SchoolClass() );
			
			for ( var iterator : Iterator = schoolMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				assertTrue( "Has children" , relationship.getEntityDataMap().getTableName() == "Child" );
				assertTrue( "Owns Child" , relationship.getType().getName() == OneToManyOwns.Name ); 
			}
		}
		
		public function testChildRelationships () : void
		{
			_builder.addEntityClass( SchoolClass );
			_builder.addEntityClass( Child );
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
			var childMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Child() );
			
			for ( var iterator : Iterator = childMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				
				if ( relationship.getType().getName() == ManyToOneOwns.Name )
				{
					assertTrue( "Has mother" , relationship.getEntityDataMap().getTableName() == "Mother" );
				} 
			}
		}
		
		public function testMotherChildRelationships () : void
		{
			_builder.addEntityClass( SchoolClass );
			_builder.addEntityClass( Child );
			_builder.addEntityClass( Mother );
			_builder.addEntityClass( Concern );
			_builder.generateEntityDataMaps();
			
			var motherMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Mother() );
			
			for ( var iterator : Iterator = motherMap.getRelationshipIterator() ; iterator.hasNext() ; )
			{
				var relationship : Relationship = iterator.next() as Relationship;
				
				if ( relationship.getType().getName() == ManyToOneBelongs.Name )
				{
					assertTrue( "Has child" , 
						relationship.getEntityDataMap().getTableName() == "Child" );
				} 
			}
		}
		
		public function testClubDomainClub () : void
		{
			_builder.addEntityClass( Club );
			_builder.addEntityClass( Player );
			_builder.addEntityClass( Tournament );
			_builder.generateEntityDataMaps();
			
			var clubMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Club() );
			
			var count : int = 0;
			
			for ( var i : Iterator = clubMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship : Relationship = i.next() as Relationship;
				count ++;
				
				switch ( relationship.getPropertyName() )
				{
					case "Players" :
					
						assertTrue( "type is OneToMany " , 
							relationship.getType().getName() == "OneToManyOwns" )
						
						break;
						
					case "Tournaments" :
					
						assertTrue( "type is ManyToMany " , 
							relationship.getType().getName() == "ManyToMany" )
						
						break;
				}
			}
			assertTrue( "there where two relationships " , count == 2 );
		}
		
		public function testClubDomainPlayer () : void
		{
			_builder.addEntityClass( Club );
			_builder.addEntityClass( Player );
			_builder.addEntityClass( Tournament );
			_builder.generateEntityDataMaps();
			
			var playerMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Player() );
			
			var count : int = 0;
			
			for ( var i : Iterator = playerMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship : Relationship = i.next() as Relationship;
				
				count ++;
				switch ( relationship.getPropertyName() )
				{
					case "Players" :
						
						assertTrue( "has a OneToManyBelongs " , 
							relationship.getType().getName() == "OneToManyBelongs" );
						
						break;
				}
			}
			
			assertTrue( "just one relationship" , count == 1 );
			
		}
		
		public function testClubDomainTournament():void
		{
			_builder.addEntityClass( Club );
			_builder.addEntityClass( Player );
			_builder.addEntityClass( Tournament );
			_builder.generateEntityDataMaps();
			
			var tournamentMap : EntityDataMap = 
				_builder.getEntityDataMapProvider().getEntityDataMap( new Player() );
			
			var count : int = 0;
			
			for ( var i : Iterator = tournamentMap.getRelationshipIterator() ; i.hasNext() ; )
			{
				var relationship : Relationship = i.next() as Relationship;
				
				count ++;
				switch ( relationship.getPropertyName() )
				{
					case "Clubs" :
						
						assertTrue( "has a ManyToMany with cubs " , 
							relationship.getType().getName() == "ManyToMany" );
						
						break;
				}
			}
			
			assertTrue( "just one relationship" , count == 1 );
		}
	}
}









