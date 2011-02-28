import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;
import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.Debug.*;
import it.unipmn.di.Meeting.Connectors.*;
import mx.controls.ProgressBar;
import mx.core.UIObject;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;


class it.unipmn.di.Meeting.UIObjects.RWindow.RWindow extends MovieClip implements IRWindow {
	var style:Object;
	var urgency:Boolean;
	var events:Array;
	var hideContentOnMove:Boolean;
	var hideContentOnResize:Boolean;
	var localID:Number;
	var id:Number;
	var refreshRate:Number;
	var refreshID:Number;
	var last:Object;
	var fullscreen:Boolean;
	var refreshInterval:Number;
	var statusBarMessages:Array;
	var title:String;
	var content:MovieClip;
	var contentType:String;
	var content_movie:MovieClip;
	var contentPath:String;
	var param:Object;
	var menu:XML;
	var pbar:MovieClip;
	var info:TextField;
	var titleBar:Object;
	var statusBar:Object;
	var buttons:Object;
	var borders:Object;
	var trasparent:Boolean;
	var state:String;
	var urgencyHint:Boolean;
	var locked:Boolean;
	var urgencyTimer:Number;
	var type:String;
	var size:Object;
	var _dialog:MovieClip;
	var force_redraw:Boolean;
	
	var test:MovieClip
	function RWindow() {
		this.force_redraw = false;
		this.createEmptyMovieClip("borders", 0);
		this.fullscreen = false;
		this.setTrasparent(false);
		this.attachMovie("Controller", "statusBar", this.getNextHighestDepth());
		this.attachMovie("TitleBar", "titleBar", this.getNextHighestDepth());
		this.attachMovie("ButtonsController", "buttons", this.getNextHighestDepth());
		this.urgency = false;
		this.events = new Array();
		this.style  = new Object();
		this.statusBarMessages = new Array();
		this.locked = false;
		
		var newStyle = new Object();
		newStyle.backgroundColor = 0xEEEEEE;
		newStyle.backgroundGradient = false;
		newStyle.backgroundGradientColors = [0xCCCCCC, 0xFFFFFF, 0xCCCCCC];
		newStyle.backgroundGradientAlphas = [100, 100, 100];
		newStyle.backgroundGradientRatios = [0, 0x7F, 0xFF];
		newStyle.backgroundGradientMatrixAdapted = true;
		newStyle.backgroundGradientMatrix = {matrixType:"box", x:100, y:100, w:200, h:200, r:(0/180)*Math.PI};
		newStyle.backgroundTrasparency = 100;
		newStyle.borderColor = 0xB4BCBC;
		newStyle.fillColor = 0xEEEEEE;
		newStyle.fillColorGradient = true;
		newStyle.fillColorGradientColors = [0xCCCCCC, 0xFFFFFF, 0xCCCCCC];
		newStyle.fillColorGradientAlphas = [100, 100, 100];
		newStyle.fillColorGradientRatios = [0, 0x7F, 0xFF];
		newStyle.fillColorGradientMatrixAdapted = true;
		newStyle.fillColorGradientMatrix = {matrixType:"box", x:100, y:100, w:200, h:200, r:(0/180)*Math.PI};
		newStyle.controllerTrasparency = 100;
		newStyle.closeFillColor = 0xFF0000;
		newStyle.minimizeFillColor = 0x333333;
		newStyle.maximizeFillColor = 0x333333;
		newStyle.closeTrasparency = 100;
		newStyle.minimizeTrasparency = 100;
		newStyle.maximizeTrasparency = 100;
		newStyle.closeBorderColor = 0xB4BCBC;
		newStyle.minimizeBorderColor = 0xB4BCBC;
		newStyle.maximizeBorderColor = 0xB4BCBC;
		newStyle.closeIconColor = 0xFFFFFF;
		newStyle.minimizeIconColor = 0xFFFFFF;
		newStyle.maximizeIconColor = 0xFFFFFF;
		newStyle.titleColor = 0x333333;
		newStyle.titleSelectedColor = 0xFF0000;
		newStyle.statusMessageColor = 0x333333;
		newStyle.gripColor = 0xBBBBBB;
		newStyle.hideContentOnResize = true;
		newStyle.hideContentOnMove = true;
		newStyle.shadows = false;
		
		this.setWindowStyle(newStyle);
		
		this.titleBar.setTitle(this.title);
		this.state= "normal";
		
		if(newStyle.shadows){
			var glow:GlowFilter = new GlowFilter(0x999999, 0.75, 12, 12, 1, 6, false, false);
			var shadowR:DropShadowFilter = new DropShadowFilter(10,45,0x222222,1.0,10,10,0.25,3);
			var shadowL:DropShadowFilter = new DropShadowFilter(10,135,0x222222,1.0,10,10,0.25,3);
			this.filters = [shadowR, shadowL];
		}
		
		var completeListener = new Object();
		completeListener._parent = this;
		completeListener.complete = function() {
			this._parent.refreshWindow();
			this._parent.refreshWindow(1000);
		};
		this.addEventListener("complete", completeListener);
		this.localID = 0;

		this.last = new Object();
		this.size = new Object();	
	
		this.doContent(this.contentPath);
		//_root.Log.print("WINDOWS INIT: " + this);
	}
	
