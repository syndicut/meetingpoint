import mx.core.UIObject;
import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;
import mx.controls.Button;
import it.unipmn.di.Meeting.Connectors.IConnector;
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;
import it.unipmn.di.Meeting.Utils.Size;
import it.unipmn.di.Meeting.Debug.*;

class it.unipmn.di.Meeting.components.People.People extends UIObject implements IClientComponent, IUIWindowComponent {


	var uri:String

	var name:String

	var button_req_on:Button

	var button_star_power:Button

	var button_star_moderator:Button

	var button_star_user:Button

	var button_approve_off:Button

	var button_approve_on:Button

	var button_approve_undef:Button

	var button_req_off:Button

	var button_kick_off:Button

	var button_info:Button


	var connector:IConnector

	var so:SharedObject

	var hide:Boolean;

	var people_lb:DataGrid;
	
	function People() {
		this.name = (this._name == null ? "_DEFAULT_" : this._name);
		
		this.uri = "People";
		
		this.hide=false;

		_root.core.addNetworkComponent(this);
		
		_root.tooltip(this.button_req_on, _root.stringsManager.get("BUTTON_REQ_ON"));
		_root.tooltip(this.button_star_power, _root.stringsManager.get("BUTTON_STAR_POWER"));
		_root.tooltip(this.button_star_moderator, _root.stringsManager.get("BUTTON_STAR_MODERATOR"));
		_root.tooltip(this.button_star_user, _root.stringsManager.get("BUTTON_STAR_USER"));
		_root.tooltip(this.button_approve_off, _root.stringsManager.get("BUTTON_APPROVE_OFF"));
		_root.tooltip(this.button_approve_on, _root.stringsManager.get("BUTTON_APPROVE_ON"));
		_root.tooltip(this.button_approve_undef, _root.stringsManager.get("BUTTON_APPROVE_UNDEF"));
		_root.tooltip(this.button_req_off, _root.stringsManager.get("BUTTON_REQ_OFF"));
		_root.tooltip(this.button_kick_off, _root.stringsManager.get("BUTTON_KICK_OFF"));
		_root.tooltip(this.button_info, _root.stringsManager.get("BUTTON_INFO"));
	}
	
	function drawDataGrid(){
		//_root.Log.print("drawDataGrid: ");
		this.people_lb.setStyle("alternatingRowColors", [0xFFFFFF, 0xDEDEDE]);
		var peopleIconFunction = function (itemObj:Object, columnName:String) {
			if (itemObj == undefined || columnName == undefined) {
				return;
			}
			switch (columnName) {
				case "appr":
					var appr = itemObj.appr;
					return (appr == undefined ? "approve_undef" :  (appr == true ? "approve_on": "approve_off"));
					break;
				case "req":
					var req = itemObj.req;
					return (req == undefined ? "req_off" :  (req  == true ? "req_on": "req_off"));
					break;
				case "role":
					var role = itemObj.role;
					return ((role == undefined || role == "guest") ? "role_guest" :(role == "user") ? "role_user" :  (role == "moderator" ? "role_moderator": "role_poweruser"));
					break;
				case "star":
					var star = itemObj.star;
					return ((star == undefined || star == "none") ? "star_none" :  (star == "moderator" ? "star_moderator": "star_poweruser"));
					break;
				case "os":
					var os = itemObj.os;
					return ((os == undefined || os == "none") ? "os_none" : (os.substr(0,7) == "Windows" ? "os_win":  ( os.substr(0,5) == "Linux" ? "os_linux": ( os.substr(0,3) == "Mac" ? "os_mac": "os_none"))));
					break;
				case "aud":
					var audio = itemObj.audio;
					return ((audio == undefined || audio == "f") ? "audio_off" : ((audio == "l") ? "audio_lock" : "audio_on"));
					break;
				case "vid":
					var video = itemObj.video;
					return ((video == undefined || video == "f") ? "video_off" : (( video == "l") ? "video_lock": "video_on"));
					break;
			}
		}
		this.people_lb.columnNames=["aud","vid","star","role","req","appr","name"];
		
		var col:DataGridColumn;
		var i=0;
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Aud";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["iconFunction"] = peopleIconFunction;
		col["columnIcon"] = "audio_none";
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Vid";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["iconFunction"] = peopleIconFunction;
		col["columnIcon"] = "video_none";
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Star";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["iconFunction"] = peopleIconFunction;
		col["columnIcon"] = "star_none";
		
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Role";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["iconFunction"] = peopleIconFunction;
		col["columnIcon"] = "role_guest";
		
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Requeset";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["iconFunction"] = peopleIconFunction;
		col["columnIcon"] = "req_off";
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 25;
		col.resizable=false;
		col.headerText = "Approve";
		col.cellRenderer = "IconCellRenderer";
		col.headerRenderer = "HeaderIconRender";
		col["columnIcon"] = "approve_undef";
		col["iconFunction"] = peopleIconFunction;		
		
		col = this.people_lb.getColumnAt(i++);
		col.width = 200;
		col.headerText = "Users";

		this.people_lb.removeAll();
		var dataArray= new Array();
		for (var i in this.so.data) {
			var my_lv:LoadVars = new LoadVars();
			my_lv.decode((this.so.data[i])["capabilities"]);
			var os = my_lv["OS"];
			var video = my_lv["VIDEO"];
			var audio = my_lv["AUDIO"];
			this.people_lb.addItem({serverID: (this.so.data[i])["serverID"],star: (this.so.data[i])["star"],role: ((this.so.data[i])["role"]==undefined?"guest":(this.so.data[i])["role"]),req: ((this.so.data[i])["request"] == undefined ?false:(this.so.data[i])["request"]),appr: (this.so.data[i])["approve"], name: (this.so.data[i])["fullname"],capabilities: (this.so.data[i])["capabilities"], os:os, audio:audio, video:video});
		}
		
		this._parent.refreshWindow();
	}
	
