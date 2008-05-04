package org.projectsnooze.impl.scheme
{
	import domain.Mother;
	
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;

	public class TypeUtilsImplTest extends TestCase
	{
		private var _typeUtils : TypeUtilsImpl;
		
		public function TypeUtilsImplTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new TypeUtilsImplTest( "testGetTypeWithinCollection" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_typeUtils = new TypeUtilsImpl();
   		}
   		
   		override public function tearDown():void
   		{
   			_typeUtils = null;
   		}
   		
   		public function testGetTypeWithinCollection () : void
   		{
   			var mother : Mother = new Mother();
   			
   			var reflection : XML = describeType( mother );
   			
   			for each ( var method : XML in reflection.method )
   			{
   				if ( method.@name == "getConcerns" )
   				{
   					var type : String = _typeUtils.getTypeFromMetadata( method );
   					
   					assertTrue( "get concert out" , type == "domain::Concern" );
   				}
   			}
   		}
		
	}
}