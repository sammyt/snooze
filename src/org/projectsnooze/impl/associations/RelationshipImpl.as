
/* 
 * The MIT License
 * 
 * Copyright (c) 2008 Samuel Williams
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package org.projectsnooze.impl.associations
{
	import org.projectsnooze.associations.LinkType;
	import org.projectsnooze.associations.Relationship;
	import org.projectsnooze.scheme.EntityDataMap;
	
	import uk.co.ziazoo.reflection.NameReference;
	import uk.co.ziazoo.reflection.Accessor;
	import uk.co.ziazoo.reflection.Variable;

	/**
	*	@inheritDoc
	*/	
	public class RelationshipImpl implements Relationship
	{
		/**
		*	@private
		*	
		*	what type of relationship is it
		*/
		protected var _type:LinkType;
		
		/**
		*	@private
		*	
		*	the entity data map of the entity who
		*	relationship this describes
		*/
		protected var _dataMap:EntityDataMap;
		
		/**
		*	@private
		*	
		*	is this entity the one which contains the other
		*	ie. entity.setOtherEntity( otherEntity );
		*/	
		protected var _isEntityContainer:Boolean;
		
		/**
		*	@private
		*	
		*	if a join table i needed its name is stored here
		*/	
		protected var _joinTableName:String;
		
		/**
		*	@private
		*	
		*	the reflection of the property
		*/	
		protected var _reflection:NameReference;
		
		public function RelationshipImpl()
		{
		}
		
		/**
		*	@inheritDoc	
		*/
		public function setType(type:LinkType):void
		{
			_type = type;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function getType():LinkType
		{
			return _type;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function setEntityDataMap(dataMap:EntityDataMap):void
		{
			_dataMap = dataMap;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function getEntityDataMap():EntityDataMap
		{
			return _dataMap;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function getPropertyName ():String
		{
			if( _reflection is Variable
			 	|| _reflection is Accessor )
			{
				return _reflection.getName();
			}
			
			var name:String = _reflection.getName();
			return name.substr( 3 , name.length );
		}
		
		public function getReflection():NameReference
		{
			return _reflection;
		}
      
		public function setReflection( reflection:NameReference ):void
		{
			_reflection = reflection;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function setIsEntityContainer ( isEntityContainer:Boolean ):void
		{
			_isEntityContainer = isEntityContainer;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function getIsEntityContainer ():Boolean
		{
			return _isEntityContainer;
		}
		
		/**
		*	@inheritDoc	
		*/	
		public function getJoinTableName ():String
		{
			return _joinTableName;
		}
		
		/**
		*	@inheritDoc	
		*/	
		public function setJoinTableName ( joinTableName:String ):void
		{
			_joinTableName = joinTableName;
		}
	}
}