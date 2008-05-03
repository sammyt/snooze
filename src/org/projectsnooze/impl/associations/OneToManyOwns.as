package org.projectsnooze.impl.associations
{
	public class OneToManyOwns extends AbstractLinkType
	{
		public static const Name : String = "OneToManyOwns";
		
		public function OneToManyOwns()
		{
			super( Name , false );
		}
	}
}