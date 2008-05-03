package org.projectsnooze.impl.datatypes
{
	import org.projectsnooze.datatype.AbstractType;

	public class StringType extends AbstractType
	{
		public function StringType ()
		{
			super ( "TEXT" , "String" );
		}
		
		override public function toString () : String
		{
			return "StringType";
		}
	}
}