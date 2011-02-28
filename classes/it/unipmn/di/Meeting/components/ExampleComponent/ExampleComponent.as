import mx.core.UIObject;
import mx.controls.*;

import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.Connectors.*;
import it.unipmn.di.Meeting.Debug.*;
import it.unipmn.di.Meeting.UIObjects.*;


class it.unipmn.di.Meeting.components.ExampleComponent.ExampleComponent extends UIObject implements IClientComponent, IUIWindowComponent {

	
	var message_txt:TextInput
	var uri:String
	var name:String
	var history_txt:TextArea
	var sendButton:Button
	var hasFocus:Boolean
	var connector:IConnector
	var so:SharedObject
	
	function ExampleComponent() {

		this.name = ( this._name == null ? "_DEFAULT_" : this._name );
		
		this.uri = "ExampleComponent";
	
		createClassObject(TextArea, "history_txt", this.getNextHighestDepth(), {html:true, editable:false, wordWrap:true});
		createClassObject(TextInput, "message_txt", this.getNextHighestDepth(), {editable:true, password:false});
		createClassObject(Button, "sendButton", this.getNextHighestDepth(), {label:"Send", labelPlacement:"right"});
	
		
		this.message_txt.onKillFocus = function() {
			trace("onKillFocus");
			this._parent.hasFocus = false;
		};
		
		this.message_txt.onSetFocus = function () {
			trace("setKillFocus");
			this._parent.hasFocus = true;
		};
		
		this.message_txt.setFocus();	
		
		
		var enterListener = new Object();
		enterListener.owner = this;
		enterListener.onKeyDown = function () {
			if (this.owner.hasFocus && Key.isDown(Key.ENTER)) {
				this.owner.sendMessage();
			}
		};
		
		this.sendButton.addEventListener("click",this);
	
		Key.addListener(enterListener);
		
		_root.core.addNetworkComponent(this);
		
	}

	function getURI():String {
		
		return this.uri;
		
	}
	
	function getClass():String {
		
		return "ExampleComponent";
		
	}
	
	function onUnload():Void {
		this.close();
	}
	
	function onDisconnect() :Void{
	
		this.close();
	
	}
	
	function onConnect(con:IConnector) :Void{
	
		this.history_txt.text = "";
		
		this.connector = con;
	
		var callbacks = new Object();
		
		callbacks.message = function( mesg:String ) { 
			this.parent.receiveMessage(mesg);
		};
			
		this.so = this.connector.recordSharedObject("message", this, this, this, false,callbacks);
	
	
		this.connector.setReceiver(this.uri, "receiveHistory", this.receiveHistory, this);
		
	}
	
	function onStatus (info:Object):Void {
	
	}
	
	function onSync (list:Object):Void {
	
	}
	
	function close():Void{
		
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
	
	}
	
	function receiveHistory(from:Object,h:Object) :Void{
	
		from.history_txt.text = "<font color=\"#FF0000\">----------History-----------</font><br />";
		var his = h["history"];
		for ( var i=0; i < his.length; i++ ){
			from.history_txt.text += his[i];
		}
		from.history_txt.text += "<font color=\"#FF0000\">------------End-------------</font><br />";
		
		from.history_txt.vPosition=from.history_txt.maxVPosition;
	}
	
	function receiveMessage( mesg:String ) :Void{
		
		Log.print("receiveMessage message: " + mesg);
		
		this.history_txt.text += mesg;
		
		this.history_txt.vPosition=this.history_txt.maxVPosition;
	
	}

	function click(evt:Object):Void{
		this.sendMessage();
	}
	
	function sendMessage(mesg:String) :Void{
		if(this.message_txt.text=="")
			return;

		this.connector.send(this.uri,"sendMessage", {message: this.message_txt.text });
		
		this.message_txt.text = "";
	}
	
	function setSize (newWidth:Number, newHeight:Number):Void{
		
		this.sendButton.setSize(50,22);
		this.sendButton._x=newWidth-this.sendButton._width;
		this.sendButton._y=newHeight - this.sendButton._height;
		this.message_txt.setSize(newWidth-this.sendButton._width-3,22);
		this.message_txt._y=newHeight - this.message_txt._height;
		this.history_txt.setSize(newWidth,newHeight-this.message_txt._height-3);
		
	}
	
	function getPreferredSize():Size {
			var size=new Size();
			size.width=400;
			size.height=300;
			return(size);
	
	}


	function getMinimumSize():Size {
			var size=new Size();
			size.width=200;
			size.height=100;
			return(size);
	}

}
