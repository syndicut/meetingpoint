import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.Connectors.*;
import mx.controls.Menu;

class it.unipmn.di.Meeting.UIObjects.WindowManager.WindowManager extends MovieClip implements IClientComponent{
	
	var uri:String;
	var emb:Object;
	var ext:Object;
	var so:SharedObject;
	var refreshRate:Number
	var refreshInterval:Number
	var refreshCallback:Function
	var windows:Array
	var connector:IConnector
	var localID:Number
	var connectionLed:MovieClip
	var menuBar:MovieClip
	var applicationBar:MovieClip
	var calendar:MovieClip
	var menuListener:Object
	var menuDP:Object
	var appDP:Object
	var fullscreenWindow:MovieClip
	var clock:MovieClip
	var error:MovieClip
	var sharedLayout:Boolean
	var width:Number
	var height:Number
	var users_infos:Array
	var userListener:Object
	var backgroundColor:Number = 0xcccccc
	var backgroundTrasparency:Number = 100
	function WindowManager() {
		this.sharedLayout = true;
		this.users_infos = new Array();
		this.uri = "WindowManager";

		this.attachMovie("ConnectionLed", "connectionLed", this.getNextHighestDepth(),{_y: 1.8});
		
		if(this.refreshRate == undefined)
			this.refreshRate=500;
		
	
				
		this.refreshCallback =function(from) {
			from.onResize();
		}
			
		this.windows=new Array();
			
		//this.refreshInterval = setInterval(this.refreshCallback,this.refreshRate,this);
		
		_root.core.addNetworkComponent(this);

		onResize();
		
	}
	
	function getClass():String {
		
		return "WindowManager";
	
	}
	
	function onWindowPositionModified (id) {
		//trace(".onWindowPositionModified: "+this.isSharedLayout());
		if(!this.isSharedLayout())
			return;
		
		var win = this.getWindowById(id);
		/*if(win.getType() == "local")
			return;
		*/
		if(win.getState()!= "locked"){			
			var position = win.getPosition();
			
			this.so.data[id].percX = position.x/Math.max(Stage.width, 650);
			this.so.data[id].percY =position.y/Math.max(Stage.height, 550);
		}
	}
	
	function onWindowSizeModified (id) {
		if(!this.isSharedLayout())
		return;
		var win = this.getWindowById(id);
		
		//trace(this+".onWindowSizeModified: "+win.getState());

		/*if(win.getType() == "local")
			return;
		*/
		if(win.getState()!= "locked"){
			
			var size = win.getSize();
			//trace("onWindowSizeModified size: "+ size.width +" "+size.height);
			this.so.data[id].percW = size.width/Math.max(Stage.width, 650);
			this.so.data[id].percH =size.height/Math.max(Stage.height, 550);
		}
	}
	
	function onWindowStateModified (id) {
		if(!this.isSharedLayout())
		return;

		var win = this.getWindowById(id);
		/*if(win.getType() == "local")
			return;
		*/
		if(win.getState()!= "locked")
			this.so.data[id].state =win.getState();
	}
	
	function onWindowTransparencyModified (id) {
		if(!this.isSharedLayout())
		return;

		var win = this.getWindowById(id);

		if(win.getState()!= "locked")
			this.so.data[id].transparency =win.isTrasparent();
	}	
	
