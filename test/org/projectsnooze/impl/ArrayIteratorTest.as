package org.projectsnooze.impl
{
	import domain.Mother;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.impl.patterns.ArrayIterator;
	import org.projectsnooze.patterns.Iterator;

	public class ArrayIteratorTest extends TestCase
	{
		public function ArrayIteratorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite ():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			ts.addTest( new ArrayIteratorTest ( "testIterator" ) );
			ts.addTest( new ArrayIteratorTest ( "testIterator2" ) );
			ts.addTest( new ArrayIteratorTest ( "testIterator3" ) );
			return ts;
		}
		
		override public function setUp():void
		{
			
		}
		
		override public function tearDown():void
		{
			
		}
		
		public function testIterator ():void
		{
			var m1:Mother = new Mother();
			m1.setName( "m1" );
			
			var m2:Mother = new Mother();
			m2.setName( "m2" );
			
			var m3:Mother = new Mother();
			m3.setName( "m3" );
			
			var list:Array = [ m1 , m2 , m3 ];
			
			var count:int = 0;
			for ( var iterator:Iterator = new ArrayIterator ( list ) ; iterator.hasNext() ; )
			{
				assertTrue( "is mother" , iterator.next() is Mother );
				count ++;
			}
			assertTrue( "three mothers" , count == 3 );
		}
		
		public function testIterator2 ():void
		{
			var m1:Mother = new Mother();
			m1.setName( "m1" );
			
			var list:Array = [ m1 ];
			
			var count:int = 0;
			for ( var iterator:Iterator = new ArrayIterator ( list ) ; iterator.hasNext() ; )
			{
				assertTrue( "is mother" , iterator.next() is Mother );
				count ++;
			}
			assertTrue( "three mothers" , count == 1 );
		}
		
		public function testIterator3 ():void
		{
			var m1:Mother = new Mother();
			m1.setName( "m1" );
			
			var list:Array = [ ];
			
			var count:int = 0;
			for ( var iterator:Iterator = new ArrayIterator ( list ) ; iterator.hasNext() ; )
			{
				assertTrue( "is mother" , iterator.next() is Mother );
				count ++;
			}
			assertTrue( "three mothers" , count == 0 );
		}
	}
}