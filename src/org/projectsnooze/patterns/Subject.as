package org.projectsnooze.patterns
{
	public interface Subject
	{
		function registerObserver ( observer : Observer ) : void;
		
		function removeObserver ( observer : Observer ) : void;
		
		function notifyObservers ( obj : Object = null ) : void;
	}
}