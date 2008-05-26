package org.projectsnooze.impl.execute
{
	import org.projectsnooze.execute.Responder;
	import org.projectsnooze.execute.StatementWrapper;
	import org.projectsnooze.generator.Statement;

	public class StatementWrapperImpl implements StatementWrapper
	{
		protected var _responder : Responder;
		protected var _statement : Statement;
		
		public function StatementWrapperImpl( statement : Statement , responder : Responder )
		{
			_responder = responder;
			_statement = statement;
		}

		public function setResponder(responder:Responder):void
		{
			_responder = responder;
		}
		
		public function getResponder():Responder
		{
			return _responder;
		}
		
		public function setStatement(statement:Statement):void
		{
			_statement = statement;
		}
		
		public function getStatement():Statement
		{
			return _statement;
		}
		
	}
}