	function createDialogBox(dialogType:String){
		switch(dialogType){
			case DialogType.MessageBox:
				break;
			case DialogType.QuestionBox:
				break;
			case DialogType.ConfirmBox:
				break;
			case DialogType.ListBox:
				break;
			case DialogType.PromptBox:
				break;
			case DialogType.ProgressBox:
				break;
			default:
				return null;		
		}
		this._dialog.removeMovieClip();	
		this.attachMovie(dialogType, "_dialog", this.getNextHighestDepth());
		this._dialog.setSize(this.size.width, this.size.height);
		//refreshWindow();
		return this._dialog;
	}
	
	function refreshSize(mc){
		clearInterval(mc.refreshID);
		var size = mc.getSize();
		if(size == undefined || size.width == undefined || size.width == null ||size.width <= 0
		   || size.height == undefined || size.height == null ||size.height <= 0)
			size = mc.getPreferredSize();
		mc.setSize(size.width, size.height);
	}
	
	function refreshWindow(msec){
		if(this.refreshID!=undefined || this.refreshID!=null)
			clearInterval(this.refreshID);			
		this.refreshID = setInterval(refreshSize, (msec!=undefined? msec: 50), this);
	}
	
	function addEventListener(eventType:String, listener:Object):Void{
		var newEvent = new Object();
		newEvent.type = eventType;
		newEvent.action = listener;
		this.events[this.events.length] = newEvent;
	}
	function newError(err, popup, level, id):Void {
		this._parent.newError(err, popup, level, id);
	}
	function pushStatusBarMessage(msg:String):Void{
		this.statusBarMessages.push(msg);
		this.statusBar.status_txt.text = msg;
	}
	function popStatusBarMessage():Void{
		var msg = this.statusBarMessages.pop();
		this.statusBar.status_txt.text = msg;
	}
	function needToHideContentOnMove():Boolean
	{
		return this.style.hideContentOnMove;
	}
	function needToHideContentOnResize():Boolean
	{
		return this.style.hideContentOnResize;
	}
	function hide():Void
	{
		this._visible = false;
	}
	function hideContent():Void
	{
		this.content._visible = false;
		this.content_movie._visible = false;
	}
	function onPositionModification() {
		//trace("Position: "+this.locked);
		if(this.locked==false)
			this._parent.onWindowPositionModified(this.id);
	}
	function onSizeModification() {
		
		trace("Size: "+this.locked);		
		if(this.locked==false)
			this._parent.onWindowSizeModified(this.id);
	}
	function onStateModification() {
		trace("State: "+this.state+" "+this.locked);
		if(this.locked==false){
			this._parent.onWindowStateModified(this.id);
		}
	}
	function showContent():Void
	{
		this.force_redraw = true;
		this.setSize(this.size.width, this.size.height);		
		this.force_redraw = false;
		this.content_movie._visible = true;
		this.content._visible = true;
	}
	function show():Void
	{
		this._visible = true;
	}
	function getTitle():String {
		return this.title;
	}
	function setTrasparent(value:Boolean):Void
	{
		this.trasparent = value;
		
		if(this.locked==false)
			this._parent.onWindowTransparencyModified(this.id);
	}
	function getTrasparent():Boolean
	{
		return this.trasparent;
	}
	function isTrasparent():Boolean
	{
		return this.trasparent;
	}
	function getContentPath():String
	{
		return this.contentPath;
	}
	function doEvent(event) {
		var i = 0;
		while (i<this.events.length) {
			if (this.events[i].type == event) {
				this.events[i].action[this.events[i].type]();
			}
			i++;
		}
	}
	function doContent(contentPath) {
		this.createContent(contentPath);
	}
	function getWindowStyle():Object
	{
		return this.style;
	}
	function getState():String
	{
		if(this.locked == false)
			return this.state;
		else
			return "locked";
	}
	function getLocalID():Number
	{
		return this.localID;
	}
	function setLocalID(newId:Number):Void
	{
		this.localID = newId;
	}
	function getId():Number
	{
		return this.id;
	}
	function setId(newId:Number):Void
	{
		this.id = newId;
	}
	function getType():String
	{
		return this.type;
	}
	function setType(newType:String):Void
	{
		this.type = newType;
	}
	function setState(newState:String):Void
	{
		this.buttons.setState(newState);
		this.state = newState;
		this.onStateModification();
	}
	function setFocus():Void
	{
		var info = _root.getUserInformation();
		if(info.role != "poweruser" && 
		   info.star != "poweruser" ){
			return;				
		}
		this._parent.setFocus(this);
	}
	function setWindowStyle(newStyle:Object):Void
	{
		for (var prop in newStyle) {
			this.style[prop] = newStyle[prop];
		}
	}
	function getSize():Size
	{
		var size = new Object();
		size.height = this.size.height;
		size.width = this.size.width;
		return(size);
	}
	function getLastPosition():Position{
		var pos = new Object();
		pos.x = this.last.x;
		pos.y = this.last.y;
		return (pos);
	}
	function setLastPosition(pos:Position):Void
	{
		this.last.x = pos.x;
		this.last.y = pos.y;
	}
	function getPosition():Position
	{
		var pos = new Object();
		pos.x = this._x;
		pos.y = this._y;
		return (pos);
	}
	function doUrgencyHint(from:Object, value:Boolean):Void
	{
		if (value || from.urgency == false) {
			from.titleBar.normal();
		} else {
			if (from.urgencyHint == true) {
				from.titleBar.inverted();
			} else {
				from.titleBar.normal();
			}
		}
		from.urgencyHint = !from.urgencyHint;
	}
	function setUrgencyHint(value:Boolean):Void
	{
		if (value && this.urgency == false) {
			this.urgencyTimer = setInterval(this.doUrgencyHint, 200, this);
			this.urgencyHint = this.urgency=true;
		}
		if (!value) {
			clearInterval(this.urgencyTimer);
			this.urgency = false;
			this.doUrgencyHint(this, true);
		}
	}
	function isFullscreen():Boolean
	{
		return this.fullscreen;
	}
	function setFullscreen(value:Boolean):Void
	{
		this.fullscreen = value;
		if (value == true) {
			this.setState("fullscreen");
		} else {
			this.setState("normal");
		}
		this._parent.setFullScreen(value);
	}
	function setPosition(pos:Position):Void
	{
		this._x = pos.x;
		this._y = pos.y;
		if (this.state == "normal") {
			this.setLastPosition(pos);
		}
	}
	function moveTo(x:Number, y:Number):Void
	{
		this._x = x;
		this._y = y;
		if (this.state == "normal") {
			var pos = new Object();
			pos.x = x;
			pos.y = y;
			this.setLastPosition(pos);
		}
		doEvent("move");
	}
	function getLastSize():Size
	{
		var size = new Object();
		size.width = this.last.width;
		size.height = this.last.height;
		return size;
	}
	function getContentLimits():Limits
	{
		var limits = new Object();
		limits.left = 2.5;
		limits.top = 32;
		limits.right = this.size.width-6;
		limits.bottom = this.size.height-54;
		return limits;
	}
	function setLastSize(newWidth:Number, newHeight:Number):Void
	{
		this.last.width = newWidth;
		this.last.height = newHeight;
	}
	function lockWindow(value:Boolean):Void
	{
		this.locked=value;
	}
	
