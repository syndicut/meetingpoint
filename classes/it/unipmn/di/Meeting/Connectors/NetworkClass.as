import it.unipmn.di.Meeting.Debug.*;
import it.unipmn.di.Meeting.Connectors.*;

class it.unipmn.di.Meeting.Connectors.NetworkClass implements IConnector{
	
	
	var components:Array = new Array();
	
	var receivers:Object = new Object();
	
	var netStreams:Object = new Object();
	
	var sharedObjects:Object = new Object();
	
	var info:Array = new Array();
	
	var nc_name:String;
	
	var nc:NetConnection;
	
	var connected:Boolean;
	
	var usersList_so:SharedObject;
		
	var clientInfoTimerID:Number;

	var users:UsersList;
		
	function NetworkClass() {
		//_root.Log.print("NetworkClass()",this.receivers);				
		this.connected = false;
		this.users = new UsersList(this);

	}
	function isConnected():Boolean{
		return this.connected;
	}
	
	function open(name:String, params:Object ):Void {
		
		//System.security.allowDomain(name);
		
		this.nc= new NetConnection();
		this.nc.owner = this;
		this.nc.onStatus=function (stat){			
			switch(stat["code"]){
				case "NetConnection.Connect.Success":
					this.owner.connected=true;
					break;
				case "NetConnection.Connect.Rejected":
					this.owner.connected=false;
					break;
				case "NetConnection.Connect.Failed":
					this.owner.connected=false;
					break;
				case "NetConnection.Connect.Closed":
					this.owner.connected=false;
					break;
				case "NetConnection.Connect.AppShutdown":
					this.owner.connected=false;
					break;
			}

			this.owner.info.push(stat);
	
			for (var i=0; i < this.owner.components.length; i++) {
				this.owner.components[i]["onStatus"](stat);
			}
			if(this.owner.connected == false)
				this.owner.users.clear();
		}
	
		this.nc_name=name;
		
		this.nc.recvInfo = function(info){
			this.owner.info = new Object();
			for(var a in info)
				this.owner.info[a] = info[a];
		}
		
		this.nc.serverMessage=this.recvListener;
	
		this.nc.connect(name,params);
	
		var clientInfoTimerCallback = function (f){
			//clearInterval(f.clientInfoTimerID)
			var resultObject = new Object();
			resultObject.parent = f			
			resultObject.onResult = function(returnValue){
						f.info = new Object();
						for(var a in returnValue)
							f.info[a] = returnValue[a];
			}
			
			f.nc.call("Core.clientInfo", resultObject, { });
		}
		this.clientInfoTimerID = setInterval(clientInfoTimerCallback,1000, this);
		
		this.connectUsersListener();
	}
	
	function recordComponent (component:IClientComponent):Void {
		this.nc.call("Core.recordClientComponent", null, { uri: component.getURI(), objClass: component.getClass() });
	
	}
	
	function unrecordComponent (component:IClientComponent):Void{
		this.nc.call("Core.unrecordClientComponent", null, { uri: component.getURI(), objClass: component.getClass() });
	}
	
	function addComponent (component:IClientComponent):Void{
		
		this.components.push(component);
		
		if(this.connected==true){
			for (var i=0; i < this.components.length; i++) {
			
				if(this.components[i].uri == component.getURI()){
					this.recordComponent(this.components[i]);
					this.components[i].onConnect(this);
				}
				
			}
		}
	
	}
	
	function removeComponent (component:IClientComponent):Void {
		for (var i=0; i < this.components.length; i++) {
			
			if(this.components[i].uri == component.getURI()){
				this.components[i] = null;
				delete this.components[i];
				this.components.splice(i,1);
				
			}
			
		}
		
	}
	
	function recordNetStream (name:String, component:IClientComponent, listener:Object, object:Object,callbacks:Object):NetStream {
	var uri = component.getURI();
		this.nc.call("Core.recordNetStream", null, { uri: uri, name: name });
	
		
		this.netStreams[uri] = new Object();
		this.netStreams[uri][name] = new NetStream(this.nc);
	
		for(var a in callbacks){
			this.netStreams[uri][name][a] = callbacks[a];
		}
		
		this.netStreams[uri][name]["onCuePoint"] = listener["onCuePoint"];
		this.netStreams[uri][name]["onMetaData"] = listener["onMetaData"];
		this.netStreams[uri][name]["onStatus"] = listener["onStatus"];
		this.netStreams[uri][name]["parent"] = object;
		
		return this.netStreams[uri][name];
	}
	
