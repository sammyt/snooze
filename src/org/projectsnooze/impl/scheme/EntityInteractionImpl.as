package org.projectsnooze.impl.scheme 
{
	import org.projectsnooze.scheme.EntityInteraction;
	
	import uk.co.ziazoo.reflection.Accessor;
	import uk.co.ziazoo.reflection.Method;
	import uk.co.ziazoo.reflection.Variable;
	import uk.co.ziazoo.reflection.NameReference;
	
	public class EntityInteractionImpl implements EntityInteraction 
	{	
		public function EntityInteractionImpl()
		{
		}
		
		public function setValue( reflection:NameReference, value:Object , entity:Object ):void
		{
			if( reflection is Variable
			 	|| reflection is Accessor )
			{
				entity[ reflection.getName() ] = value;
			}
			else
			{
				var name:String = reflection.getName().substr( 
					3 , reflection.getName().length );
				
				var setter:Function = entity[ "set" + name ] as Function;
				setter.apply( entity, [value] );
			}
		}
   
		public function getValue( reflection:NameReference, entity:Object ):Object
		{
			if( reflection is Variable
			 	|| reflection is Accessor )
			{
				return entity[ reflection.getName() ];
			}
			else
			{
				var name:String = reflection.getName().substr( 
					3 , reflection.getName().length );
					
				var getter:Function = entity[ "get" + name ] as Function;
				return getter.apply( entity );
			}
		}
	}
}