	function onConnect (con:IConnector):Void {
//		trace("WM onConnect: "+con);
		
		this.connector=con;
		
		var focusListener = new Object();
		
		focusListener.setFocus=function(obj){
			var win = this.parent.getWindowById(obj.id);
			//this.parent.doFocus(win)
		}
		
		var syncListener = new Object();
		
		syncListener.onSync = function(list){
		
			//_root.Log.print("WindowManagerClass List:",list);
				
			for (var a in list){
				//_root.Log.print(list[a]["name"],this.data[list[a]["name"]]);
				
				if(list[a]["name"]=="localID"){
					//this.parent.localID = this.data.localID;
					continue;
				}
				if(list[a]["code"]=="success"){
					//trace("WindowManager success Sync");
					
				}
				else if(list[a]["code"]=="change"){
					var win = this.data[list[a]["name"]];
					var id = win.id;
					
					if(this.parent.getWindowById(id)!=null || this.parent.getWindowById(id)!=undefined ){
						//trace("WindowManager Layout Sync: "+id);
							
												
						var absX,absY,absW,absH;
						var winL = this.parent.getWindowById(id);
						if(win.percX != undefined)
							absX = Math.max(Stage.width, 650)  * win.percX;
						if(win.percY != undefined)
							absY = Math.max(Stage.height, 550) * win.percY;
						if(win.percW != undefined)
							absW = Math.max(Stage.width, 650)  * win.percW;
						if(win.percH != undefined)
							absH = Math.max(Stage.height, 550) * win.percH;
						
						if(absX !=undefined && absY !=undefined && absX !=null && absY !=null )
							winL.moveTo(absX, absY);
		
						if(absW !=undefined && absH !=undefined && absW !=null && absH !=null )		
							winL.setSize(absW, absH);
						
						if(win.state!=undefined && win.state!="locked"){
													
							winL.lockWindow(true);
							if(win.state=="fullscreen")
								winL.setFullscreen(true);
							else if(winL.isFullscreen()==true)
								winL.setFullscreen(false);
							
							if(win.state=="minimized")
								this.parent.minimizeApplication(winL.getId());
							if(win.state=="maximized")
								this.parent.maximizeApplication(winL.getId());
							if(win.state=="restore" || win.state=="normal")
								this.parent.restoreApplication(winL.getId());
							winL.lockWindow(false);
						}
						if(win.transparency!=undefined){
							winL.lockWindow(true);
							winL.setTrasparent(win.transparency);
							winL.lockWindow(false);
						}
						this.parent.syncFocus(winL, win.focus);
						
						continue;
					}
					
					var info = _root.getUserInformation();
					trace("new APP: "+win.type+" :"+win.owner+": "+info.serverID);
					if(win.type=="local" && win.owner != info.serverID )
						continue;
				
					this.parent.receiveNewApplication(this.parent, win);
					
					var menu = this.parent.menuBar.getMenuAt(0);
					for(var i=0; menu.getItemAt(i); i++ ){
						var item = menu.getItemAt(i);
						if(item.attributes.type == "check" && item.attributes.label == win.title){
							item.attributes.localID = win.localID;
							menu.setMenuItemSelected(item, true);			
						}
					}
				}
				else if(list[a]["code"]=="delete"){
					var del = list[a]["name"];
					var win = this.parent.getWindowById(del); 
					var menu = this.parent.menuBar.getMenuAt(0);
					for(var i=0; menu.getItemAt(i); i++ ){
						var item = menu.getItemAt(i);
						if(item.attributes.type == "check" && item.attributes.label == win.getTitle()){
							menu.setMenuItemSelected(item, false);			
						}
					}
					this.parent.doCloseApplication(del);				
				}
			}
			this.parent.onResize();
		}
		
		
		this.so = this.connector.recordSharedObject("windows", this, syncListener, this, true,focusListener);
		
		this.connector.setReceiver(this.uri, "receiveNewApplication", this.receiveNewApplication, this);
		
		this.localID = 0;
		
			
		userListener = new Object();
		userListener.wm=this;
		userListener.update = function(obj:Object){
			var name = "info_"+obj.id;
			//_root.Log.print("Update user "+name,this.wm[name]);
			if(this.wm[name] != undefined)		
				this.wm.clearUsersInfo(this.wm[name]);
			this.wm.attachMovie("users_info", name, this.wm.getNextHighestDepth());
			this.wm[name].leave._visible=false;
			this.wm[name].username.text = obj.username;
			this.wm[name]._x= Math.max(Stage.width, 650)-5;
			this.wm[name]._y= 24+this.wm.users_infos.length*20;
			
			this.wm[name].clearUsersInfo = function(mc){
				var parent = mc._parent;
				clearInterval(mc.interval);
				for(var i=0; i< parent.users_infos.length; i++){
					if(parent.users_infos[i]==mc){
						parent.users_infos[i].removeMovieClip();
						parent.users_infos.splice(i,1);
					}
				}
				mc.removeMovieClip();
			}
			this.wm[name].interval = setInterval(this.wm[name].clearUsersInfo, 5000, this.wm[name]);
			this.wm.users_infos.push(this.wm[name]);
			
		}
		userListener.remove = function(obj:Object){
			var name = "info_"+obj.id;
			//_root.Log.print("Remove user "+name);
			if(this.wm[name] != undefined)		
				this.wm.clearUsersInfo(this.wm[name]);
			this.wm.attachMovie("users_info", name, this.wm.getNextHighestDepth());
			this.wm[name].enter._visible=false;
			this.wm[name].username.text = obj.username;
			this.wm[name]._x= Math.max(Stage.width, 650);
			this.wm[name]._y= 22+this.wm.users_infos.length*19;
				
			this.wm[name].clearUsersInfo = function(mc){
				var parent = mc._parent;
				clearInterval(mc.interval);
				for(var i=0; i< parent.users_infos.length; i++){
					if(parent.users_infos[i]==mc){
						parent.users_infos[i].removeMovieClip();
						parent.users_infos.splice(i,1);
					}
				}
				mc.removeMovieClip();
			}
			this.wm[name].interval = setInterval(this.wm[name].clearUsersInfo, 5000, this.wm[name]);
			this.wm.users_infos.push(this.wm[name]);
		}
		this.connector["users"].addEventListener("update", userListener);
		this.connector["users"].addEventListener("remove", userListener);
	}
	function clearUsersInfo(mc){
		var parent = mc._parent;
		clearInterval(mc.interval);
		for(var i=0; i< parent.users_infos.length; i++){
			if(parent.users_infos[i]==mc){
				parent.users_infos[i].removeMovieClip();
				parent.users_infos.splice(i,1);
			}
		}
		mc.removeMovieClip();
	}
	function onDisconnect ():Void {
		this.closeAllApplications();
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector["users"].removeEventListener("update", userListener);
		this.connector["users"].removeEventListener("remove", userListener);
		this.connector=null;
		
		for(var i=0; i< this.users_infos.length; i++){
			clearInterval(this.users_infos[i].interval);
			this.users_infos[i].removeMovieClip();
		}
		this.users_infos=new Array();
	}
	