	function unrecordNetStream (name:String, component:IClientComponent):Void {
		var uri = component.getURI();
		this.nc.call("Core.unrecordNetStream", null, { uri: uri, name: name});
	
		this.netStreams[uri][name].close();
		delete this.netStreams[uri][name];
	
	}
	
	function connectUsersListener(){
		this.usersList_so = SharedObject.getRemote("Core.Internals/users_so", this.nc.uri, false);
		
		this.usersList_so.onSync = function(list){
			//_root.Log.print("usersList_so.onSync: ", list);
			for( var a in list){
				if(list[a].code == "change")
					this.parent.updatedUser(list[a].name, this.data[list[a].name]);
				else if(list[a].code == "delete")
					this.parent.removedUser(list[a].name, this.data[list[a].name]);
				else if(list[a].code == "clear")
					trace("Clear message");
			}
		}
		this.usersList_so.onStatus = function(){
			
		}
		this.usersList_so.parent = this.users;
		
		this.usersList_so.connect(this.nc);

	}
	function recordSharedObject (name:String, component:IClientComponent, listener:Object, object:Object, persistence:Boolean, callbacks:Object):SharedObject{
		var uri = component.getURI();
		this.nc.call("Core.recordSharedObject", null, { uri: uri, name: name, persistence:persistence});
	
		
		this.sharedObjects[uri] = new Object();
		this.sharedObjects[uri][name] = SharedObject.getRemote(uri+"/"+name, this.nc.uri, persistence);
		for(var a in callbacks){
			this.sharedObjects[uri][name][a] = callbacks[a];
		}
		this.sharedObjects[uri][name]["onSync"] = listener["onSync"];
		this.sharedObjects[uri][name]["onStatus"] = listener["onStatus"];
		this.sharedObjects[uri][name]["parent"] = object;
		
		var result = this.sharedObjects[uri][name].connect(this.nc);
		_root.Log.print("SO "+uri+" . "+name+" created: "+result + " onSync: "+this.sharedObjects[uri][name]["onSync"]);
	
		return this.sharedObjects[uri][name];
	}
	
	function unrecordSharedObject (name:String, component:IClientComponent):Void {
		var uri = component.getURI();
		this.nc.call("Core.unrecordSharedObject", null, { uri: uri, name: name});
	
		this.sharedObjects[uri][name].close();
		delete this.sharedObjects[uri][name];
	
	}
	
	function unrecordAllSharedObject (component:IClientComponent):Void{
	
		var uri = component.getURI();
		this.nc.call("Core.unrecordAllSharedObject", null, { uri: uri});
	
		for(var name in this.sharedObjects[uri])
			this.sharedObjects[uri][name].close();
		
		delete this.sharedObjects[uri];
		
	}
	
	
	function connect ():Void  {
		
		for (var i=0; i < this.components.length; i++) {
			
			this.recordComponent(this.components[i]);
			
			this.components[i].onConnect(this);
			
		}
		
	}
	
	function disconnect ():Void {

		for (var i=0; i < this.components.length; i++) {
			
			this.unrecordComponent(this.components[i]);
			
			this.components[i].onDisconnect();
			
		}
		this.connected=false;
		
		receivers = new Object();
	
		netStreams = new Object();
	
		sharedObjects = new Object();
		
	}
	
	function send (uri:String, method:String, param:Object):Void {
		this.nc.call("Core.clientMessage", null, { uri: uri, method: method, params: param});
	}
	
	function setReceiver (uri:String, method:String, callback:Object, object:Object):Void{
		
		if(this.receivers[uri]==undefined)
			this.receivers[uri] = new Object();
		this.receivers[uri]["object"] = object;
		this.receivers[uri][method]=callback;
		
		//Log.print("setReceiver: "+this.receivers[uri]["object"]+"-"+method+"-"+this.receivers[uri][method], this.receivers[uri],2);
		
		
		//Log.print("setReceiver: ", this.receivers[uri],2);
	}
	
	function recvListener (uri, method, param ) {
		
		//Log.print("recvListener: "+this["owner"].receivers[uri]["object"]+"-"+method+"-"+this["owner"].receivers[uri][method], this["owner"].receivers[uri],2);
		
		this["owner"].receivers[uri][method](this["owner"].receivers[uri]["object"],param);
		
	}
	
	function close ():Void{
		
		this.nc.close();
		
	}
	
	function getStatus ():Object{
		
		return {connected: this.connected};
		
	}
	
	function getInfo ():Array{

		return this.info;
		
	}
}