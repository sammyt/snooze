package org.projectsnooze.impl.datatypes
{
	import org.projectsnooze.datatype.AbstractType;

	public class BooleanType extends AbstractType
	{
		public function BooleanType()
		{
			super( "BOOLEAN" , "Boolean" );
		}
		
		override public function toString():String
		{
			return "BooleanType";
		}
	}
}