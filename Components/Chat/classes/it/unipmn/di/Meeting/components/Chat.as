import mx.core.UIObject;
import mx.controls.TextArea;
import mx.controls.TextInput;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import it.unipmn.di.Meeting.Debug.*;

class it.unipmn.di.Meeting.components.Chat extends MovieClip implements IClientComponent, IUIWindowComponent { 
	 
	var message_txt:TextInput
	var uri:String
	var name:String
	var history_txt:TextArea
	var sendButton:Button
	var hasFocus:Boolean
	var connector:IConnector
	var so:SharedObject
	var users_so:SharedObject
	var movie:MovieClip
	var _parent:MovieClip
	var private_name:String;
	var private_id:String;
	
	function getClass ():String {
		return this.uri;
	}

	function Chat(clip:MovieClip) {
		super();
		this._parent= clip._parent;
		this.name = ( this._name == null ? "_DEFAULT_" : this._name );
		this.uri = "Chat";
	
		//this._parent.setUrgencyHint(true);
		this.movie=clip;
				
		this.movie.createClassObject(Button, "clearButton", this.movie.getNextHighestDepth(), {label:_root.stringsManager.get("CHAT_BUTTON_CLEAR"), labelPlacement:"right", icon:"clean"});
		
		this.movie.createTextField("privateLabel", this.movie.getNextHighestDepth(),0,0,30,22);
		
		this.movie.createClassObject(ComboBox, "privateCombo", this.movie.getNextHighestDepth());
		
		this.movie.createClassObject(Button, "sendButton", this.movie.getNextHighestDepth(), {label:_root.stringsManager.get("CHAT_BUTTON_SEND"), labelPlacement:"right", icon:"send"});
		this.movie.createClassObject(TextArea, "history_txt", this.movie.getNextHighestDepth(), {html:true, editable:false, wordWrap:true});
		this.movie.createClassObject(TextInput, "message_txt", this.movie.getNextHighestDepth(), {editable:true, password:false});

		this.movie.privateCombo._y=2;
		this.movie.privateLabel._y=2;
		this.movie.privateLabel.autoSize=true;
		this.movie.privateLabel.text = _root.stringsManager.get("CHAT_SEND_TO");
		
		this.movie.clearButton._y=2;
		this.movie.clearButton._x=2;
		this.movie.clearButton.icon="clean";
		this.movie.sendButton.icon="send";
		this.movie.clearButton.setSize(70,22);
		this.movie.sendButton.setSize(50,22);
		this.movie.history_txt._y=26;
		
	
		
		this.movie.privateCombo.addItem({data:null, label:_root.stringsManager.get("CHAT_EVERYONE")});
		this.movie.privateCombo.addItem({data:-1, label:"Powerusers"});
		this.movie.privateCombo.addItem({data:-2, label:"Moderators"});
		this.movie.privateCombo.addItem({data:-3, label:"Users"});

		
		// Message text loses focus
		this.movie.message_txt.onKillFocus = function () {
			//trace("onKillFocus");
			this._parent.hasFocus = false;
		}
		//
		// Message text gets focus
		this.movie.message_txt.onSetFocus = function () {
			//trace("setKillFocus");
			this._parent.hasFocus = true;
		}
		//
		// Listens for a key down and checks to see if Enter was pressed from the message text box
		var enterListener = new Object();
		enterListener.owner = this;
		enterListener.onKeyDown = function () {
			if (this.owner.movie.hasFocus && Key.isDown(Key.ENTER)) {
				this.owner.sendMessage();
			}
		}
		Key.addListener(enterListener);

		_root.core.addNetworkComponent(this);
		
		this._parent.addEventListener("close", this);
	
		this.movie.message_txt.setFocus();	

		var sendListener = new Object();
	 	sendListener.parent=this;
		sendListener.click = function(evn){
			this.parent.sendMessage();
		}
		
		var clearListener = new Object();
	 	clearListener.parent=this;
		clearListener.click = function(evn){
			this.parent.clearChat();
		}
		
		var changeListener = new Object();
		changeListener.parent = this;
		changeListener.change = function(event_obj:Object) {
			//trace(this.parent+ " Value changed to: "+event_obj.target.selectedItem.label);
			this.parent.setPrivate(event_obj.target.selectedItem.label, event_obj.target.selectedItem.data);
		}
		
		this.movie.privateCombo.addEventListener("change", changeListener);
				
		this.movie.sendButton.addEventListener("click",sendListener);
		this.movie.clearButton.addEventListener("click",clearListener);
		
		/*
		 * Tooltips
		 */
		_root.tooltip(this.movie.sendButton, _root.stringsManager.get("CHAT_BUTTON_SEND_TT"));
		_root.tooltip(this.movie.clearButton, _root.stringsManager.get("CHAT_BUTTON_CLEAR_TT"));
		_root.tooltip(this.movie.privateCombo, _root.stringsManager.get("CHAT_COMBO_RECIPIENT_TT"));
		
	}
	
	//
	function onUnload () {
		this.close();
	}
	
	function onDisconnect ():Void {
		
	}
	
