
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

	public class AbstractLinkType implements LinkType
	{
		protected var _name:String;
		protected var _foreignKeyContainer:Boolean;
		
		public function AbstractLinkType( name:String , foreignKeyContainer:Boolean )
		{
			_name = name;
			_foreignKeyContainer = foreignKeyContainer;
		}

		public function getName():String
		{
			return _name;
		}
		
		public function setName(name:String):void
		{
			_name = name;
		}
		
		public function getForeignKeyContainer ():Boolean
		{
			return _foreignKeyContainer;
		}
		
		public function setForeignKeyContainer ( foreignKeyContainer:Boolean ):void
		{
			_foreignKeyContainer = foreignKeyContainer;
		}
	}
}