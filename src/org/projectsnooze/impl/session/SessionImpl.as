package org.projectsnooze.impl.session
{
	import org.projectsnooze.datatype.TypeUtils;
	import org.projectsnooze.dependency.DependencyTreeCreator;
	import org.projectsnooze.patterns.Iterator;
	import org.projectsnooze.scheme.EntityDataMapProvider;
	import org.projectsnooze.session.Session;

	public class SessionImpl implements Session
	{
		private var _entityDataMapProvider : EntityDataMapProvider;
		private var _typeUtils : TypeUtils;
		private var _dependencyTreeCreator : DependencyTreeCreator;
		
		public function SessionImpl()
		{
		}

		public function save(entity:Object):Object
		{
			//var depTree : Array = getDependencyTreeCreator().getSaveDependencyTree( entity );
			
			return null;
		}
		
		private function createDependencyTree () : void
		{
			
		}
		
		public function retrieve(entity:Object):Object
		{
			return null;
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