	function getURI ():String {
			
			return this.uri;
			
	}
	function getClass():String{
		
		return "People";
		
	}
	
	function onUnload () {
		
		this.close();
	
	}
	
	function onConnect(conn:IConnector):Void	{
		
		this.connector = conn;
		//_root.Log.print("People onConnection: ");
		var listener = new Object();
		listener.onSync=function (list){
			_root.Log.print("People onSync()", list);
			this.parent.people_lb.removeAll();
			//this.parent.drawDataGrid();
	
			var dataArray= new Array();
			for (var i in this.data) {
				_root.Log.print("People data[i]: ", (this.data[i])["fullname"]);
				var my_lv:LoadVars = new LoadVars();
				my_lv.decode((this.data[i])["capabilities"]);
				var os = my_lv["OS"];
				var video = my_lv["VIDEO"];
				var audio = my_lv["AUDIO"];
				this.parent.people_lb.addItem({serverID: (this.data[i])["serverID"],star: (this.data[i])["star"],role: ((this.data[i])["role"]==undefined?"guest":(this.data[i])["role"]),req: ((this.data[i])["request"] == undefined ?false:(this.data[i])["request"]),appr: (this.data[i])["approve"], name: (this.data[i])["fullname"],capabilities: (this.data[i])["capabilities"], os:os, audio:audio, video:video});
			}
			/*this.parent.people_lb.dataProvider = dataArray;
			
			this.parent.people_lb.sortItemsBy("role", "ASC");
			this.parent.people_lb.redraw();
			*/
		}	
		this.so = this.connector.recordSharedObject("users", this, listener, this, false);
		
		this.connector.setReceiver(this.uri, "showKickOff", this.showKickOff, this);
		
	}	

	function showKickOff(obj, arg):Void{
		_root.showMessage("You are banned from this conference:", "Message: "+arg.why);
	}
	function onDisconnect():Void{
		
		
	}
	
	function onStatus (info:Object):Void{
	
	}

	function close ( ):Void{
		
		delete this.so.onSync;
		
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		
		this.people_lb.removeAll();
		delete this.people_lb;
	
	}
	