	function onStatus ( info:Object ):Void {
		//_root.Log.print("function onStatus: ",info);
	
		switch(info["code"]){
			case "NetConnection.Connect.Success":
				this.connectionLed.setConnected(true);
				break;
			case "NetConnection.Connect.Rejected":
				this.newError("Connection REJECTED.", true);
				this.connectionLed.setConnected(false);
				break;
			case "NetConnection.Connect.Failed":
				this.newError("Connection FAILED.", true);
				this.connectionLed.setConnected(false);
				break;
			case "NetConnection.Connect.Closed":
				this.newError("Connection CLOSED.");
				this.connectionLed.setConnected(false);
				this.onDisconnect();
				break;
			case "NetConnection.Connect.AppShutdown":
				this.newError("Connection ERROR server application Shutdown.", true);
				this.connectionLed.setConnected(false);
				this.onDisconnect();
				break;
			case "NetConnection.Call.Failed":
				break;
		}
		
	}
	
	function setFullScreen (value) {
	
		if(value==true)
			Stage["displayState"] = "fullScreen";
		else
			Stage["displayState"] = "normal";
		this.onResize();
	}
	
	function doFullScreen () {
	
		if(Stage["displayState"] != "fullScreen")
			Stage["displayState"] = "fullScreen";
		else
			Stage["displayState"] = "normal";
		this.onResize();
		
	}
	
	function onResize () {
	  this.moveTo(0,0); 
	  
	  this.setSize(Math.max(Stage.width, 650), Math.max(Stage.height, 550));  
	  
	  this.width = Math.max(Stage.width, 650);
	  this.height = Math.max(Stage.height, 550);
	}
	function setFocus(mc:MovieClip){
		
		this.connector.send(this.uri,"setFocus", {id: mc.getId() });
	
	}
	function syncFocus(mc:MovieClip, f){
		var next = this.getFocusDepth();
		if(mc != null && f != null){
			mc.swapDepths(f);
			next = Math.max(this.getFocusDepth(), f+1);
		}
		this.applicationBar.swapDepths(next++);

		this.error.swapDepths(next++);

		
		//_root.Log.print("syncFocus: "+next);
		
		for(var i=0; i < this.users_infos.length; i++){
			this.users_infos[i].swapDepths(next++);
		}
	}
	function doFocus(mc:MovieClip){
		
	
		mc.swapDepths(this.getFocusDepth());

		this.applicationBar.swapDepths(this.getFocusDepth());
/*	
		this.menuBar.swapDepths(this.getFocusDepth());
	
		this.clock.swapDepths(this.getFocusDepth());
		
		this.connectionLed.swapDepths(this.getFocusDepth());
	
		this.calendar.swapDepths(this.getFocusDepth());
*/		
		this.error.swapDepths(this.getFocusDepth());


		for(var i=0; i < this.users_infos.length; i++){
			this.users_infos[i].swapDepths(this.getFocusDepth());
		}
	}
	function getFocusDepth () {
	
		return this.getNextHighestDepth();
		
	}
	
