package org.projectsnooze.impl.scheme
{
	import domain.Concern;
	
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.scheme.EntityDataMap;

	public class EntityDataMapproviderImplTest extends TestCase
	{
		private var _dataMapProvider : EntityDataMapProviderImpl;
		
		public function EntityDataMapproviderImplTest(param:String=null)
		{
			super(param);
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new EntityDataMapproviderImplTest( "testGetByName" ) );
   			ts.addTest( new EntityDataMapproviderImplTest( "testGetByEntity" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_dataMapProvider = new EntityDataMapProviderImpl();
   		}
   		
   		override public function tearDown():void
   		{
   			_dataMapProvider = null;
   		}
   		
   		public function testGetByName () : void
   		{
   			var concern : Concern = new Concern();
   			var map : EntityDataMap = new EntityMapDataImp();
   			
   			_dataMapProvider.setEntityDataMap( describeType( concern ).@name , map );
   			
   			assertNotNull( "Should get map back " ,
				_dataMapProvider.getEntityDataMapByClassName( 
					describeType( concern ).@name ) );
   			
   		}
   		
   		public function testGetByEntity () : void
   		{
   			var concern : Concern = new Concern();
   			var map : EntityDataMap = new EntityMapDataImp();
   			
   			_dataMapProvider.setEntityDataMap( describeType( concern ).@name , map );
   			
   			assertNotNull( "Should get map back " ,
				_dataMapProvider.getEntityDataMap( concern ) );
   			
   		}
		
	}
}