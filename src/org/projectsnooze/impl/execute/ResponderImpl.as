package org.projectsnooze.impl.execute
{
	import org.projectsnooze.execute.Responder;

	public class ResponderImpl implements Responder
	{
		private var _result : Function;
		private var _fault : Function;
		private var _this : Object;
		
		public function ResponderImpl( result : Function , fault : Function , scope : Object )
		{
			_result = result;
			_fault = fault;
			_this = scope;
		}

		public function result(data:Object):void
		{
			_result.apply( _this , [ data ] );
		}
		
		public function fault(info:Object):void
		{
			_fault.apply( _this , [ info ] );
		}
		
	}
}