	function getContentLimits () {
	
		var limits = new Object();
		limits.left=0;
		limits.top=this.menuBar._height;
		limits.right=Math.max(Stage.width, 650);
		limits.bottom=Math.max(Stage.height, 550) - (this.applicationBar._height-2);
		return limits;
		
	}
	
	
	function newWindow (window,isLoad) {
	
		this.windows.push(window);
		
		window.setStatus("normal");
		
		window.moveTo(100,100+(10*this.windows.length));
		
		var buttonsListener = new Object();
		
		buttonsListener._parent=this;
		
		buttonsListener.applicationID=window.getId();
		
		buttonsListener.close =function(){
			//_root.Log.print("Close Event");
			this._parent.closeApplication(this.applicationID);
		}
		
		buttonsListener.minimize =function(){
			//_root.Log.print("Minimize Event");
			this._parent.minimizeApplication(this.applicationID);
		}
		
		buttonsListener.maximize =function(){
			//_root.Log.print("Maximize Event");
			this._parent.maximizeApplication(this.applicationID);		
		}
		
		buttonsListener.restore =function(){
			//_root.Log.print("Restore Event");
			this._parent.restoreApplication(this.applicationID);		
		}
		
		window.addEventListener("close",buttonsListener);
		
		window.addEventListener("minimize",buttonsListener);
		
		window.addEventListener("maximize",buttonsListener);
		
		window.addEventListener("restore",buttonsListener);
		
		window.setFocus();
		
	}
	
	function getWindowById (id){
		
		return this["win_"+id];
		
	}					
	
	function getWindowByContentPath (contentPath){
		
		for(var i=0; i<windows.length; i++){
			if(windows[i].getContentPath()==contentPath){
				return windows[i];
			}	
		}
		
	}
	function shareNewWindow(win, param){
		_root.Log.print("shareNewWindow",param.application);
		var id = win.getId();
		
		var position = win.getPosition();
		
		var s_win = new Object();
		s_win.percX = position.x/Math.max(Stage.width, 650);
		s_win.percY =position.y/Math.max(Stage.height, 550);

		var size = win.getSize();
		s_win.percW = size.width/Math.max(Stage.width, 650);
		s_win.percH =size.height/Math.max(Stage.height, 550);
		
		s_win.state =win.getState();

		for(var a in param)
			s_win[a] = param[a];
		this.so.data[id] = s_win;
	}
	
	function setSharedLayout(value){
		
		this.sharedLayout = value;
		for(var i=0; i< this.windows.length;i++){
			var id = this.windows[i].getId();
			var win = this.windows[i];

			if(win.getState()!= "locked"){			
				var position = win.getPosition();
				
				this.so.data[id].percX = position.x/Math.max(Stage.width, 650);
				this.so.data[id].percY =position.y/Math.max(Stage.height, 550);
		
				var size = win.getSize();
				
				this.so.data[id].percW = size.width/Math.max(Stage.width, 650);
				this.so.data[id].percH =size.height/Math.max(Stage.height, 550);
				
				this.so.data[id].state =win.getState();
			}
		}
		onResize();
	}
	function isSharedLayout(){
		return this.sharedLayout;
	}
	function restoreApplication (id){
		
		var win = this.getWindowById(id);
		
		win.setState("normal");
	
		var size = win.getLastSize();
		
		var pos = win.getLastPosition();
		
		//_root.Log.print("Last", size);
			
		win.show();
		
		if(pos.x != undefined || pos.y != undefined || !isNaN(pos.x) || !isNaN(pos.y) )
			win.moveTo(pos.x,pos.y);
		if(size.width != undefined || size.height != undefined || !isNaN(size.width) || !isNaN(size.height) )
			win.setSize(size.width, size.height);	
	}					
	
	function minimizeApplication (id){
	
		var win = this.getWindowById(id);
	
		win.setState("minimized");
		
		win.hide();
		
	}
	
	function trasparentApplication (id){
		
		var win = this.getWindowById(id);
		
		win.setTrasparent(!win.isTrasparent());
		
		var size = win.getSize();
		
		win.setSize(size.width, size.height);
		
	}
	
