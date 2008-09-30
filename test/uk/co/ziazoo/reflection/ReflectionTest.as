package uk.co.ziazoo.reflection 
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import uk.co.ziazoo.Tree;
	import uk.co.ziazoo.reflection.ReflectionImpl;
	import uk.co.ziazoo.reflection.Reflection;
	import uk.co.ziazoo.reflection.Method;
	import uk.co.ziazoo.reflection.Accessor;
	
	import flash.utils.describeType;	
	
	public class ReflectionTest extends TestCase
	{
		private static const _logger:ILogger = Log.getLogger( "ReflectionTest" );
		
		public function ReflectionTest( method:String = null )
		{
			super( method );
		}
		
		public static function suite ():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			ts.addTest( new ReflectionTest( "testVariableReflection" ) );
			ts.addTest( new ReflectionTest( "testMethodReflection" ) );
			ts.addTest( new ReflectionTest( "testAccessorReflection" ) );
			ts.addTest( new ReflectionTest( "testNoFilterFilter" ) );
			ts.addTest( new ReflectionTest( "testMethodFilterFilter" ) );
			ts.addTest( new ReflectionTest( "testAccessorFilterFilter" ) );
			return ts;
		}
		
		public function testVariableReflection():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var vars:Array = reflection.getVariables();
			
			assertTrue( "should have two Variable's", vars.length == 2 );
			
			for each( var v:Variable in vars )
			{
				if ( v.getName() == "name" )
				{
					assertTrue( "name is a string", v.getType() == "String" );
				}
				if ( v.getName() == "id" )
				{
					assertTrue( "id is a int", v.getType() == "int" );
				}
				if( v.getName() != "name" && v.getName() != "id" )
				{
					assertFalse( "name not valid" , true );
				}
			}
		}
		
		public function testMethodReflection():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var methods:Array = reflection.getMethods();
			assertTrue( "length is 4" , methods.length == 2 )
		}
		
		public function testAccessorReflection():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var accessors:Array = reflection.getAccessors();
			assertTrue( "length is 4" , accessors.length == 2 )
		}
		
		public function testNoFilterFilter():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var all:Array = reflection.getPropertiesWithType();
			assertTrue( "length is 5" , all.length == 5 );
		}
		
		public function testMethodFilterFilter():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var all:Array = reflection.getPropertiesWithType( Method );
			assertTrue( "length is 1" , all.length == 1 );
		}
		
		public function testAccessorFilterFilter():void
		{
			var reflection:Reflection = new ReflectionImpl( new Tree() );
			var all:Array = reflection.getPropertiesWithType( Accessor );
			assertTrue( "length is 2" , all.length == 2 );
		}
	}
}

