
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
	import org.projectsnooze.associations.LinkTypeFactory;
	import org.projectsnooze.constants.MetaData;

	public class LinkTypeFactoryImpl implements LinkTypeFactory
	{
		public function LinkTypeFactoryImpl()
		{
		}

		public function getLinkType ( name:String , owner:Boolean = true ):LinkType
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