import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import mx.containers.ScrollPane;

import mx.core.UIObject;

	
class it.unipmn.di.Meeting.components.Presentation extends MovieClip implements IClientComponent, IUIWindowComponent{

	
	var soName:String	   = "content";
	var uri:String
	var name:String
	var swfFile:String
	var controls:MovieClip
	var swf:ScrollPane;
	var connector:IConnector
	var so:SharedObject
	var movie:MovieClip
	var _parent:MovieClip
	var listURL:String
	var files:Array
	var filesWin:MovieClip
	
	function getURI():String {
			
			return this.uri;
			
	}
	
	function Presentation(clip:MovieClip) {
		
		this.movie._parent = this;
		
		this.name = (this._name == null ? "_DEFAULT_" : this._name);
	
		this.uri="Presentation";

		this.movie.createClassObject(mx.containers.ScrollPane, "swf", this.getNextHighestDepth());
		
		
		this.movie.attachMovie("Controls","controls",this.movie.getNextHighestDepth(), {_parent:this});
		this.controls = this.movie.controls;
		
		this.movie.swf.move(0,this.controls._height);
		this.controls._parent = this;
		
		this.files=new Array();
		
		
		var completeListener:Object = new Object();
		completeListener.parent = this.movie.swf;
		completeListener.complete = function(evt_obj:Object) {
			//trace(this+" # "+evt_obj.target.contentPath + " has completed loading.");
			this.parent.refresh();
			this.parent.redraw(true);
		};
		// Aggiunge un listener.
		this.movie.swf.addEventListener("complete", completeListener);
		
		
		_root.core.addNetworkComponent(this);
		
		this.listURL = unescape(this.listURL);
		downloadXML(this.listURL);
	}
	function onDisconnect():Void{
	}
	function onConnect(con:IConnector):Void {
		
		this.connector = con;	
		
		var listener = new Object();
		
		listener.onSync= function (list){
			//trace("Presentation.onSync: ");
			
			for (var i in  list) {
				/*trace(i +" #  " + list[i]);
				for (var j in list[i])
					trace(" > "+j +" -  " + list[i][j]);
				*/
				if (list[i].name == "frameNum") {
					this.parent.movie.swf.content.gotoAndStop(this.data.frameNum);
				
				} else if (list[i].name == "swfFile" && list[i].code == "delete") {
							 this.parent.movie.swf.contentPath = "";
				}
				else if (list[i].name == "vScroll") {
					this.parent.movie.swf.vPosition =  this.data.vScroll;
				}			
				else if (list[i].name == "hScroll") {
					this.parent.movie.swf.hPosition =  this.data.hScroll;
				}
				else if (list[i].name == "zoom") {
					this.parent.controls.step.value = this.data.zoom;
					this.parent.movie.swf.content._xscale =  this.data.zoom;
					this.parent.movie.swf.content._yscale =  this.data.zoom;
					this.parent.movie.swf.redraw(true);
				}
				else if (list[i].name == "swfFile") {
					this.data.hScroll = 0;
					this.data.vScroll = 0;
					this.data.zoom = 100;
					this.parent.loadProgress();
					this.parent.movie.swf.contentPath = this.data.swfFile;
					
				} 
			}
		}
		
		this.so = this.connector.recordSharedObject("presentation", this, listener, this, false);
		
	}
	
	function onStatus(info:Object):Void{
	
	}
	
	function getClass():String {
		
		return "Presentation";
		
	}
	
	function close():Void {
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.movie.unloadMovie();
		this.unloadMovie();
	}
	
 	function open():Void {
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		if(this.files.length==0)
			downloadXML(this.listURL);
		var i;		
		var dialog = this._parent.createDialogBox("ListBox");
		dialog.setTitle(_root.stringsManager.get("PRESENTATION_CHOOSE_FILE_TITLE"));
		var list= new Array(); 
		for (i=0;i<=this.files.length && this.files[i] != undefined;i++){
			list.push({label:this.files[i].name,data:this.files[i].url});
		}
		dialog.setList(list);
		
		var dialogResponse = new Object();
		dialogResponse.parent=this;
		dialogResponse.win=dialog;
	
		dialogResponse.close = function (evt_obj:Object) {
			if(evt_obj.label!="Cancel"){
				this.parent.clearSWF();
				this.parent.loadSWF(evt_obj.item.data);
			}
			this.win.removeMovieClip();
			
		};
		dialog.addEventListener("close", dialogResponse);
	}
	