	function setSize(newWidth:Number, newHeight:Number):Void
	{
		//_root.Log.print("setSize: newWidth:"+newWidth+", newHeight:"+newHeight);
			
		if(isNaN(newWidth) || isNaN(newHeight) || newWidth == undefined || newWidth == null || newWidth < 0 || newWidth == Number.NaN || Number(newWidth) == Number.NaN ||
		   newWidth == Number.NEGATIVE_INFINITY || newWidth == Number.POSITIVE_INFINITY ||
   		   newWidth == Infinity || 
		   newHeight == Number.NEGATIVE_INFINITY || newHeight == Number.POSITIVE_INFINITY ||
   		   newHeight == Infinity ||
		   newHeight == undefined || newHeight == null || newHeight < 0 || Number(newHeight) == Number.NaN || newHeight == Number.NaN)
		{
			/*var preferred = this.content.getPreferredSize();
			newWidth = preferred.width;
			newHeight = preferred.height;*/
		}
		else{
			this.size.height = newHeight;
			this.size.width = newWidth;
		}
		if (this.fullscreen == true) {
			this._dialog.setSize(newWidth,newHeight);
			this.statusBar._visible = false;
			this.statusBar.clear();
			this.titleBar._visible = false;
			this.titleBar.clear();
			this.buttons._visible = false;
			this.borders.clear();
			this.content_movie._x = 0;
			this.content_movie._y = 0;
			this.content.setSize(newWidth-1, newHeight-1);
			if (!this.isTrasparent()) {
				this.borders.beginFill(this.style.backgroundColor, this.style.backgroundTrasparency);
			}
			this.borders.lineStyle(1, this.style.borderColor, 100, true);
			this.borders.moveTo(0, 0);
			this.borders.lineTo(0, newHeight-1);
			this.borders.lineTo(newWidth-1, newHeight-1);
			this.borders.lineTo(newWidth-1, 0);
			if (!this.isTrasparent()) {
				this.borders.endFill();
			}
			return;
		}
		this.statusBar._visible = true;
		this.titleBar._visible = true;
		this.buttons._visible = true;
		var limits = this._parent.getContentLimits();
		var maxWidth = limits.right-(limits.left+1);
		var maxHeight = limits.bottom;
		var pos = this.getPosition();
		maxWidth -= pos.x;
		maxHeight -= pos.y;
		
		var size = this.content.getMinimumSize();
		
		var sizeT = this.titleBar.getSize();
		var sizeS = this.statusBar.getSize();
		
		newHeight = Math.max(newHeight,size.height+(sizeT.height+sizeS.height)+3);
		newWidth = Math.max(newWidth,size.width+1);

		if (newHeight>maxHeight) {
			this.moveTo(pos.x, pos.y-(newHeight-maxHeight));
		}
		if (newWidth>maxWidth) {
			this.moveTo(pos.x-(newWidth-maxWidth), pos.y);
		}
		if(this.size.height < newHeight)
			this.size.height = newHeight;
		if(this.size.width < newWidth)
			this.size.width = newWidth;
		this._dialog.setSize(newWidth,newHeight);
		
		
		newHeight -= 3;
		if (this.content_movie._visible || this.force_redraw) {
			this.content_movie._x = 1;
			this.content_movie._y = this.titleBar._height+1;
			this.content.setSize(newWidth-2, newHeight-(this.titleBar._height+this.statusBar._height+2));
		}
		this.statusBar.setSize(newWidth, newHeight);
		this.titleBar.setSize(newWidth, newHeight);
		this.buttons.setSize(newWidth, newHeight);
		this.borders.clear();
		if (!this.isTrasparent()) {
			if (this.style.backgroundGradient) {
				if (this.style.backgroundGradientMatrixAdapted) {
					this.style.backgroundGradientMatrix.x = 0;
					this.style.backgroundGradientMatrix.y = this.titleBar._height+1;
					this.style.backgroundGradientMatrix.w = newWidth;
					this.style.backgroundGradientMatrix.h = newHeight-this.statusBar._height;
				}
				this.borders.beginGradientFill("linear", this.style.backgroundGradientColors, this.style.backgroundGradientAlphas, this.style.backgroundGradientRatios, this.style.backgroundGradientMatrix);
			} else {
				this.borders.beginFill(this.style.backgroundColor, this.style.backgroundTrasparency);
			}
		}
		this.borders.lineStyle(1, this.style.borderColor, 100, true);
		this.borders.moveTo(0, this.titleBar._height-1);
		this.borders.lineTo(0, (newHeight-this.statusBar._height)+3);
		this.borders.lineTo(newWidth, (newHeight-this.statusBar._height)+3);
		this.borders.lineTo(newWidth, this.titleBar._height-1);
		if (!this.isTrasparent()) {
			this.borders.endFill();
		}
		if (this.state == "normal" || this.state == "minimized") {
			this.setLastSize(newWidth+1, newHeight+2);
		}
		doEvent("size");
	}
	function getMenu():XML
	{
		return this.menu;
	}
	function setMenu(newMenu:XML):Void
	{
		this.menu = newMenu;
	}
	function close():Void{
		this.hide();
		this.destroyObject();
		this.clear();
	}
	function destroyObject():Void{
		this.content.close();
		clearInterval(this.refreshInterval);
		this.content.removeMovieClip();
		this.content_movie.removeMovieClip();
	}
	function createContent(contentPath:String):Void {
		this.contentPath = contentPath;
		//trace("contentType: "+this.contentType);
		this.createEmptyMovieClip("content_movie", this.getNextHighestDepth());
		if (this.contentType == "preloaded") {
			var app_class:Function = eval(contentPath);
			this.content = new app_class(this["content_movie"], this.param);
			for (var i in this.param) {
				this.content[i] = this.param[i];
			}
			this.doEvent("complete");
		} else if (this.contentType == "embedded") {
			//Log.print("Param: ",this.param);
			this.attachMovie(contentPath, "content", this.getNextHighestDepth(), this.param);
			//Log.print("Param2: ",this.content.serverUrl);
			this.content_movie = this.content;
			this.doEvent("complete");
		} else if (this.contentType == "external") {
			attachMovie("perc_bar", "pbar", this.getNextHighestDepth(), {_x:50, _y:125});
			this.createTextField("info", this.getNextHighestDepth(), 50, 130, 200, 20);
			this.info.selectable = false;
			var infoTF:TextFormat = new TextFormat();
			infoTF.bold = true;
			infoTF.color = 0x006600;
			infoTF.font = "Arial";
			infoTF.size = 10;
			this.info.setNewTextFormat(infoTF);
			var mcLoader:MovieClipLoader = new MovieClipLoader();
			var load_listener = new Object();
			load_listener.parent = this;
			load_listener.pbar = pbar;
			load_listener.info = info;
			load_listener.onLoadProgress = function(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void  {
				info.text = "loading... "+Math.round((bytesLoaded/bytesTotal)*100)+"%";
				pbar._xscale = (bytesLoaded/bytesTotal)*100;
			};
			load_listener.onLoadInit = function(mc:MovieClip) {

				mc._lockroot = false;
				for (var i in this.parent.param) {
					mc[i] = this.parent.param[i];
				}
				pbar.removeMovieClip();
				info.removeTextField();
				this.parent.content = mc.init(this.parent, this.parent.param);

				this.parent.refreshWindow();
				
				this.parent.statusBar.swapDepths(this.parent.getNextHighestDepth());
				this.parent.titleBar.swapDepths(this.parent.getNextHighestDepth());
				this.parent.buttons.swapDepths(this.parent.getNextHighestDepth());
				this.parent.doEvent("complete");
				
			};
			mcLoader.addListener(load_listener);
			mcLoader.loadClip(contentPath, this.content_movie);
		}
		this.refreshWindow();
		this.statusBar.swapDepths(this.getNextHighestDepth());
		this.titleBar.swapDepths(this.getNextHighestDepth());
		this.buttons.swapDepths(this.getNextHighestDepth());
	}
	function onLoad() {
		this.doEvent("complete");
	}

}