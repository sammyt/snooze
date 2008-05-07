package org.projectsnooze.impl.session
{
	import domain.Child;
	import domain.Concern;
	import domain.Mother;
	import domain.SchoolClass;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.impl.associations.LinkTypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeFactoryImpl;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.dependency.DependencyTreeCreatorImpl;
	import org.projectsnooze.impl.generator.StatementCreaterImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapProviderImpl;
	import org.projectsnooze.impl.scheme.SchemeBuilderImpl;
	import org.projectsnooze.scheme.SchemeBuilder;

	public class SessionImplTest extends TestCase
	{
		private var _session : SessionImpl;
		
		public function SessionImplTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			ts.addTest( new SessionImplTest( "testCreateDependencyTree" ) );
   			return ts;
   		}
   		
   		override public function setUp():void
   		{
   			_session = new SessionImpl();
   			
   		}
   		
   		override public function tearDown():void
   		{
   			_session = null;
   		}
   		
   		public function testCreateDependencyTree () : void
   		{
   			var builder : SchemeBuilder;
			builder = new SchemeBuilderImpl()
   			builder.setEntityDataMapProvider( new EntityDataMapProviderImpl() );
   			builder.setTypeUtils( new TypeUtilsImpl () );
			builder.setTypeFactory( new TypeFactoryImpl () );
			builder.setLinkTypeFactory( new LinkTypeFactoryImpl () );
			
			builder.addEntityClass( SchoolClass );
			builder.addEntityClass( Child );
			builder.addEntityClass( Mother );
			builder.addEntityClass( Concern );
			builder.generateEntityDataMaps();
			
			var depCreator : DependencyTreeCreator = new DependencyTreeCreatorImpl();
			depCreator.setEntityDataMapProvider( builder.getEntityDataMapProvider() );
			depCreator.setTypeUtils( builder.getTypeUtils() );
			
			_session.setDependencyTreeCreator( depCreator );
			_session.setStatementCreator( new StatementCreaterImpl() );
			
			var school : SchoolClass = new SchoolClass();
			school.setName( "Big School Place" );
   			
   			var child : Child = new Child();
   			child.setHeight( 55 );
   			
   			var mother : Mother = new Mother();
   			mother.setName( "mummy" );
   			
   			var concern : Concern = new Concern();
   			
   			mother.addConcern( concern );
   			child.setMother( mother );
   			school.addChild( child );
			
			_session.save( school );
   		}
		
	}
}