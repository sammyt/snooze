
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
 
package org.projectsnooze.impl.session
{
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.projectsnooze.dependency.DependencyNode;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.impl.patterns.SmartIterator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.session.Session;

	public class SessionImpl implements Session
	{
		private static var logger : ILogger = Log.getLogger( "SessionImpl" );
		
		private var _dependencyTreeCreator : DependencyTreeCreator;
		
		public function SessionImpl()
		{
		}

		public function save(entity:Object):void
		{
			var depTree : Array = getDependencyTreeCreator().getSaveDependencyTree( entity );
			
			for( var iterator : Iterator = new SmartIterator( depTree ) ; iterator.hasNext() ; )
			{
				var depNode : DependencyNode = iterator.next() as DependencyNode;
				if ( ! depNode.isDependent() ) depNode.execute();
			}
			
		}
		
		public function retrieve(entity:Object):void
		{
		}
		
		public function getDependencyTreeCreator (  ) : DependencyTreeCreator
		{
			return _dependencyTreeCreator;
		}
		
		public function setDependencyTreeCreator ( dependencyTreeCreator : DependencyTreeCreator ) : void
		{
			_dependencyTreeCreator = dependencyTreeCreator;
		}
		
		
		
	}
}