	function maximizeApplication (id){
		
		var win = this.getWindowById(id);
		
		win.setState("maximized");
		
		var limits = this.getContentLimits();
		
		win.moveTo(limits.left,limits.top);
		
		win.setSize(limits.right-limits.left,limits.bottom-limits.top);
	
		win.show();
	}					
	function closeAllApplications (){
		for(var i=0; i<this.windows.length; i++){
			if( this.windows[i]!= undefined && this.windows[i]!= null){
				var id = this.windows[i].getId();
				var win = this.getWindowById(id);
				
				var menu = this.menuBar.getMenuAt(0);
				for(var j=0; menu.getItemAt(j); j++ ){
					var item = menu.getItemAt(j);
			
					if(item.attributes.type == "check" && item.attributes.label == win.getTitle() && item.attributes.selected){
						menu.setMenuItemSelected(item, false);			
					}
				}
				win.close();
				this["win_"+id].removeMovieClip();
			}
		}
		this.applicationBar.removeAll();
		this.applicationBar.__menuDataProvider= undefined;
	}
	function closeApplicationByLocalID (id){
		for(var i=0; i<this.windows.length; i++){
			if( this.windows[i]!= undefined && this.windows[i]!= null && this.windows[i].getLocalID()==id ){
				this.closeApplication(this.windows[i].getId());
			}
		}
	}
	
	function getSize (){
		var size:Size = new Size();
		size.width = Math.max(Stage.width, 650);
		size.height = Math.max(Stage.height, 550);
		return size;
	}
	
	function closeApplication (id){
	
		this.connector.send(this.uri,"closeApplication", {id: id });
		
	}
	function doCloseApplication (id){
	
		var win = this.getWindowById(id);
		
		
		//trace("Closing: "+id +" where win: "+win+" id: "+win.getId());
		
		var menu = this.menuBar.getMenuAt(0);
		for(var i=0; menu.getItemAt(i); i++ ){
			var item = menu.getItemAt(i);
	
			if(item.attributes.type == "check" && item.attributes.label == win.getTitle() && item.attributes.selected){
				menu.setMenuItemSelected(item, false);			
			}
			
		}
		
		this.applicationBar.removeAll();
		
		this.applicationBar.__menuDataProvider= undefined;
		
		for(var i=0; i<this.windows.length; i++){
			
			if(this.windows[i].getId()!=id && this.windows[i].getId()!=win.getId() && this.windows[i].getId()!=undefined && this.windows[i]!= undefined && this.windows[i]!= null){
				
				var newMenu = this.applicationBar.addMenu(this.windows[i].getTitle());
				newMenu.addMenuItem({label:"Application: "+this.windows[i].getId()});
				newMenu.addMenuItem({label:"Ripristina", instanceName:"restore"});
				newMenu.addMenuItem({label:"Minimizza", instanceName:"minimize"});
				newMenu.addMenuItem({label:"Massimizza", instanceName:"maximize"});
				newMenu.addMenuItem({label:"Trasparent", instanceName:"trasparent"});
				newMenu.addMenuItem({type:"separator"});
				newMenu.addMenuItem({label:"Chiudi", instanceName:"close"});
				newMenu.addMenuItem({type:"separator"});
				newMenu.addMenuItem({label:"Chiudi Menu", instanceName:"closeMenu"});
				
				menuListener = this.newMenuListener(newMenu, this.windows[i].getId());
					
				newMenu.addEventListener("change",menuListener);
				newMenu.addEventListener("menuShow",menuListener);
		
				//trace("Adding: "+this.windows[i].getId() +" where win: "+this.windows[i]+" id: "+this.windows[i].getMenu().dataProvider);
				
				
				this.windows[i].setMenu(newMenu);
			}
		}
		
		win.close();

		this["win_"+id].removeMovieClip();		
	}					
	
