
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

	/**
	*	@inheritDoc
	*/	
	public class RelationshipImpl implements Relationship
	{
		// what type of relationship is it
		private var _type:LinkType;
		
		// the entity data map of the entity who
		// relationship this describes
		private var _dataMap:EntityDataMap;
		
		// the name of the property getter and setter
		private var _propertyName:String;
		
		// is this entity the one which contains the other
		// ie. entity.setOtherEntity( otherEntity );
		private var _isEntityContainer:Boolean;
		
		// if a join table i needed its name is stored here
		private var _joinTableName:String;
		
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
		public function setPropertyName ( propertyName:String ):void
		{
			_propertyName = propertyName;
		}
		
		/**
		*	@inheritDoc	
		*/
		public function getPropertyName ():String
		{
			return _propertyName;
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