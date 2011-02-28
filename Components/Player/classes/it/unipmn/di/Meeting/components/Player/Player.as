import it.unipmn.di.Meeting.Connectors.IConnector;
import it.unipmn.di.Meeting.Connectors.IClientComponent;
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import mx.containers.ScrollPane;
import mx.core.UIObject;
import mx.video.FLVPlayback;

/**
  * Video player component for MeetingPoint.
  */
class it.unipmn.di.Meeting.components.Player.Player
	extends MovieClip
	implements IClientComponent, IUIWindowComponent {

	// SO name and instance
	var soName:String = "player";
	var so:SharedObject;
	
	var uri:String;
	var name:String;
	
	var connector:IConnector;
	
	var movie:MovieClip;
	var _parent:MovieClip;
	
	var videoFile:String;
	
	// the URL that contains the list of videos
	var listURL:String;

	var files:Array;
	var filesWin:MovieClip;

	// interface controls (in the FLA file)
	var myVideo:FLVPlayback;
	var openButton:Button;
	var seekBar:MovieClip;
	var playPauseButton:MovieClip;

	function Player(clip:MovieClip) {

		this.movie._parent = this;

		this.name = (this._name == null ? "_DEFAULT_" : this._name);

		this.uri = "Player";

		_root.core.addNetworkComponent(this);

		var keyListener = new Object();
		keyListener.parent = this;
		keyListener.onKeyDown = function() {
			if (Key.isDown(Key.SPACE)) {
				this.parent.playPauseClick();
			}
		};
		Key.addListener(keyListener);

		this.files = new Array();

		this.listURL = unescape(this.listURL);
		downloadXML(this.listURL);
	}
	
	function getURI():String {
		return this.uri;
	}
	
	function getClass():String {
		return "Player";
	}
	
	function playPauseClick():Void {
		if (!hasPrivileges()) {
			return;
		}
		if (this.myVideo.playing) {
			this.so.data.state = "pause";
			this.so.data.pauseTime = this.myVideo.playheadTime;
			_root.Log.print("Video paused at:", this.myVideo.playheadTime);
		} else {
			if (this.myVideo.playheadTime == 0) this.so.data.state = "play";
			else this.so.data.playTime = this.myVideo.playheadTime;
			_root.Log.print("Video played at:", this.myVideo.playheadTime);
		}
	}
	
	function seekBarChanged(eventObject:Object):Void {
		if (!hasPrivileges()) {
			return;
		}
		this.so.data.seekTime = this.myVideo.playheadTime;
		_root.Log.print("Video seek at:", this.myVideo.playheadTime);
	}

	/**
	  * Method:
	  *   Tells if the user has Moderator or Poweruser privileges.
	  *
	  * Returns:
	  *   {Boolean} true or false
	  */
	function hasPrivileges():Boolean {
		var info = _root.getUserInformation();
		if (info.role != "moderator" && info.star != "moderator" && info.role != "poweruser" && info.star != "poweruser") {
			return false;
		}
		return true;
	}
	
	function onDisconnect():Void {
		if (hasPrivileges()) {
			this.so.data.state = "";
			this.so.data.currentTime = 0;
			this.so.data.videoFile = "";
			_root.Log.print("onDisconnect:", this.so.data.state + ", " + this.so.data.currentTime + 
							+ ", " + this.so.data.videoFile);
		}
	}
	
	function onConnect(con:IConnector):Void {

		this.connector = con;

		var listener = new Object();

		listener.onSync = function(list) {
			for (var i in list) {
				if (list[i].name == "state") {
					if (this.data.state == "play") {
						_root.Log.print("Play received: 0");
						this.parent.myVideo.seek(0);
						this.parent.myVideo.play();
					}
				}
				else if (list[i].name == "pauseTime") {
					_root.Log.print("Pause received:", this.data.pauseTime);
					this.parent.myVideo.pause();
					this.parent.myVideo.seek(this.data.pauseTime);
				}
				else if (list[i].name == "playTime") {
					_root.Log.print("Play received:", this.data.playTime);
					this.parent.myVideo.seek(this.data.playTime);
					this.parent.myVideo.play();
				}
				else if (list[i].name == "seekTime") {
					_root.Log.print("Time received:", this.data.seekTime);
					this.parent.myVideo.seek(this.data.seekTime);
				}
				else if (list[i].name == "videoFile") {
					_root.Log.print("VideoFile received:", this.data.videoFile);
					this.parent.setVideo(this.data.videoFile);
				}
			}
		};
		
		listener.onStatus = function(info:Object):Void  {
			_root.Log.print("Error:",info);
		};
		
		var playPauseListener = new Object();
		
		this.so = this.connector.recordSharedObject(soName, this, listener, this, true, playPauseListener);
	}
	
	function onStatus(info:Object):Void {
		_root.Log.print("Error IClientComponent:",info);
	}
	
	function close():Void {
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		this.myVideo.stop();
		this.myVideo.removeMovieClip();
		delete this.myVideo;
		this.movie.unloadMovie();
		this.movie.removeMovieClip();
		this.unloadMovie();
		this.removeMovieClip();
	}

	function setSize(newWidth:Number, newHeight:Number):Void {
		this.myVideo.setSize(newWidth,newHeight-playPauseButton._height);
		this.myVideo._x = (newWidth - this.myVideo._width) / 2;
		this.playPauseButton._x = this.myVideo._x;
		this.playPauseButton._y = newHeight - this.playPauseButton._height + 2;
		this.openButton._x = this.myVideo._x + this.myVideo._width - 70;
		this.openButton._y = playPauseButton._y;
		this.seekBar._x = this.playPauseButton._x + this.playPauseButton._width + 4;
		this.seekBar._y = this.playPauseButton._y + (this.playPauseButton._width-this.seekBar._height) / 2;
		// adjust seekbar handle position
		if (this.myVideo.stopped) {
			this.myVideo.seekBar.handle_mc._x = this.seekBar._x;
			this.myVideo.playheadTime = 0;
		}
		this.seekBar.handle_mc._y = this.seekBar._y + this.seekBar._height + 2;
		
		// if I resize the bar the handle works like the bar was the original size
		//this.seekBar._width = this.openButton._x-this.seekBar._x-4;
	}
	
	function getPreferredSize():Size {
		var size = new Object();
		size.width = 400;
		size.height = 350;
		return (size);
	}
	
	function getMinimumSize():Size {
		var size = new Object();
		size.width = 280;
		size.height = 260;
		return (size);
	}

	function open():Void {
		if (!hasPrivileges()) {
			return;
		}
		if (this.files.length == 0) {
			downloadXML(this.listURL);
		}
		var i;
		var dialog = this._parent.createDialogBox("ListBox");
		dialog.setTitle(_root.stringsManager.get("WBPLUS_CHOOSE_FILE_TITLE"));
		var list = new Array();
		for (i=0; i<=this.files.length && this.files[i] != undefined; i++) {
			list.push({label:this.files[i].name, data:this.files[i].url});
		}
		dialog.setList(list);

		var dialogResponse = new Object();
		dialogResponse.parent = this;
		dialogResponse.win = dialog;

		dialogResponse.close = function(evt_obj:Object) {
			if (evt_obj.label != "Cancel") {
				this.parent.loadVideo(evt_obj.item.data);
				// uncomment the following line for testing purposes
				//this.parent.loadVideo("http://meetingpoint.di.unipmn.it/test/mod/meetingpoint/files/stirling.flv");
			}
			this.win.removeMovieClip();

		};
		dialog.addEventListener("close", dialogResponse);
	}
	
	function downloadXML(filexml) {
		var f_xml = new XML();

		f_xml.load(filexml);
		f_xml._parent = this;
		f_xml.onLoad = function(success) {

			var i, j;
			var myarray = new Array();
			this._parent.files = new Array();
			if (f_xml.loaded) {
				myarray = f_xml.childNodes;
				for (j=0; j<=myarray.length; j++) {
					if (myarray[j].nodeName == "file") {
						var file = new Object();
						file.name = myarray[j].attributes.name;
						file.url = myarray[j].attributes.url;
						file.size = myarray[j].attributes.size;
						file.date = myarray[j].attributes.date;
						this._parent.files.push(file);
					}
				}
			} else {
				this._parent.newError(_root.stringsManager.get("WBPLUS_ERROR_LOAD")+" "+this.listURL,true);
			}
		};
	}
	
	function setVideo(videoFile:String) {
		this.myVideo.contentPath = videoFile;
		this.myVideo.seek(0);
	}
	
	function loadVideo(videoFile:String) {
		_root.Log.print("loadVideo:", videoFile);
		this.so.data.videoFile = videoFile;
	}
	
}