	function newMenuListener(newMenu, id) {
		
		var menuListener = new Object();
		menuListener._parent=this;
		menuListener.applicationID=id;
		menuListener.base=this.applicationBar;
		menuListener.owner=newMenu;
		menuListener.owner.clicked=false;	
		menuListener.menuShow =function(evt){
			if(this.owner.clicked==false)
				this.intervalTimer = setInterval(this.interval,100,this);
			this.owner.clicked=false;
			var win = this._parent.getWindowById(this.applicationID);
			win.setFocus();
		}
		
		menuListener.interval =function(from){
			clearInterval(from.intervalTimer);
			from.owner._y=from.base._y-from.owner.height;
		}
		
		menuListener.change =function(evt){
			var info = _root.getUserInformation();
			if(info.role!="poweruser" && info.star!="poweruser")
				return;
			
			var menu = evt.menu;
			var item = evt.menuItem;
			var label = item.attributes.label;
			var instance = item.attributes.instanceName;
			
			if(instance=="restore"){
				this._parent.restoreApplication(this.applicationID);					
			}
			else if(instance=="minimize"){
				this._parent.minimizeApplication(this.applicationID);					
			}
			else if(instance=="maximize"){
				this._parent.maximizeApplication(this.applicationID);					
			}
			else if(instance=="close"){
				this._parent.closeApplication(this.applicationID);					
			}
			else if(instance=="trasparent"){
				this._parent.trasparentApplication(this.applicationID);					
			}
			else if(instance=="closeMenu"){
				menu.hide();					
			}
			else{
				//trace(label);
			}
		}
		return menuListener;
	}
	
	function requestNewApplication (tit, app, param, contentType, type) {
		//trace("requestNewApplication: "+this.connector.isConnected());
		if(this.connector==undefined || this.connector==null || this.connector.isConnected()==false){
			this.newError("Nessuna connessione.\nImpossibile aprire nuove applicazioni senza prima aver effettuato la connessione", true);
			return false;
		}
		else{
			this.localID = this.so.data.localID+1;
			this.connector.send(this.uri,"newApplication", {title: tit, application: app, localID:this.localID, param:param, contentType:contentType, type:type});
			this.so.data.localID = this.localID;
		}
		return this.localID;
			
	}
	
	function receiveNewApplication (to , param) {
	
		to.newApplication(param.id, param.title, param.application, param.localID, param.param,  param.contentType, param.type);
		var win = to.getWindowById(param.id);
		//_root.Log.print(win+" - receiveNewApplication: ", param);
		if(param.percX!=undefined && param.percY!= undefined)
			win.moveTo(param.percX*this.width, param.percY*this.height);
		if(param.percW!=undefined && param.percH!= undefined){
			win.setSize(param.percW*this.width, param.percH*this.height);
		}else{
			_root.Log.print("set 100x100");
			win.setSize(100, 100);
		}
		var completeListener = new Object();
		completeListener.wm = to;
		completeListener.win = win;
		completeListener.complete = function() {
			this.win.refreshWindow();
			this.wm.syncFocus(null,null);
		};
		win.addEventListener("complete", completeListener);
		
		if(param.state!=undefined)
			win.setState(param.state);
		
		to.shareNewWindow(win, param);
		
		_root.Log.print('Maximize: '+param.param['maximize']);
		if (param.param['maximize'] == 'true')
		{
			_root.Log.print("Start maximize for app_id "+param.id);
			to.maximizeApplication(param.id);
		}
	}
	
	function newApplication (id, tit, app, localID, param, contentType, type) {
	
		this.attachMovie("RWindow", "win_"+id,this.getNextHighestDepth(),{id: id, title: tit, contentPath:app, contentType:contentType, param:param}); 
		
		var newMenu = this.applicationBar.addMenu(tit);
		newMenu.addMenuItem({label:"Application: "+id});
		newMenu.addMenuItem({label:"Ripristina", instanceName:"restore"});
		newMenu.addMenuItem({label:"Minimizza", instanceName:"minimize"});
		newMenu.addMenuItem({label:"Massimizza", instanceName:"maximize"});
		newMenu.addMenuItem({label:"Trasparent", instanceName:"trasparent"});
		newMenu.addMenuItem({type:"separator"});
		newMenu.addMenuItem({label:"Chiudi", instanceName:"close"});
		newMenu.addMenuItem({type:"separator"});
		newMenu.addMenuItem({label:"Chiudi Menu", instanceName:"closeMenu"});
		
		var menuListener = this.newMenuListener(newMenu, id);
	
		newMenu.addEventListener("change",menuListener);
		
		newMenu.addEventListener("menuShow",menuListener);
		
		this["win_"+id].setId(id);
		
		this["win_"+id].setLocalID(localID);
		
		this["win_"+id].setMenu(newMenu);
		
		this["win_"+id].setType(type);
		
		this.newWindow(this["win_"+id]);	
		
		this.syncFocus(null,null);
		
		return id;
	}

	function getURI ():String {
			
			return this.uri;
			
	}
	function setMenuXML (xmlMenu, app, emb, ext) {
	
		this.menuDP = new XML();
		this.appDP = app;
		this.emb = emb;
		this.ext = ext;
		this.menuDP.ignoreWhite = true;
		this.menuDP._parent=this;
		this.menuDP.load(xmlMenu);
		this.menuDP.onLoad = this.loadMenu;	
	}
	
