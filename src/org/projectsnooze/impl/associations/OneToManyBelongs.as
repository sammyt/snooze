package org.projectsnooze.impl.associations
{
	public class OneToManyBelongs extends AbstractLinkType
	{
		public static const Name : String = "OneToManyBelongs";
		
		public function OneToManyBelongs()
		{
			super( Name , true );
		}
		
	}
}