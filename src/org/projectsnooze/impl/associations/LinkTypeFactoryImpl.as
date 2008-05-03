package org.projectsnooze.impl.associations
{
	import org.projectsnooze.associations.LinkType;
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.constants.MetaData;

	public class LinkTypeFactoryImpl implements LinkTypeFactory
	{
		public function LinkTypeFactoryImpl()
		{
		}

		public function getLinkType ( name : String , owner : Boolean = true ) : LinkType
		{
			switch ( name )
			{
				
				case MetaData.MANY_TO_MANY:
					return new ManyToMany();
					break;
					
				case MetaData.ONE_TO_MANY:
					if ( owner )
					{
						return new OneToManyOwns ();
					}
					else
					{
						return new OneToManyBelongs ();
					}
					break;
				case MetaData.MANY_TO_ONE:
					if ( owner )
					{
						return new ManyToOneOwns ();
					}
					else
					{
						return new ManyToOneBelongs ();
					}
			}
			return null;
		}
	}
}