	function loadMenu (success){
	
		if(success!=true){
			this._parent.newError("Error Loading  XML MenuFile.\nPlease try to restart the application.", true);
			return;
		}
		if(this._parent.emb != undefined){
			for(var i=0; this._parent.emb[i]; i++){
				var item:XMLNode = this._parent.menuDP.createElement("menuitem");
				item.attributes.label = this._parent.emb[i].label;
				item.attributes.instanceName = this._parent.emb[i].contentPath;
				item.attributes.param = this._parent.emb[i].param;
				item.attributes.contentType = "embedded";
				this._parent.menuDP.firstChild.appendChild(item);
				//trace(this._parent.menuDP);
			}
		}
		if(this._parent.ext != undefined){
			for(var i=0; this._parent.ext[i]; i++){
				var item:XMLNode = this._parent.menuDP.createElement("menuitem");
				item.attributes.label = this._parent.ext[i].label;
				item.attributes.instanceName = this._parent.ext[i].URL;
				item.attributes.param = this._parent.ext[i].param;
				item.attributes.contentType = "external";
				this._parent.menuDP.firstChild.appendChild(item);
			}
		}
		if(this._parent.appDP != undefined){
			for(var i=0; this._parent.appDP[i]; i++){
				var item:XMLNode = this._parent.menuDP.createElement("menuitem");
				item.attributes.label = this._parent.appDP[i]["TITLE"];
				item.attributes.instanceName = this._parent.appDP[i]["CLASS"];	
				item.attributes.param = this._parent.appDP[i].param;
				item.attributes.contentType = "preloaded";
				this._parent.menuDP.firstChild.appendChild(item);
			}
		}
		
		this._parent.menuBar.dataProvider = this._parent.menuDP;

		
		var listen = new Object();
		listen._parent=this._parent;
		listen.change =function(evt){
			var item = evt.menuItem;
			var i= item;
			while( i.parentNode.parentNode.parentNode != undefined )
				i=i.parentNode;
	
			menu = i.parentNode;
			
	
			var instance = item.attributes.instanceName;
			var label = item.attributes.label;
			var action = item.attributes.action;
			var param = item.attributes.param;
			var fun = item.attributes.callback;
			var object = item.attributes.object;
			var contentType = item.attributes.contentType;
			
			if(action==undefined || action=="application"){
				var info = _root.getUserInformation();
				if(info.role != "poweruser"){
					this._parent.newError("Are You connected?\nHave You permissions to open applications?", true);
					return;
				}				
				var p = param.split("&");
				var outParam = new Object();
				for(var i=0; i<p.length; i++ ){
					var k0 = p[i].substr(0,p[i].indexOf("="));
					var k1 =p[i].substr(p[i].indexOf("=")+1,p[i].length);
					//_root.Log.print(k0+": "+k1);
					outParam[k0] = k1;
				}
				if(item.attributes.type=="check"){
					if(item.attributes.selected==true){
						var id = this._parent.requestNewApplication(label, instance, outParam, contentType);
						item.attributes.localID = id;
						evt.menu.setMenuItemSelected(item,true);
					}
					else{
						this._parent.closeApplicationByLocalID(item.attributes.localID);
						evt.menu.setMenuItemSelected(item,false);
					}
				}			
				else{
					this._parent.requestNewApplication(label, instance, outParam, contentType);
				}
			}
			else if(action=="function"){
				if(object==undefined)
					this._parent[fun](param);
				else
					this._parent[object][fun](param);			
			}			
		}
		for(var i=0; this._parent.menuBar.getMenuAt(i);i++){
			var menu = this._parent.menuBar.getMenuAt(i);
			menu.addEventListener("change",listen);
		}
	}
	
	function moveTo(x, y) {
		this._x=x;
		this._y=y;
	}
	
