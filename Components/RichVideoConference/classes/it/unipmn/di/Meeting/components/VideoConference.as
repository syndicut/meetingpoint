import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;
import it.unipmn.di.Meeting.Utils.Size;
import flash.media.Video;
import mx.controls.Button;
import flash.net.FileReference;
	
class it.unipmn.di.Meeting.components.VideoConference extends MovieClip implements IClientComponent, IUIWindowComponent{

	
	var soName:String	   = "list_av";
	var uri:String
	var userID:String
	var name:String
	var video:Array
	var hasFocus:Boolean
	var local_cam:Camera
	var local_mic:Microphone
	var local_ns:NetStream
	var connector:IConnector
	var so:SharedObject
	var button_bar:MovieClip
	var enterButton:Button
	var movie:MovieClip
	var borders:MovieClip
	var _parent:MovieClip
	var vidWidth:Number     = 240;
	var vidHeight:Number    = 180;
	var vidBandwidth:Number = 0;
	var vidQuality:Number   = 0;
	var vidFps:Number       = 15;
	var keyFps:Number       = 5;
	var micRate:Number      = 22;
	var micGain:Number      = 50;
	var micSilence:Number   = 10;
	var micTimeout:Number   = 2000;
	var bufferTime:Number   = 2;
	var source:String   	= "webcam";
	var imageUrl:String;
	
	function getURI():String {
			
			return this.uri;
			
	}
	
		
	function replace(what, find, replace, iReplaces):String{
	
		var counter = 0;
		var i = 0;
	
		var string = what;
	
		while (counter<string.length) {
	
			var start = string.indexOf(find, counter);
	
			if (start == -1) {
	
				break;
	
			} else {
	
				var before = string.substr(0, start);
	
				var after = string.substr(start+find.length, string.length);
	
				string = before+replace+after;
	
				counter = before.length+replace.length;
	
				i++;
	
				if (i == iReplaces) counter = string.length;
	
			}
	
		}
	
		return string;
	
	}

	
	function VideoConference(clip:MovieClip) {
		super();
		
		this.movie._parent = this;
		this.name = (this._name == null ? "_DEFAULT_" : this._name);

		this.button_bar._x = this.button_bar._width/2;
		this.enterButton._x = 0;
		enterButton._visible=false;
		this.uri="VideoConference";
		
		this.video= new Array()
		
		_root.core.addNetworkComponent(this);
		
		this.button_bar._visible = false;
		
		var style = new Object();
		style.backgroundColor = 0x000000;
		this._parent.setWindowStyle(style);
		
		var webcam_listener = new Object();
		webcam_listener.parent = this;
		webcam_listener.change= function(){
			_root.Log.print("Webcam have changed configuration");		
			this.parent.updateAVsettings();
		}
		
		var mic_listener = new Object();
		mic_listener.parent = this;
		mic_listener.change= function(){
			_root.Log.print("Microphone have changed configuration");			
			this.parent.updateAVsettings();
		}
		_root.webcamManager.addListener(webcam_listener);
		_root.microphoneManager.addListener(mic_listener);
		
		this.imageUrl = unescape(this.imageUrl);
		
		var info = _root.getUserInformation();
		//_root.Log.print("User info:", info);
		if(info.userid!=undefined){
			this.imageUrl += "&uid="+info.userid;
		}
	}
	function onDisconnect():Void{
	}
	function onConnect(con:IConnector):Void {
		//_root.Log.print("VideoConference onConnect: ");
	
		this.connector = con;	
		
		this.connector.setReceiver(this.uri, "setUserID", this.setUserID, this);

		var listener = new Object();
		listener.onSync = function(list){		
			//_root.Log.print("VideoConference.onSync: ", list);
			for (var a in list){
				if(list[a]["code"]=="change" || list[a]["code"]=="success"){
					if(this["parent"].userID != null &&this["parent"].userID == list[a]["name"]){
						if(this["parent"]["movie"][list[a]["name"]]!=undefined)
							this["parent"].onChangeLocalVideo(list[a]["name"], this["data"][list[a]["name"]]);
						else
							this["parent"].newLocalVideo(list[a]["name"], this["data"][list[a]["name"]]);
					}
					else{
						if(this["parent"]["movie"][list[a]["name"]]!=undefined)
							this["parent"].onChangeVideo(list[a]["name"], this["data"][list[a]["name"]]);
						else
							this["parent"].newVideo(list[a]["name"], this["data"][list[a]["name"]]);
					}
				}
				else if(list[a]["code"]=="delete"){
					this["parent"].delVideo(list[a]["name"]);
				}
			}
		}
		
		this.so = this.connector.recordSharedObject("list_av", this, listener, this, false);

		this.connector.send(this.uri,"helo", { });
		
		
	}

	
	function onStatus(info:Object):Void{
	
	}
	
