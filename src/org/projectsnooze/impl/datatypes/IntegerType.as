package org.projectsnooze.impl.datatypes
{
	import org.projectsnooze.datatype.AbstractType;

	public class IntegerType extends AbstractType
	{
		public function IntegerType ()
		{
			super( "INTEGER" , "int" );
		}

		override public function toString () : String
		{
			return "IntegerType";
		}
	}
}