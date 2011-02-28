import it.unipmn.di.Meeting.Connectors.*;

interface it.unipmn.di.Meeting.Connectors.IUsersList{

	function getList():Object;
	
	function getUsersNum():Number;
	
	function getUserName(id):String;
	
	function addEventListener(eventType:String, listener:Object):Void;
	
	function removeEventListener(eventType:String, listener:Object):Void;
}
	