	function onConnect (con:IConnector):Void {
		
		this.history_txt.text = "";
		
		this.connector = con;
	
		var callbacks = new Object();
		callbacks.parent=this;
		callbacks.message =function ( mesg , to, toId, fromId) {
			
			if(toId==null){
				this.parent.receiveMessage(mesg);
				return;
			}
			var info = _root.getUserInformation();
			if(toId == "-1" && (info.role == "poweruser" || info.star == "poweruser"))
				this.parent.receiveMessage(mesg);
			else if(toId == "-2" && (info.role == "moderator" || info.star == "moderator"))
				this.parent.receiveMessage(mesg);
			else if(toId == "-3" && (info.role == "user" || info.star == "user"))
				this.parent.receiveMessage(mesg);
			else if(toId >= 0 && info.serverID == toId)
				this.parent.receiveMessage(mesg);
			else if(info.serverID == fromId)
				this.parent.receiveMessage(mesg);
		}
		callbacks.clearChat =function ( m ) { 
			trace("clearChat:"+ this.parent.movie.history_txt);
			this.parent.movie.history_txt.text="";
		}

		var so_listener = new Object();
		so_listener.onSync=function(list){
			//Log.print("Users list:", list);
			this.parent.movie.privateCombo.removeAll();
			this.parent.movie.privateCombo.addItem({data:null, label:_root.stringsManager.get("CHAT_EVERYONE")});
			this.parent.movie.privateCombo.addItem({data:"-1", label:"Powerusers"});
			this.parent.movie.privateCombo.addItem({data:"-2", label:"Moderators"});
			this.parent.movie.privateCombo.addItem({data:"-3", label:"Users"});
			var info = _root.getUserInformation();
			for(var a in this.data){
				if(info.serverID!=this.data[a].id)
					this.parent.movie.privateCombo.addItem({data:this.data[a].id, label:this.data[a].name});
			}
		}
		
		this.users_so = this.connector.recordSharedObject("users", this, so_listener, this, false);
		
		this.so = this.connector.recordSharedObject("message", this, this, this, false,callbacks);
	
		this.connector.setReceiver(this.uri, "receiveHistory", this.receiveHistory, this);
		
		this.connector.send(this.uri,"getHistory", { });
		
	}
	//
	function onStatus (info:Object):Void{
		
	}
	//
	function close ():Void {
		
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		this.movie.removeMovieClip();
	}
	
	function receiveHistory (f,h) {
	
		f.movie.history_txt.text = "<font color=\"#FF0000\">----------History-----------</font><br />";
		var his = h.history;
		for ( var i=0; i < his.length; i++ ){
			f.movie.history_txt.text += his[i];
			
		}
		f.movie.history_txt.text += "<font color=\"#FF0000\">---------------------------</font><br />";
		
		f.movie.history_txt.vPosition=f.movie.history_txt.maxVPosition;
	}
	//
	function receiveMessage ( mesg ) {
		
		//trace("receiveMessage message: " + mesg);
		this.movie.history_txt.text += mesg;
		this.movie.history_txt.vPosition=this.movie.history_txt.maxVPosition;
	
	}

	function clearChat () {
		this.connector.send(this.uri,"clearChat", {});
	}
	
	function setPrivate (name, id) {
		this.private_name = name;
		this.private_id = id;
	}
	
	function sendMessage (mesg) {
		if(this.movie.message_txt.text=="")
			return;
		if(private_id == null || private_id == undefined)
			this.private_name=_root.stringsManager.get("CHAT_EVERYONE");

		var info = _root.getUserInformation();
		
		if(info.role == "poweruser" || info.role == "moderator" || info.role == "user")
			this.connector.send(this.uri,"sendMessage", {message: this.movie.message_txt.text, private_name:this.private_name, private_id:private_id });
		
		this.movie.message_txt.text = "";
	}
	
	
	function getURI ():String {
			
			return this.uri;
			
	}

	function setSize (newWidth:Number, newHeight:Number):Void {
		
		this.movie.privateCombo._x=(newWidth-this.movie.privateCombo._width)-2;
		
		this.movie.privateLabel._x=(this.movie.privateCombo._x-this.movie.privateLabel._width)-2;

		
		this.movie.sendButton._x=newWidth-52;
		this.movie.sendButton._y=newHeight - 22;
		
		this.movie.message_txt.setSize(newWidth-this.movie.sendButton._width-3,22);
		this.movie.message_txt._y=newHeight - this.movie.message_txt._height;
		this.movie.history_txt.setSize(newWidth,(newHeight-26)-this.movie.message_txt._height-3);
		
		var info = _root.getUserInformation();
		
		if(info.role == "poweruser" || info.role == "moderator" || info.star == "poweruser" || info.star == "moderator")
			this.movie.clearButton._visible = true;
		else
			this.movie.clearButton._visible = false;
		
		if(info.role == "poweruser" || info.role == "moderator" || info.role == "user")
			this.movie.message_txt.editable = this.movie.message_txt.enabled = true;
		else
			this.movie.message_txt.editable = this.movie.message_txt.enabled = false;
	}
	
	function getPreferredSize ():Size {
			var size=new Object();
			size.width=400;
			size.height=300;
			return(size);
	
	}
	function getMinimumSize ():Size {
			var size=new Object();
			size.width=250;
			size.height=180;
			return(size);
	}
}