	function setSize(newWidth, newHeight) {
		var newWindowWidth;
		var newWindowHeight;
		
		if(this.fullscreenWindow != undefined &&  this.fullscreenWindow != null && this.fullscreenWindow >= 0 && this.fullscreenWindow < this.windows.length){
			
			if(this.windows[this.fullscreenWindow].getState() != "fullscreen"){
				this.fullscreenWindow = null;
			}
			else{
				this.windows[this.fullscreenWindow].moveTo(0,0);
				this.windows[this.fullscreenWindow].setSize(newWidth, newHeight);
				return;
			}
		}
		
		this.clear();
		if (!this.isSharedLayout()) {
			menuBar.setStyle("themeColor","haloBlue");
			applicationBar.setStyle("themeColor","haloBlue");
			this.beginFill(this.backgroundColor, this.backgroundTrasparency);
		}
		else{
			
			menuBar.setStyle("themeColor","haloGreen");
			applicationBar.setStyle("themeColor","haloGreen");
		}
		this.lineStyle(1, this.backgroundColor, this.backgroundTrasparency, true);
		this.moveTo(0, 0);
		this.lineTo(0, Stage.height);
		this.lineTo(Stage.width-1, Stage.height);
		this.lineTo(Stage.width-1,0);
		this.lineTo(0, 0);
		if (!this.isSharedLayout()) {
			this.endFill();
		}
		
		
		for(var i=0; i< this.windows.length;i++){
			var win = this.so.data[this.windows[i].getId()];
			
			if(this.windows[i]!=null || this.windows[i]!=undefined ){
				if(this.windows[i].getState() == "locked")
					continue;
				if(this.windows[i].getState() == "minimized"){
					this.windows[i].hide();
					continue;
				}
				if(this.windows[i].getState() == "maximized"){
					var limits = this.getContentLimits();
					this.windows[i].moveTo(limits.left+1,limits.top);
					this.windows[i].setSize(limits.right-(limits.left),limits.bottom-limits.top);
					
					continue;
				}
				if(this.windows[i].getState() == "fullscreen"){
					this.fullscreenWindow = i;
					this.windows[i].moveTo(0,0);
					this.windows[i].setSize(newWidth, newHeight);
					this.windows[i].swapDepths(this.getNextHighestDepth());
					return;
				}
				var percX;
				var percY;
				var percW;
				var percH;
				if(win!=null || win!=undefined ){
					if(win.percX == undefined || win.percY == undefined)
						win.percX = win.percY = 0;
					if(win.percW == undefined || win.percH == undefined){
						win.percW = win.percH = 0.5;
					}				
					percX = win.percX;
					percY = win.percY;
					percW = win.percW;
					percH = win.percH;
				}else{
					var pos = this.windows[i].getPosition();
					var size = this.windows[i].getSize();
					percX = pos.x/newWidth;
					percY = pos.y/newHeight;
					percW = size.width/newWidth;
					percH = size.height/newHeight;
				}
				var absX = newWidth  * percX;
				var absY = newHeight * percY;
				var absW = newWidth  * percW;
				var absH = newHeight * percH;
	
				/*Validazione grandezze*/
				if(absW > newWidth)
					absW = newWidth;
				if(absH > (newHeight-(this.applicationBar._height+this.menuBar._height)))
					absH = (newHeight-(this.applicationBar._height+this.menuBar._height));
				
				if((absW+absX) > newWidth){
					absX-=(this.width-newWidth);
					absX=(absX<0?0:absX);
				}
				
				if((absH+absY) > (newHeight-(this.applicationBar._height+this.menuBar._height))){
					absY-=(this.height-newHeight);
					absY=(absY<this.menuBar._height?this.menuBar._height:absY);
				}
				if(absY < (this.menuBar._height+this.menuBar._y))
					absY = (this.menuBar._height+this.menuBar._y);
				
				this.windows[i].moveTo(absX, absY);
				
				this.windows[i].setSize(absW, absH);
	
			}
	
		}
		this.applicationBar._y=	newHeight-this.applicationBar._height;
	
		this.applicationBar.setSize(newWidth, 22);
		
		this.menuBar.setSize(newWidth, 22);
		
		this.connectionLed._x=(newWidth-this.connectionLed._width)-6;
	
		this.calendar._x=(this.connectionLed._x-this.calendar._width)-5;
		
		this.clock._x=(this.calendar._x-this.clock._width)-7;
		
		this.error._x=(this.clock._x-this.error._width)+35;
	
	
	}
	
	function close() {
		for(var i=0; i< this.windows.length;i++){
				this.closeApplication(this.windows[i].getId());
		}
		this.setVisible(false);
	}
	
	function newError(err, popup, level, id) {
		_root.Log.print("Error: "+err+" vis:  "+popup);
		this.error.newError(err,popup, level, id);
	}
	
	function setVisible(value:Boolean) {
		this._visible = value;
	}
}