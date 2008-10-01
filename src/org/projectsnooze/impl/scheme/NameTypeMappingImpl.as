
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
	
	import uk.co.ziazoo.reflection.NameReference;
	import uk.co.ziazoo.reflection.Accessor;
	import uk.co.ziazoo.reflection.Variable;
	
	public class NameTypeMappingImpl implements NameTypeMapping 
	{
		private var _type:Type;
		private var _value:Object;
		private var _isPrimaryKey:Boolean = false;
		private var _reflection:NameReference;
		
		public function NameTypeMappingImpl ()
		{
		}
		
		public function isPrimaryKey ():Boolean
		{
			return _isPrimaryKey;
		}
		
		public function setIsPrimaryKey ( value:Boolean ):void
		{
			_isPrimaryKey = value;
		}
		
		public function getIsPrimaryKey ():Boolean
		{
			return _isPrimaryKey;
		}
		
		public function getName ():String
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
			trace("NameTypeMappingImpl::setReflection()", 
				reflection.getName(), getName() );
		}
		
		public function setType ( type:Type ):void
		{
			_type = type;
		}
		
		public function getType ():Type
		{
			return _type;
		}
		
		public function getValue ():Object
		{
			return _value;
		}
		
		public function setValue ( value:Object ):void
		{
			_value = value;
		}
		
		public function getLowerCaseName ():String
		{
			return getName().toLowerCase();
		}
		
	}

}