
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
 
package org.projectsnooze.impl.scheme
{
	import org.projectsnooze.scheme.NameTypeMapping;
	import org.projectsnooze.datatype.Type;
	
	import uk.co.ziazoo.reflection.Accessor;
	import uk.co.ziazoo.reflection.Variable;
	import uk.co.ziazoo.reflection.NameAndTypeReference;
	
	public class NameTypeMappingImpl implements NameTypeMapping 
	{
		/**
		*	@private
		*/
		protected var _type:Type;
		
		/**
		*	@private
		*/
		protected var _isPrimaryKey:Boolean = false;
		
		/**
		*	@private
		*/
		protected var _getter:NameAndTypeReference;
		
		/**
		*	@private
		*/
		protected var _setter:NameAndTypeReference;
		
		/**
		*	@private
		*/
		protected var _columnName:String;	
		
		/**
		*	Creates instance of <code>NameTypeMappingImpl</code>
		*/	
		public function NameTypeMappingImpl ()
		{
		}
		
		/**
		*	@inheritDoc
		*/	
		public function isPrimaryKey ():Boolean
		{
			return _isPrimaryKey;
		}
		
		/**
		*	@inheritDoc
		*/
		public function setPrimaryKey ( value:Boolean ):void
		{
			_isPrimaryKey = value;
		}
		
		/**
		*	@inheritDoc
		*/
		public function setType ( type:Type ):void
		{
			_type = type;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getType ():Type
		{
			return _type;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getColumnName():String
		{
			if( _columnName )
			{
				return _columnName;
			}
			//TODO: return the derived name
			// ie, not from metadata
			return null
		}
		
		/**
		*	@inheritDoc
		*/	
		public function setColumnName( columnName:String ):void
		{
			_columnName = columnName;
		}
		
		/**
		*	@inheritDoc
		*/	
		public function getGetter():NameAndTypeReference
		{
			return _getter;
		}
		
		/**
		*	@inheritDoc
		*/	
		public function setGetter( getter:NameAndTypeReference ):void
		{
			_getter = getter;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getSetter():NameAndTypeReference
		{
			return _setter;
		}
		
		/**
		*	@inheritDoc
		*/
		public function setSetter( setter:NameAndTypeReference ):void
		{
			_setter = setter;
		}
		
		/**
		*	@inheritDoc
		*/
		public function getLowerCaseName ():String
		{
			return getColumnName().toLowerCase();
		}
	}
}