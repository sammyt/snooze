package org.projectsnooze.impl
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;
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
			ts.addTest( new EntityFacadeTest( "testGetSession" ) );
			ts.addTest( new EntityFacadeTest( "testBuildDataMap" ) );
			ts.addTest( new EntityFacadeTest( "testArray" ) );
			
			return ts;
		}
		
		override public function setUp():void
		{
			facade = new EntityFacadeImpl();
		}
		
		override public function tearDown():void
		{
			facade = null;
		}
		
		public function testArray () : void
		{
			var person : Mother = new Mother();
			
			var list1 : Array = new Array();
			var list2 : Array = new Array();
			
			list1.push( person );
			list2.push( person );
			list2.push( person );
			list2.push( person );
			list2.push( person );
			
			for ( var i : Iterator = new ArrayIterator( list1 ) ; i.hasNext() ; )
			{
				assertNotNull( i.next() ); 
			}
			for ( var j : Iterator = new ArrayIterator( list2 ) ; j.hasNext() ; )
			{
				assertNotNull( j.next() ); 
			}
			
		}
		
		public function testGetSession () : void
		{
			var session : Session = facade.getSession();
			assertNotNull( "session returned" , session );
		}
		
		public function testBuildDataMap () : void
		{
			facade.addEntityClass( SchoolClass )
			facade.addEntityClass( Child )
			facade.addEntityClass( Mother )
			facade.addEntityClass( Concern )
			facade.setCreateDDL( true );
			
			var school : SchoolClass = new SchoolClass();
			school.setName( "Big School Place" );
   			
   			var child : Child = new Child();
   			child.setHeight( 55 );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "mummy" );
   			
   			var concern : Concern = new Concern();
   			concern.setConcern( "to fat" );
   			
   			mother.addConcern( concern );
   			child.setMother( mother );
   			school.addChild( child );
   			
   			facade.getSession().save( school );
		}
		
	}
}