package org.projectsnooze.impl.associations
{
	public class ManyToMany extends AbstractLinkType
	{
		public static const Name : String = "ManyToMany";
		
		public function ManyToMany()
		{
			super(Name , false);
		}
		
	}
}