	function getClass():String {
		
		return "VideoConference";
		
	}
	
	function newVideo(name, user) {
		//trace("newVideo: "+name);
	
		//trace("type: "+user.type);
		this.movie.attachMovie("AV_slot", name, this.movie.getNextHighestDepth());
		//trace("AV_slot: "+ this.movie[name]);

		
		var newVideo = this.movie[name];

		newVideo.user = user.name;
		newVideo.name = name;
		newVideo.bar.elements.textField.name.text = user.name;
		
		newVideo.type = user.type;
		
		newVideo.bar.elements.camera.onRelease = function(){
			//trace("Camera pressed");
			if(this._currentFrame==1){
				this.gotoAndStop(2);
			}
			else{
				this.gotoAndStop(1);
			}
			this._parent._parent._parent._parent._parent.toggleVideo(this._parent._parent._parent.name);
		};
		newVideo.bar.elements.sound.onRelease = function(){
			//trace("Sound pressed: "+this._parent._parent._parent+" : "+this._parent._parent._parent.name);
			
			if(this._currentFrame==1){
				this.gotoAndStop(2);
			}
			else{
				this.gotoAndStop(1);
			}
			this._parent._parent._parent._parent._parent.toggleAudio(this._parent._parent._parent.name);
		};
		
		
	
		var listener = new Object();
		listener.name = name;
		listener.onStatus=function(info){

		}

		newVideo.ns = this.connector.recordNetStream(name, this, listener, this);
		
		newVideo.ns.play(this.uri+"."+name);
	
		newVideo.video.attachAudio(newVideo.ns);

		newVideo.hasAudio = true;
	
		
		
		
		if(user.type=="webcam"){

			newVideo.image_slot.img.unloadMovie();

			newVideo.image_slot._visible=false;
		  
			newVideo.hasVideo= true;
		
			newVideo.video.attachVideo(newVideo.ns);
	
		}
		else{
			newVideo.hasImage = true;
			newVideo.img_url = user.img_url;
			
			newVideo.video.attachVideo(null);
			newVideo.image_slot._visible=true;
			newVideo.image_slot.createEmptyMovieClip("img", 1);
			var mcLoader:MovieClipLoader = new MovieClipLoader();
			var listener:Object = new Object();
			listener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
				 //trace(target + ".onLoadProgress with " + bytesLoaded + " bytes of " + bytesTotal);
				target._parent.progress_txt.text = _root.stringsManager.get("VC_PROGRESS") + " " + Math.round(bytesLoaded / bytesTotal)+" %";
			}
			listener.onLoadComplete = function(target:MovieClip, httpStatus:Number):Void  {
				target._parent.progress_txt._visible= false;
			}
			listener.onLoadInit = function(target:MovieClip):Void {
				//trace(target + ".onLoadInit");
				target._width = 240;
				target._height = 180;
			}

			mcLoader.addListener(listener);
			
			mcLoader.loadClip(newVideo.img_url, newVideo.image_slot.img);
			
		}	
		this.video.push(newVideo);
		
		
		this._parent.refreshWindow();
	
	}
	function onChangeVideo(name, user){
		//trace("onChangeVideo: "+name);
				var lvideo;
				
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				lvideo = this.video[i];
				break;
			}
		}
		
		lvideo.type = user.type;
		
		if(user.type=="webcam"){
			
			lvideo.image_slot._visible=false;
		  
		  	lvideo.image_slot.img.unloadMovie();
	
			
			lvideo.video.attachVideo(lvideo.ns);
			
			lvideo.ns.play(this.uri+"."+name);
	
			lvideo.hasAudio = true;
		
			lvideo.hasVideo= true;
		
			
		}
		else{
			lvideo.hasImage = true;
			lvideo.img_url = user.img_url;
			
			lvideo.image_slot._visible=true;
			lvideo.video.attachVideo(null);
			
			lvideo.image_slot.createEmptyMovieClip("img", 1);
			var mcLoader:MovieClipLoader = new MovieClipLoader();
			var listener:Object = new Object();
			listener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
				 //trace(target + ".onLoadProgress with " + bytesLoaded + " bytes of " + bytesTotal);
				target._parent.progress_txt.text = _root.stringsManager.get("VC_PROGRESS") + " " + Math.round(bytesLoaded / bytesTotal)+" %";
			}
			listener.onLoadInit = function(target:MovieClip):Void {
				//trace(target + ".onLoadInit");
				target._width = 240;
				target._height = 180;
			}

			mcLoader.addListener(listener);
			
			mcLoader.loadClip(lvideo.img_url, lvideo.image_slot.img);
			
		}	
		
	}
	
	function onChangeLocalVideo(name, user){
		
		//trace("onChangeLocalVideo: "+name);
		var lvideo;
				
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				lvideo = this.video[i];
				break;
			}
		}
		lvideo.type = user.type;
		
		if(user.type=="webcam"){
				
			this.button_bar.sendButton.icon = "webcam_delete.png"
			this.button_bar.sendButton.label = _root.stringsManager.get("VC_BUTTON_SEND");
			this.button_bar.sendButton.enabled = true;
			lvideo.image_slot._visible=false;
		  	lvideo.image_slot.img.unloadMovie();
		  	
			lvideo.ns=this.local_ns;
			lvideo.hasVideo= false;
		}
		else{
			
			this.button_bar.sendButton.icon = "webcam_delete.png"
			this.button_bar.sendButton.label = _root.stringsManager.get("VC_BUTTON_SEND");
			this.button_bar.sendButton.enabled = false;
			lvideo.hasImage = true;
			lvideo.img_url = user.img_url;
			//trace("LocalUserImage: "+user.img_url);
			lvideo.video.attachVideo(null);
			local_ns.attachVideo(null);
			lvideo.image_slot._visible=true;
			lvideo.image_slot.createEmptyMovieClip("img", 1);
			var mcLoader:MovieClipLoader = new MovieClipLoader();
			var listener:Object = new Object();
			listener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
				 //trace(target + ".onLoadProgress with " + bytesLoaded + " bytes of " + bytesTotal);
				target._parent.progress_txt.text = _root.stringsManager.get("VC_PROGRESS") + " " + Math.round(bytesLoaded / bytesTotal)+" %";
			}
			listener.onLoadInit = function(target:MovieClip):Void {
				//trace(target + ".onLoadInit");
				target._width = 240;
				target._height = 180;
			}
			listener.onLoadError = function(target_mc:MovieClip, errorCode:String, httpStatus:Number) {
				 //trace(">> listener.onLoadError()");
				 //trace(">> ==========================");
				 //trace(">> errorCode: " + errorCode);
				 //trace(">> httpStatus: " + httpStatus);
			}
			listener.onLoadComplete = function(target_mc:MovieClip, httpStatus:Number):Void {
				 //trace(">> loadListener.onLoadComplete()");
				 //trace(">> =============================");
				 //trace(">> target_mc._width: " + target_mc._width); // 0
				 //trace(">> httpStatus: " + httpStatus);
			}
			mcLoader.addListener(listener);
			var ret = mcLoader.loadClip(lvideo.img_url, lvideo.image_slot.img);
			//trace("loadClip ret: "+ret);
		}
	}
	
	function uploadFile(){
		
		var allTypes:Array = new Array();
		var imageTypes:Object = new Object();
		imageTypes.description = "Images Files (*.jpg, *.jpeg, *.gif, *.png)";
		imageTypes.extension = "*.jpg; *.jpeg; *.gif; *.png";
		allTypes.push(imageTypes);
			
		var swfTypes:Object = new Object();
		swfTypes.description = "Static SWF Files (*.swf)";
		swfTypes.extension = "*.swf";
		allTypes.push(swfTypes);
		var callback = new Object();
			
		var callback:Object = new Object(); 
		
		callback.parent = this;
		
		callback.onCancel = function(file:FileReference):Void {
			//trace("onCancel");
		}
		
		callback.onOpen = function(file:FileReference):Void {
			//trace("onOpen: " + file.name);
		}
		
		callback.onProgress = function(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
			//trace("onProgress with bytesLoaded: " + bytesLoaded + " bytesTotal: " + bytesTotal);
		}
		
		callback.onComplete = function(file:FileReference):Void {
			//trace("onComplete: " + file.name);
		}

		callback.onHTTPError = function(file:FileReference):Void {
			//trace("onHTTPError: " + file.name);
			
		}
		
		callback.onIOError = function(file:FileReference):Void {
			//trace("onIOError: " + file.name);
			
		}
		
		callback.onSecurityError = function(file:FileReference, errorString:String):Void {
			//trace("onSecurityError: " + file.name + " errorString: " + errorString);
			
		}
		_root.core.uploadFile(allTypes, this.imageUrl+"&action=upload&r="+Math.round(Math.random()*10000), callback,this);
	}
	
	function newLocalVideo(name, user) {
		//trace("newLocalVideo: "+name);
		
		this.button_bar.sendButton.icon = "webcam_delete.png"
		this.button_bar.sendButton.label = _root.stringsManager.get("VC_BUTTON_SEND");

		//trace(this +" " + this.movie +" User: "+user+" "+user.name+" "+user.type+" "+user.img_url);
		
		this.movie.attachMovie("AV_slot", name, this.movie.getNextHighestDepth());

		this.sendVideo(name);
		
		var newVideo = this.movie[name];

		newVideo.user = user.name;
		newVideo.name = name;
		
		newVideo.bar.elements.textField.name.text = user.name + " " + _root.stringsManager.get("VC_LABEL_YOU");
		newVideo.bar.elements.textField.name.textColor = 0xff0000;
		newVideo.bar.elements.camera._visible = false;
		newVideo.bar.elements.sound._visible = false;
		
		newVideo.type = user.type;
		newVideo.image_slot._visible=false;
		
		newVideo.hasVideo= false;
		newVideo.hasAudio= false;
		newVideo.hasImage= false;
		this.video.push(newVideo);
		
		this._parent.refreshWindow();

	}
	
	function toggleLocalAudio() {
		var name = this.userID;
		//trace("toggleAudio("+name+")");
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				this.video[i].hasAudio = !this.video[i].hasAudio;
				this.video[i].ns.attachAudio((this.video[i].hasAudio)?this.local_mic:null);
			}
		}	
	}
	
	function toggleLocalVideo() {
		var name = this.userID;
		//trace("toggleVideo("+name+")");
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				this.video[i].hasVideo = !this.video[i].hasVideo;
				this.video[i].ns.attachVideo((this.video[i].hasVideo)?this.local_cam:null);
				this.video[i].video.attachVideo((this.video[i].hasVideo)?this.local_cam:null);
			}
		}	
	}
	
	function toggleAudio(name) {
		//trace("toggleAudio("+name+")");
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				this.video[i].hasAudio = !this.video[i].hasAudio;
				this.video[i].ns.receiveAudio(this.video[i].hasAudio);
			}
		}	
	}
	
	function toggleVideo(name) {
		//trace("toggleVideo("+name+")");
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				this.video[i].hasVideo = !this.video[i].hasVideo;
				this.video[i].ns.receiveVideo(this.video[i].hasVideo);
			}
		}	
	}
	
	function delVideo(name) {
		
		//trace("delVideo: "+name);
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == name){
				this.video.splice(i,1);
			}
		}
		if(this.userID == name)
			this.local_ns.close();
		this.movie[name].close();
		this.movie[name].ns.close();
		this.movie[name].video.attachAudio(null);
		this.movie[name].video.attachVideo(null);
		this.movie[name].video.clear();
		
		this.movie[name].imgage_slot.img.unloadMovie();
		
		this.movie[name].imgage_slot.img.removeMovieClip();
		this.movie[name].imgage_slot.unloadMovie();
		
		this.movie[name].imgage_slot.removeMovieClip();
		this.movie[name].unloadMovie();
		this.movie[name].removeMovieClip();
		
		this._parent.refreshWindow();
	}
	
	function close():Void {
		for (var i=0; i < this.video.length; i++)
			this.delVideo(this.video[i].name);
		delete this.video;
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		this.movie.unloadMovie();
		this.unloadMovie();
	}

	function setAudioVideo(){
		this.local_cam = Camera.get();
		this.local_mic = Microphone.get();
		updateAVsettings();
	}
	function updateAVsettings(){
		var rate = _root.microphoneManager.getRate();
		this.local_mic.setRate(rate);
		this.local_mic.setGain(this.micGain);
		this.local_mic.setSilenceLevel(this.micSilence,this.micTimeout);
		var fps = _root.webcamManager.getFPS();
		var size = _root.webcamManager.getResolution();
		this.vidQuality = _root.webcamManager.getQuality();
		this.vidBandwidth = _root.webcamManager.getBandwidth();
		this.local_cam.setMode(size.width, size.height, fps);
		this.local_cam.setQuality(this.vidBandwidth, this.vidQuality);
		this.local_cam.setKeyFrameInterval(this.keyFps);
		
	}
	
	function sendVideo( newID ) {

		setAudioVideo();
		
		var listener = new Object();
		listener.onStatus=function(info){
			//trace("local_ns NetStream.onStatus: "+info);
		}
		if(this.local_ns == null || this.local_ns == undefined)
			this.local_ns = this.connector.recordNetStream(newID, this, listener, this);
		this.local_ns.setBufferTime(this.bufferTime);

		this.local_ns.attachAudio(null);
		this.local_ns.attachVideo(null);

		this.local_ns.publish(this.uri+"."+newID);

	}
	
	function setUserID (from, newID) {
		from.userID = newID.userID;
		//trace(from+".setUserID newId: "+newID.userID);	
	}		

	// Algorithm by Andrea Bussi.
	function newSetSize(ww, wh, nwin, pw, ph):Void {
		var w = (ww * 1.0)/pw;
		var h = (wh * 1.0)/ph;
		var r = w/h;
		var ri= 0;
		var nx= 0;
		var ny= 0;
		var v = 0;
		
		while( r > ri && nx < nwin ){		
			nx+=1;
			ny = Math.ceil((1.0*nwin)/nx);
			ri = (1.0 + nx)/(ny);
		}
		if( r > ((1.0*nx)/ny) )
			v = h / ny;
		else
			v = w / nx;

		var wx = Math.floor(v * pw);
		var wy = Math.floor(v * ph);
		var base  = (ww -(nx*wx))/2;
		var vid_x = base;
		var vid_y = 28;
		var j     = 0
		
		for (var i=0; i < this.video.length; i++) {
			
			if((vid_x + wx)  > ww){
				vid_x=base;
				vid_y+=wy;
			}
			
			this.video[i]._x		  = vid_x;
			this.video[i]._y		  = vid_y;
			this.video[i]._width	  = wx;
			this.video[i]._height	  = wy;
			
			vid_x+=wx;
		}
	}
	
	function setSize(newWidth:Number, newHeight:Number):Void {
		this.clear();

		this.button_bar._x = newWidth/2;
		this.enterButton._x = (newWidth - Math.max(this.enterButton._width,330))/2;
	
		newSetSize(newWidth, newHeight-25,this.video.length,4,3);
		return ;
	}
	
	function getPreferredSize():Size {
			var size=new Object();
			size.width=350;
			size.height=300;
			return(size);
	
	}
	function getMinimumSize():Size {
			var size=new Object();
			size.width=350;
			size.height=300;
			return(size);
	}

	function changeSource(res){
		trace("New Source: s=" + res);

		if(res == "image"){
			this.source = res;
			this.so.data[this.userID].type="image";
			this.so.data[this.userID].img_url=this.imageUrl+"&action=download"+ "&r="+Math.round(Math.random()*10000);
		}
		if(res == "webcam"){
			this.source = res;
			this.so.data[this.userID].type="webcam";
		}
		if(res == "upload"){
			this.uploadFile();
			this.button_bar.combo.selectedIndex = 0;
			this.button_bar.combo.redraw(false);
		}
	}
	
	function toggleAudio_click(value) {
		trace("Toggle audio: "+value);
		
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == this.userID){
				this.video[i].hasAudio = !this.video[i].hasAudio;
				
				if(value)
					this.local_ns.attachAudio(this.local_mic);
				else
					this.local_ns.attachAudio(null);
			}
		}
		
	}
	
	function exitButton_click() {
		this.button_bar._visible = false;
		this.enterButton._visible = true;
		this.connector.send(this.uri,"exitNew", { });
	}
	
	function enterButton_click() {
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" ){					
			this.button_bar._visible = true;
			this.enterButton._visible = false;
			this.connector.send(this.uri,"enterNew", { });
		}
		else{
			var dialog = this._parent.createDialogBox(DialogType.MessageBox);
			dialog.setTitle(_root.stringsManager.get("VC_ERROR_SECURITY_TITLE"));
			dialog.setLabel(_root.stringsManager.get("VC_ERROR_SECURITY_MSG"));
			
			var dialogResponse = new Object();
			dialogResponse.parent=this;
			dialogResponse.win=dialog;
		
			dialogResponse.close = function (evt_obj:Object) {
				this.win.removeMovieClip();
			};
			dialog.addEventListener("close", dialogResponse);
		}
	}
	
	function toggleZoom_click(value) {
		//trace("Toggle zoom: "+value);
		this._parent.setFullscreen(value);
	}
	
	function toggleVideo_click(value) {
		//trace("Toggle video: "+value);
		if (value) {
			this.button_bar.sendButton.selected=true;
			this.button_bar.sendButton.redraw();
		} else {
			this.button_bar.sendButton.selected=false;
			this.button_bar.sendButton.redraw();
		}
	
		for (var i=0; i < this.video.length; i++) {
			if(this.video[i].name == this.userID){
				this.video[i].hasVideo = !this.video[i].hasVideo;
				
				if(value){	
					setAudioVideo();
					this.local_ns.attachVideo(this.local_cam);
					this.video[i].video.attachVideo(this.local_cam);
				}
				else{
					this.local_ns.attachVideo(null);
					this.video[i].video.attachVideo(null);
				}
			}
		}
	}	
}
