import it.unipmn.di.Meeting.Connectors.*;

class it.unipmn.di.Meeting.Connectors.UsersList implements IUsersList{

	var usersEvents:Array;
	var network:NetworkClass;
	var userslist:Array;
	
	function UsersList(net:NetworkClass){
		this.usersEvents = new Array();
		this.network=net;
		this.userslist=new Array();
		var capCallback = function(f){
			var info = _root.getUserInformation();
			var cap = f.network.usersList_so.data[info.serverID].capabilities;
			if(cap != _root.getCapabilities()){
				f.network.usersList_so.data[info.serverID].capabilities = _root.getCapabilities();
			}
		}
		setInterval(capCallback, 1000, this);
	}
	
	function getList():Object{
		if(this.network.isConnected()!=true)
			return null;
		return this.userslist;
	}
	
	function getUserName(id):String{
		if(this.network.isConnected()!=true)
			return "";
		for(var i=0; i<this.userslist.length; i++){
			if(this.userslist[i].id == id && this.network.usersList_so.data[id].serverID == id){
				return this.userslist[i].username;
			}
		}
		return "";
	}
	
	function getUsersNum():Number{
		if(this.network.isConnected()!=true)
			return 0;
		return this.userslist.length;
	}
	
	function clear():Void{
		this.userslist = new Array();
		this.usersEvents = new Array();
	}
	
	function addEventListener(eventType:String, listener:Object):Void{
		var newEvent = new Object();
		newEvent.type = eventType;
		newEvent.action = listener;
		this.usersEvents.push(newEvent);
	}
	
	function removeEventListener(eventType:String, listener:Object):Void{
		for(var i = 0; i<this.usersEvents.length; i++){
			if (this.usersEvents[i].type == eventType && this.usersEvents[i].action == listener) {
				delete this.usersEvents[i];
				this.usersEvents.splice(i,1);
			}
		}
	}
	
	function updatedUser(id:Number, data:Object){
		for(var i=0; i<this.userslist.length; i++){
			if(this.userslist[i].id == id && this.network.usersList_so.data[id].serverID == id){
				this.userslist.push({id:id,username:this.network.usersList_so.data[id].fullname});
				return;
			}
		}
		this.userslist.push({id:id,username:this.network.usersList_so.data[id].fullname});
		this.doUsersEvent("update", {id:id,username:this.network.usersList_so.data[id].fullname});
	}
	
	function removedUser(id:Number, data:Object){
		for(var i=0; i<this.userslist.length; i++){
			if(this.userslist[i].id==id)
				break;
		}
		this.doUsersEvent("remove", {id:id, username:this.userslist[i].username});
		delete this.userslist[i];
		this.userslist.splice(i,1);
	}
	
	function doUsersEvent(event:String, obj:Object)
	{
		var i = 0;
		while (i<this.usersEvents.length) {
			if (this.usersEvents[i].type == event) {
				trace(this.usersEvents[i].action+" "+event );
				this.usersEvents[i].action[this.usersEvents[i].type](obj);
			}
			i++;
		}
	}
}