	function downloadXML (filexml) {
		var f_xml = new XML();
		
		f_xml.load(filexml);
		f_xml._parent=this;
		f_xml.onLoad = function (success) {
			
			var i, j;
			var myarray = new Array();
			this._parent.files = new Array();
			if (f_xml.loaded) {
				myarray = f_xml.childNodes;
				for (j=0;j<=myarray.length;j++){
					if (myarray[j].nodeName == "file"){
						var file =new Object();
						file.name = myarray[j].attributes.name;
						file.url = myarray[j].attributes.url;
						file.size = myarray[j].attributes.size;
						file.date = myarray[j].attributes.date;
						this._parent.files.push(file);
					}
				}
			}
			else{
				this._parent.newError(_root.stringsManager.get("PRESENTATION_ERROR_LOAD") + " " + this.listURL, true);
			}
		}
	}
	function setSize(newWidth:Number, newHeight:Number):Void {
		this.controls._x = newWidth/2;
		this.movie.swf.setSize(newWidth, newHeight-this.controls._height);
	}
	
	function getPreferredSize():Size {
			var size=new Object();
			size.width=400;
			size.height=250;
			return(size);
	
	}
	function getMinimumSize():Size {
			var size=new Object();
			size.width=350;
			size.height=200;
			return(size);
	}
	
	
	function scroll (h:Number,v:Number) {
		this.so.data.hScroll = h;
		this.so.data.vScroll = v;
	}

	function zoom(z:Number) {
		this.so.data.zoom = z;
	}
	
	function more() {

		if(this.so.data.zoom == undefined || this.so.data.zoom == null)
			this.so.data.zoom = 110;
		else
			this.so.data.zoom = this.so.data.zoom*1.1;
	}

	function less () {
		if(this.so.data.zoom == undefined || this.so.data.zoom == null)
			this.so.data.zoom = 90;
		else
			this.so.data.zoom = this.so.data.zoom/1.1;
	}
	
	function loadProgress(){
		var dialog = this._parent.createDialogBox("ProgressBox");
		dialog.setTitle(_root.stringsManager.get("PRESENTATION_LOAD_TITLE"));
		var dialogProgress = new Object();
		dialogProgress.parent=this;
		dialogProgress.win=dialog;
	
		dialogProgress.close = function (evt_obj:Object) {
			this.win.removeMovieClip();			
		};
		
		dialogProgress.progress = function (evt_obj:Object) {
			var spane = this.parent.movie.swf;
			this.win.setTitle(_root.stringsManager.get("PRESENTATION_LOAD_PROGRESS_TITLE"));
			var perc = Math.round((spane.getBytesLoaded() / spane.getBytesTotal())*100);
			this.win.setProgress(perc);
			
			if(perc == 100)
				this.parent._parent.refreshWindow();
		};

		dialog.addEventListener("close", dialogProgress);
		this.movie.swf.addEventListener("progress", dialogProgress);		
	}
	
	function loadSWF (swfFile:String) {
		this.so.data.swfFile = swfFile;
	}
	function begin() {
		this.so.data.frameNum =1;
		this.movie.swf.content.gotoAndStop(1);
	}

	function next() {
		this.movie.swf.content.gotoAndStop(this.movie.swf.content._currentframe + 1);
		this.so.data.frameNum = this.movie.swf.content._currentframe;
	}
		
	function back() {
		this.movie.swf.content.gotoAndStop(this.movie.swf.content._currentframe - 1);
		this.so.data.frameNum = this.movie.swf.content._currentframe;
	}

	function clearSWF() {
		this.so.data.swfFile =null;
	}
	
}
