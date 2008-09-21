package  
{
	import flexunit.framework.TestSuite;
	import org.projectsnooze.impl.dependency.DependencyTreeCreatorImplTest;
	import org.projectsnooze.impl.generator.DDLGeneratorImplTest;
	import org.projectsnooze.impl.datatypes.TypeUtilsImpl;
	import org.projectsnooze.impl.scheme.EntityDataMapproviderImplTest;
	import org.projectsnooze.impl.scheme.SchemeBuilderImplTest;
	import org.projectsnooze.impl.scheme.TypeUtilsImplTest;
	import org.projectsnooze.impl.EntityFacadeTest;
	import org.projectsnooze.impl.ArrayIteratorTest;
	import org.projectsnooze.impl.StatementCreatorImplTest;
	
	public class Tester extends TestSuite
	{
		public function Tester()
		{
			super();
			//addTest( SchemeBuilderImplTest.suite() );
			//addTest( EntityDataMapproviderImplTest.suite() );	
			//addTest( TypeUtilsImplTest.suite() );
			//addTest( DDLGeneratorImplTest.suite() );
			//addTest( DependencyTreeCreatorImplTest.suite() );
			//addTest( StatementCreatorImplTest.suite() );
			//addTest( ArrayIteratorTest.suite() );
			addTest( EntityFacadeTest.suite() );
		}
	}
}

