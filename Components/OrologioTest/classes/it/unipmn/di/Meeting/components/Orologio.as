import mx.core.UIObject;
import mx.controls.*;

import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.Connectors.*;
import it.unipmn.di.Meeting.Debug.*;
import it.unipmn.di.Meeting.UIObjects.*;

class it.unipmn.di.Meeting.components.Orologio extends UIObject implements IClientComponent, IUIWindowComponent {

	
	var uri:String
	var name:String
	var connector:IConnector
	var orologio:MovieClip
	var timerPing:Number
	var timeFrom:String
	var location:TextField
	
	function Orologio() {

		this.name = ( this._name == null ? "_DEFAULT_" : this._name );
		
		this.uri = "Orologio";
	
		
		
		//this._parent.setUrgencyHint(true);
		this._parent.setTrasparent(true);
		_root.core.addNetworkComponent(this);
		this._parent.addEventListener("close", this);
		
	}

	function getURI():String {
		
		return this.uri;
		
	}
	
	function getClass():String {
		
		return "Orologio";
		
	}
	
	function onUnload():Void {
		this.close();
	}
	
	function onDisconnect() :Void{
	
		this.close();
		this.connector.unrecordComponent(this);
	
	}
	
	function setServerTime(yea) {
		
		if(yea){
			
			this.location.text="Server Time";
			clearInterval(this.timerPing);
			this.timerPing= setInterval(this.pingServer,20000,this);
			this.pingServer(this);
			
		}else{
			
			this.location.text="Local Time";
			clearInterval(this.timerPing);
			this.timerPing= setInterval(this.pingLocal,20000,this);
			this.pingLocal(this);
		}
		
	}
	
	function onConnect(con:IConnector) :Void{
		
		this.connector=con;
		
		this.connector.setReceiver(this.uri, "retriveTime", this.retriveTime, this);
		
		
		
		if(this.timeFrom=="LOCAL")
			this.setServerTime(false);
		else
			this.setServerTime(true);
			
	}
	
	function onStatus (info:Object):Void {
	
	}
	
	function onSync (list:Object):Void {
	
	}
	
	function close():Void{
		this.orologio.stopInterval();
		this.connector.unrecordComponent(this);
	}
	
	 function pingLocal(from) {
		
		if(from.orologio.setTime==undefined){
			clearInterval(from.timerPing);
			from.timerPing= setInterval(from.pingLocal,200,from);
		}else
		{
			clearInterval(from.timerPing);
			from.timerPing= setInterval(from.pingLocal,20000,from);
		}
		from.orologio.stopInterval();
		from.orologio.setTime(new Date());
		
	}
	
	function pingServer(from) {
		if(from.connector==undefined || from.connector==null){
			from._parent.newError("Nessuna connessione.\nImpossibile aprire nuove applicazioni senza prima aver effettuato la connessione", true);
			return false;
		}
		else{
			from.connector.send(from.uri,"requestTime", new Object());
		}
		
	}
	
	 function retriveTime(obj, time) {
		obj.orologio.stopInterval();
		obj.orologio.setTime(new Date(2000,1,1,time.hour,time.minute,time.second,time.millisecond));
	}
	
	
	function setSize (newWidth:Number, newHeight:Number):Void{
		
		var h_w = newWidth/2;
		var h_h = newHeight/2;
		
		var h_larg = this.orologio._width/2;
		var h_alt = this.orologio._height/2;
		
		this.orologio._x = h_w - h_larg;
		this.orologio._y = h_h - h_alt;
		this.location._x=this.orologio._x;
		this.location._y=this.orologio._y+this.orologio._height-this.location._height;
		
	}
	
	function getPreferredSize():Size {
			var size=new Size();
			size.width=175;
			size.height=175;
			return(size);
	
	}
	function getMinimumSize():Size {
			var size=new Size();
			size.width=175;
			size.height=175;
			return(size);
	}

}