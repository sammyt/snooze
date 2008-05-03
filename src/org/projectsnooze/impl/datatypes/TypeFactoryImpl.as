package org.projectsnooze.impl.datatypes
{
	import org.projectsnooze.constants.ASTypes;
	import org.projectsnooze.datatype.Type;
	import org.projectsnooze.datatype.TypeFactory;

	public class TypeFactoryImpl implements TypeFactory
	{
		public function getType( asType:String ) : Type
		{			
			switch ( asType )
			{
				case ASTypes.STRING:
					return new StringType();
					break;
				case ASTypes.INT:
					return new IntegerType();
					break;
				case ASTypes.NUMBER:
					return new NumberType();
					break;
				case ASTypes.BOOLEAN:
					return new BooleanType();
					break;
				case ASTypes.DATE:
					return new DateType();
					break;
				case ASTypes.XML:
					return new XMLType();
					break;
				case ASTypes.XMLLIST:
					return new XMLListType();
					break;
			}
			return null;
		}
		
	}
}