package org.projectsnooze.impl.datatypes
{
	import org.projectsnooze.datatype.AbstractType;

	public class NumberType extends AbstractType
	{
		public function NumberType()
		{
			super( "NUMBER" , "Number");
		}
		
		override public function toString () : String
		{
			return "NumberType";
		}
		
	}
}