	function setSize (newWidth:Number, newHeight:Number):Void {
		this.people_lb.setSize(newWidth,newHeight-25);
		this.people_lb.getColumnAt(0).width=this.people_lb.getColumnAt(1).width=this.people_lb.getColumnAt(2).width=this.people_lb.getColumnAt(3).width=this.people_lb.getColumnAt(4).width =this.people_lb.getColumnAt(5).width=this.people_lb.getColumnAt(6).width= 22;
		var y=newHeight-23;
		var x=0;
		this.button_req_off.move(x,y);
		x+=28;
		this.button_req_on.move(x,y);
		x+=28;
		this.button_approve_off.move(x,y);
		x+=28;
		this.button_approve_on.move(x,y);	
		x+=28;
	
		this.button_approve_undef.move(x,y);
		var info = _root.getUserInformation();
		
		this.button_star_power._visible=false;
		this.button_star_moderator._visible=false;
		this.button_star_user._visible=false;
		this.button_info._visible=false;
		this.button_kick_off._visible=false;
		
		
		if(info.role=="poweruser"){
			x+=28;
			this.button_info.move(x,y);
			x+=28;
			this.button_star_power.move(x,y);
			x+=28;
			this.button_star_moderator.move(x,y);
			x+=28;
			this.button_star_user.move(x,y);
			x+=28;
			this.button_kick_off.move(x,y);
			
			this.button_star_power._visible=true;		
			this.button_info._visible=true;
			this.button_star_moderator._visible=true;
			this.button_star_user._visible=true;
			this.button_kick_off._visible=true;
		}else if(info.role=="moderator"){
			x+=28;
			this.button_star_moderator.move(x,y);
			x+=28;
			this.button_star_user.move(x,y);
			this.button_star_moderator._visible=true;
			this.button_star_user._visible=true;
		}
		
	}
	
	function getSelectedUserRequest () {
		var req = this.people_lb.selectedItem.Request;
		//trace("selected user is requesting?  "+ (req=="*"));
		return (req=="*");
	}
	
	
	function getPreferredSize():Size{
			var size=new Size();
			size.width=250;
			size.height=300;
			return(size);
	
	}
	function getMinimumSize():Size{
		var size=new Size();
		size.width=275;
		size.height=100;
		return(size);
	}
	
	function setRequest (value) {		
		this.connector.send(this.uri,"setRequest", {request:value});
	}
	
	function setStar (value) {
		if(this.people_lb.selectedItem != null && this.people_lb.selectedItem != undefined)
			this.connector.send(this.uri,"setStar", {star:value, who: this.people_lb.selectedItem });
	}

	function kick_off() {
		if(this.people_lb.selectedItem != null && this.people_lb.selectedItem != undefined){
			var info = _root.getUserInformation();
			if(this.people_lb.selectedItem.serverID == info.serverID)
				return;
			var dialog = this._parent.createDialogBox(DialogType.PromptBox);
			dialog.setTitle(_root.stringsManager.get("KO_MSG_TITLE"));
			dialog.setLabel(_root.stringsManager.get("KO_MSG"));
			
			var dialogResponse = new Object();
			dialogResponse.parent=this;
			dialogResponse.win=dialog;
		
			dialogResponse.close = function (evt_obj:Object) {
				if(evt_obj.label!=_root.stringsManager.get("CANCEL"))
					this.parent.connector.send(this.parent.uri,"kickOff", {who: this.parent.people_lb.selectedItem.serverID, why:evt_obj.input});
				this.win.removeMovieClip();
			};
			dialog.addEventListener("close", dialogResponse);
		}
	}
	
	function setApprove (value) {
		this.connector.send(this.uri,"setApprove", {approve:value});
	}
	
	function getSelectedUser () {
		var user = this.people_lb.selectedItem.Name;
		//trace("selected user is: "+user);
		return user;
	}

	function capabilities(){
		_root.Log.print("..."+System.capabilities.hasEmbeddedVideo, System.capabilities.serverString);
		if(this.people_lb.selectedItem != null && this.people_lb.selectedItem != undefined){
			var dialog = this._parent.createDialogBox("ListBox");
			dialog.setTitle(_root.stringsManager.get("USER_CAP_TITLE"));
			var list= new Array(); 
			var my_lv:LoadVars = new LoadVars();
			my_lv.decode(this.people_lb.selectedItem.capabilities);
			for (var prop in my_lv) {
				list.push({label:prop+": "+my_lv[prop]});
			}
			dialog.setList(list);
			
			var dialogResponse = new Object();
			dialogResponse.parent=this;
			dialogResponse.win=dialog;
		
			dialogResponse.close = function (evt_obj:Object) {
				this.win.removeMovieClip();
			};
			dialog.addEventListener("close", dialogResponse);
		}
	}
	
	

}
