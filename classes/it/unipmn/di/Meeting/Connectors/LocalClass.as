
import it.unipmn.di.Meeting.Debug.*;

class it.unipmn.di.Meeting.Connectors.LocalClass {
	var info:Array = new Array();
	var components:Array = new Array();
	var lc:LocalConnection;
	var lc_name:String;
	var receivers:Object = new Object();
	
	function LocalClass() {
	
		this.lc= new LocalConnection();
		
		this.lc.onStatus=this.onLCStatus;
	}
	
	function onLCStatus (info):Void{
			_root.Log.print(this+" onStatus()",info);				
			this.info.push(info);
			
			for (var i=0; i < this.components.length; i++) {
				this.components[i].onStatus(info);
			}
	}
	
	function open (name):Void {
		this.lc_name=name;
		this.lc.recv=this.recvListener;
		this.lc.connect(name);
		
	}
	
	function recordComponent (component):Void {
		this.lc.send(this.lc_name, "recordClientComponent", { uri: component.uri, name: component.getClass() });
	}
	
	function unrecordComponent (component):Void {
		this.lc.send(this.lc_name, "unrecordClientComponent", { uri: component.uri, name: component.getClass() });
	}
	
	function addComponent (component):Void {
		this.components.push(component);
		component.connector = this;
	}
	
	function removeComponent (component):Void {
		for (var i=0; i < this.components.length; i++) {
			if(this.components[i].uri == component.uri){
				this.components.splice(i,1);
			}
		}
	}
	
	function connect ():Void {
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
	}
	
	function send (uri, method, param):Void {
		this.lc.send(this.lc_name, "clientMessage" ,{ uri: uri, method: method, param: param});
	}
	
	function setReceiver (uri, method, callback):Void {
		this.receivers[uri][method]=callback;
	}
	
	function recvListener ( uri, method, param ):Void {
		
		this.receivers[uri][method](param);
		
	}
	
	function close ():Void {
		this.lc.close();
	}
	
	function getInfo ():Array {
	
		return this.info;
		
	}
}