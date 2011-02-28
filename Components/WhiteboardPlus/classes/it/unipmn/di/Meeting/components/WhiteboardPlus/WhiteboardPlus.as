import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import mx.containers.ScrollPane;
import mx.core.UIObject;
import mx.component.Button;


class it.unipmn.di.Meeting.components.WhiteboardPlus.WhiteboardPlus extends MovieClip implements IClientComponent, IUIWindowComponent{
	
	var soName:String	   = "whiteboardPlus";
	var uri:String
	var name:String
	var lineColor:Number = 0x000000
	var fillColor:Number = 0x000000
	var tool:String
	var lineSize:Number = 1
	var page:Number = 1
	var controls:MovieClip
	var refresh:MovieClip
	var connector:IConnector
	var so:SharedObject
	var movie:MovieClip
	var _parent:MovieClip
	var shapes:MovieClip
		
	var swfFile:String
	var swf:ScrollPane
	var listURL:String
	var files:Array
	var filesWin:MovieClip	
	var buttons:Array=["pointer","arrow","circle","rectangle","pencil", "highlight","text"]
	
	
	var drag_x
	var drag_y
	
	var drag_min_x
	var drag_min_y
	var drag_max_x
	var drag_max_y
	
	
	function getURI():String {
			return this.uri;
	}
	
	function WhiteboardPlus(clip:MovieClip) {
		
		this.movie._parent = this;
		
		this.name = (this._name == null ? "_DEFAULT_" : this._name);
	
		this.uri="WhiteboardPlus";

		this.movie.attachMovie("WBPControls","controls",this.movie.getNextHighestDepth(), {_parent:this});
		this.movie.controls.swapDepths(this.movie.getNextHighestDepth());
		this.controls = this.movie.controls;
				
		this.controls._parent = this;

		_root.core.addNetworkComponent(this);
		
		var style = new Object();
		style.backgroundColor = 0xFFFFFF;
		this._parent.setWindowStyle(style);
		
		var keyListener = new Object();
		keyListener.parent = this;
		keyListener.onKeyDown = function() {
	
			// Delete Key Doesn't work in authoring environment, use Ctrl-Delete
			if (Key.isDown(Key.DELETEKEY) && this.parent.activeTool == "Arrow" && this.parent.selectedShape != null) {
				// Delete active shape by removing it from the SharedObject
				var shape = this.parent.selectedShape;
				this.parent.so.data[shape._name.substr(0, shape._name.length - 3)] = null;
				this.parent.selectedShape = null;
				// Get rid of bounding box highlight
				this.parent.shapeSelect_mc.clear();
			}
		};
		Key.addListener(keyListener);
		
		this.movie.swf = this.controls.swf;
		
		this.files=new Array();
		
		var completeListener:Object = new Object();
		completeListener.parent = this.movie.swf;
		completeListener.component_root = this;
		completeListener.complete = function(evt_obj:Object) {
			////trace(this+" # "+evt_obj.target.contentPath + " has completed loading.");
			this.parent.refresh();
			this.parent.redraw(true);
			this.component_root.initialize_shapes();
		};
		// Aggiunge un listener.
		this.movie.swf.addEventListener("complete", completeListener);
		
		this.listURL = unescape(this.listURL);
		downloadXML(this.listURL);
	
		attachMovie("refresh_icon", "refresh", this.getNextHighestDepth());
		
		refresh._x=this.movie.swf._x;	
		refresh._y=this.movie.swf._y;
		
		refresh.component=this;
		refresh.onRelease=function(){
			var shapeData = this.component.so.data[this.component.page][this.text_name];
			shapeData.activeCaretIndex = Selection.getCaretIndex();
			shapeData.text=this.component.shapes[this.text_name].shape_txt.text;
			this._visible=false;
		}
		refresh._visible=false;
		this.initialize_shapes();
		this.setTool("pointer");
		
	/*
	 * Tanslation
	 */
	this.controls.pointer_btn.label = _root.stringsManager.get("WBPLUS_BTN_POINTER");
	_root.tooltip(this.controls.pointer_btn., _root.stringsManager.get("WBPLUS_BTN_POINTER_TT"));
	
	this.controls.arrow_btn.label = _root.stringsManager.get("WBPLUS_BTN_ARROW");
	_root.tooltip(this.controls.arrow_btn, _root.stringsManager.get("WBPLUS_BTN_ARROW_TT"));
	
	this.controls.clean_btn.label = _root.stringsManager.get("WBPLUS_BTN_CLEAN");
	_root.tooltip(this.controls.clean_btn, _root.stringsManager.get("WBPLUS_BTN_CLEAN_TT"));
	
	this.controls.pencil_btn.label = _root.stringsManager.get("WBPLUS_BTN_PENCIL");
	_root.tooltip(this.controls.pencil_btn, _root.stringsManager.get("WBPLUS_BTN_PENCIL_TT"));
	
	this.controls.highlight_btn.label = _root.stringsManager.get("WBPLUS_BTN_HIGHLIGHT");
	_root.tooltip(this.controls.highlight_btn, _root.stringsManager.get("WBPLUS_BTN_HIGHLIGHT_TT"));
	
	this.controls.circle_btn.label = _root.stringsManager.get("WBPLUS_BTN_CIRCLE");
	_root.tooltip(this.controls.circle_btn, _root.stringsManager.get("WBPLUS_BTN_CIRCLE_TT"));
	
	this.controls.rectangle_btn.label = _root.stringsManager.get("WBPLUS_BTN_RECTANGLE");
	_root.tooltip(this.controls.rectangle_btn, _root.stringsManager.get("WBPLUS_BTN_RECTANGLE_TT"));
	
	this.controls.text_btn.label = _root.stringsManager.get("WBPLUS_BTN_TEXT");
	_root.tooltip(this.controls.text_btn, _root.stringsManager.get("WBPLUS_BTN_TEXT_TT"));
	
	this.controls.line_label.text = _root.stringsManager.get("WBPLUS_LINE");
	this.controls.fill_label.text = _root.stringsManager.get("WBPLUS_FILL");
	_root.tooltip(this.controls.line_color, _root.stringsManager.get("WBPLUS_LINE_COLOR_TT"));
	_root.tooltip(this.controls.fill_color, _root.stringsManager.get("WBPLUS_FILL_COLOR_TT"));
	this.controls.linesize_label.text = _root.stringsManager.get("WBPLUS_LINESIZE");
	
	_root.tooltip(this.controls.size_combo, _root.stringsManager.get("WBPLUS_SIZE_COMBO_TT"));
	this.controls.size_combo.labels = [
		_root.stringsManager.get("WBPLUS_SIZE_COMBO_THIN"),
		_root.stringsManager.get("WBPLUS_SIZE_COMBO_MEDIUM"),
		_root.stringsManager.get("WBPLUS_SIZE_COMBO_HEAVY")
		];
		
	this.controls.presentation_label.text = _root.stringsManager.get("WBPLUS_PRESENTATION");
	
	this.controls.open_btn.label = _root.stringsManager.get("WBPLUS_BTN_OPEN");
	_root.tooltip(this.controls.open_btn, _root.stringsManager.get("WBPLUS_BTN_OPEN_TT"));
	
	this.controls.close_btn.label = _root.stringsManager.get("WBPLUS_BTN_CLOSE");
	_root.tooltip(this.controls.close_btn, _root.stringsManager.get("WBPLUS_BTN_CLOSE_TT"));
	
	this.controls.zoom_label.text = _root.stringsManager.get("WBPLUS_ZOOM");
	_root.tooltip(this.controls.zoom_stepper, _root.stringsManager.get("WBPLUS_STEPPER_ZOOM_TT"));
	this.controls.page_label.text = _root.stringsManager.get("WBPLUS_PAGE");
	_root.tooltip(this.controls.page_stepper, _root.stringsManager.get("WBPLUS_STEPPER_PAGE_TT"));
	}
	
	function rect(mc, x, y, w, h) {
			mc.moveTo(x, y);
			mc.lineTo(x+w, y);
			mc.lineTo(x+w, y+h);
			mc.lineTo(x, y+h);
			mc.lineTo(x, y);
	}
	function ellipse(mc, x, y, x2, y2) {
		// init variables
		var theta, xrCtrl, yrCtrl, angle, angleMid, px, py, cx, cy;
		// if only yRadius is undefined, yRadius = radius
		var radius = (x2-x)/2;
		var yRadius = (y2-y)/2;
		var center_x=x+((x2-x)/2);
		var center_y=y+((y2-y)/2);
		// covert 45 degrees to radians for our calculations
		theta = Math.PI/4;
		// calculate the distance for the control point
		xrCtrl = radius/Math.cos(theta/2);
		yrCtrl = yRadius/Math.cos(theta/2);
		// start on the right side of the circle
		angle = 0;
		mc.moveTo(x2, center_y);
	
		// this loop draws the circle in 8 segments
		for (var i = 0; i<8; i++) {
			// increment our angles
			angle += theta;
			angleMid = angle-(theta/2);
			// calculate our control point
			cx = center_x+Math.cos(angleMid)*xrCtrl;
			cy = center_y+Math.sin(angleMid)*yrCtrl;
			// calculate our end point
			px = center_x+Math.cos(angle)*radius;
			py = center_y+Math.sin(angle)*yRadius;
			// draw the circle segment
			mc.curveTo(cx, cy, px, py);
		}
	}
	
	function initialize_shapes(){
		this.cleanShapes();
		this.shapes.removeMovieClip();
		this.controls.swf.content.createEmptyMovieClip("shapes", this.controls.swf.content.getNextHighestDepth());		
		this.shapes = this.controls.swf.content.shapes;
		this.redrawShapes();
		this.controls.initialize_drawing_area();
		this.changePage(this.so.data.pageNum)
	}
	function onDisconnect():Void{
	}
	
	function onConnect(con:IConnector):Void {
		
		this.connector = con;	
		
		var listener = new Object();
		
		listener.onSync= function (list){

			for (var i in list) {
				if (list[i].name == "pageNum") {
					this.parent.changePage(this.data.pageNum);
					this.parent.controls.swf.content.gotoAndStop(this.data.pageNum);
				}
				else if (list[i].name != "swfFile" && list[i].code == "delete") {
					this.parent.cleanShapes();
				}
				else if (list[i].name == "vScroll") {
					this.parent.controls.swf.vPosition =  this.data.vScroll;
				}			
				else if (list[i].name == "hScroll") {
					this.parent.controls.swf.hPosition =  this.data.hScroll;
				}
				else if (list[i].name == "zoom") {
					this.parent.controls.zoom_stepper.value = this.data.zoom;
					this.parent.controls.swf.content._xscale =  this.data.zoom;
					this.parent.controls.swf.content._yscale =  this.data.zoom;
					this.parent.controls.swf.redraw(true);
				}
				else if (list[i].name == "swfFile") {
					if(this.parent.controls.isSPLoaded()){
						this.parent.loadPath(this.data.swfFile);
					}
					else{
						this.parent.controls.onSPLoaded(this.data.swfFile);
					}
				} 
				else{
					this.parent.redrawShapes();
				} 
			}
		}
			
		listener.onStatus=function(info:Object):Void{
			_root.Log.print("Error:", info);
		}
		this.so = this.connector.recordSharedObject("whiteboardplus", this, listener, this, true);
	}
	
	function loadPath(path:String){
		this.so.data.hScroll = 0;
		this.so.data.vScroll = 0;
		this.so.data.zoom = 100;
		this.loadProgress();
		this.movie.swf.contentPath = path;
	}
	
	function onStatus(info:Object):Void{
			_root.Log.print("Error IClientComponent:", info);
	}
	
	function newShape(shape:Object):Void{
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		
		if(this.so.data[""+this.page]==undefined){
			this.so.data[""+this.page] = new Array();
			this.so.data[""+this.page].push(shape);
		}
		else
			this.so.data[""+this.page].push(shape);	
	}
	
	function cleanAllPages():Void{
		for(var i=0; i<1000; i++)
			this.so.data[""+i] = null;
	}	
	function cleanAll():Void{
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		this.so.data[""+this.page] = null;
	}
	function getClass():String {
		return "WhiteboardPlus";
	}
	
	function setLineColor(color:Number){
		lineColor = color;
	}
	
	function setFillColor(color:Number){
		fillColor = color;
	}
	
	function setTool(t:String){
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
		{
			for(var i=0; i< buttons.length; i++){
				this.controls[buttons[i]+"_btn"].selected = false;
			}
		}
		
		if(t=="clean"){
			this.cleanAll();
			return;
		}
		if(t=="text"){
			for( var a in this.shapes )
				if( this.shapes[a].type=="text")
					this.shapes[a].shape_txt.selectable=true;
		}
		else{
			
			refresh._visible=false;
			for( var a in this.shapes )
				if( this.shapes[a].type=="text")
					this.shapes[a].shape_txt.selectable=false;
		}
		for(var i=0; i< buttons.length; i++){
			if(buttons[i] != t)
				this.controls[buttons[i]+"_btn"].selected = false;
		}
		tool = t;
	}
	
	function setLineSize(size:Number){
		lineSize = size;
	}

	function getLineColor():Number{
		return this.controls.line_color.color;
	}
	
	function getFillColor():Number{
		return this.controls.fill_color.color;
	}
	
	function getFillAlpha():Number{
		if(this.controls.fill_color.color==null)
			return 0;
		else
			return 75;
	}
	
	function getTool():String{
		return tool;
	}
	
	function getLineSize():Number{
		return lineSize;
	}
	
	function close():Void {
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		this.movie.unloadMovie();
		this.movie.removeMovieClip();
		this.unloadMovie();
		this.removeMovieClip();
	}

	function setSize(newWidth:Number, newHeight:Number):Void {
		this.initialize_shapes();
		this.controls.setSize(newWidth,newHeight);
	}
	
	function getPreferredSize():Size {
			var size=new Object();
			size.width=400;
			size.height=452;
			return(size);
	
	}
	function getMinimumSize():Size {
			var size=new Object();
			size.width=250;
			size.height=452;
			return(size);
	}

	function redrawShapes() {
		this.cleanShapes();
		for( var a in this.so.data[""+this.page] ){
			this.shapes.createEmptyMovieClip(a, a);
			var shape = this.so.data[""+this.page][a];
			this.drawShape(shape, this.shapes[a]);
		}
	}
	function polarConversion(r, t) {
		// Converts Polar coordinates to Cartisian Coordinates
		// r = radius, t = theta in decimal
		// returns an object with the x and y position
		var x = r * Math.cos(t * (Math.PI / 180));
		var y = r * Math.sin(t * (Math.PI / 180));
		return {x:x, y:y};
	}
	function lineAngle(x1, y1, x2, y2) {
		// Calculates the angle between two points
		// x1, y1 = the start of a line. x2, y2 = the end of a line
		// returns a decimal angle from -180 to 180
		return Math.atan2((y2 - y1), (x2 - x1)) * (180 / Math.PI);
	}
	
	function closePresentation(){
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		var dialog = this._parent.createDialogBox("QuestionBox");
		dialog.setTitle(_root.stringsManager.get("WBPLUS_CLEAN_TITLE"));
		dialog.setLabel(_root.stringsManager.get("WBPLUS_CLEAN_MSG"));
		
		var dialogResponse = new Object();
		dialogResponse.parent=this;
		dialogResponse.win=dialog;
	
		dialogResponse.close = function (evt_obj:Object) {
			if(evt_obj.label=="Yes"){
				this.parent.cleanAllPages();
			}
			if(evt_obj.label=="Cancel"){
				this.win.removeMovieClip();
				return;
			}
			this.parent.clearSWF();
			this.win.removeMovieClip();
		};
		dialog.addEventListener("close", dialogResponse);
	}
	function drawShape(shapeData, clip) {
		clip.type=shapeData.type;
		for (var a in shapeData)
			clip[a]=shapeData[a];
		clip.clear();
		clip.component=this;
		clip.onPress=function(){
			////trace(this+"onPress: "+this.component);
			this.component.shapePress(this);
		}
		clip.onRelease=clip.onReleaseOutside=function(){
			////trace(this+"onRelease: "+this.component);
			this.component.shapeRelease(this);
		}

		if (clip.type == "rectangle") {
					
			clip.lineStyle (clip.lineSize, clip.lineColor);
			
			clip.beginFill (clip.fillColor, clip.fillAlpha);
			
			rect(clip, clip.x, clip.y , clip.x2-clip.x, clip.y2-clip.y);
			
			clip.endFill ();
			
		}
		if (clip.type == "circle") {

			clip.lineStyle(clip.lineSize, clip.lineColor);
			
			clip.beginFill (clip.fillColor, clip.fillAlpha);
			
			ellipse(clip, clip.x, clip.y , clip.x2, clip.y2);
			
			clip.endFill ();
		}
		if (clip.type == "text") {
	
			clip.createTextField("shape_txt", 20, shapeData.x, shapeData.y, 50, 20);
			var boxTextFormat_fmt = new TextFormat();
			boxTextFormat_fmt.align = "center";
			boxTextFormat_fmt.bold = true;
			boxTextFormat_fmt.font = "Arial";
			boxTextFormat_fmt.size = clip.lineSize*8;
			clip.shape_txt.setNewTextFormat(boxTextFormat_fmt);
			clip.shape_txt.textColor = clip.lineColor;
			clip.shape_txt.border = true;
			clip.shape_txt.multiline = true;
			clip.shape_txt.autoSize = "center";
			clip.shape_txt.type = "input";
			clip.shape_txt.text = clip.text;
			clip.shape_txt.onChanged = function() {
				/*trace("Changing: "+ this+" t: "+ this.text);
				for( var a in this._parent.component.shapes ){
					trace(this._parent.component.shapes[a]+" - "+this._parent.component.shapes[a].shape_txt.text);
				}*/
				this._parent.component.refresh._visible=true;
			};
			clip.shape_txt.selectable = ( this.getTool()=="text"? true : false );
			
			if(clip.activeCaretIndex==undefined)
				clip.activeCaretIndex=0;
			
			clip.createEmptyMovieClip("dragger", clip.getNextHighestDepth());
			var dragger = clip.dragger;
			dragger._x = shapeData.x;
			dragger._y = shapeData.y;
			//dragger.lineStyle(1, 0x0000ff);
			dragger.beginFill(0x000000, 0);
			dragger.moveTo(-clip.shape_txt.textWidth / 2 + 10, -7);
			dragger.lineTo(clip.shape_txt.textWidth / 2 + 40, -7);
			dragger.lineTo(clip.shape_txt.textWidth / 2 + 40, clip.shape_txt.textHeight + 10);
			dragger.lineTo(-clip.shape_txt.textWidth / 2 + 10, clip.shape_txt.textHeight + 10);
			dragger.lineTo(-clip.shape_txt.textWidth / 2 + 10, -7);
	
			dragger.endFill();
			dragger.onPress = function() {
				this._parent.component.shapePress(this._parent);
			};
			dragger.onRelease = dragger.onReleaseOutside = function () {
				this._parent.component.shapeRelease(this._parent);
			};
		}
		if(clip.type=="highlight"){
			clip.lineStyle (clip.lineSize*4, clip.lineColor, 50);
			clip.moveTo(clip.x, clip.y);
			for( var a=0 ; a<clip.points.length; a++)
				clip.lineTo(clip.points[a].x, clip.points[a].y);
			clip.lineTo(clip.x2, clip.y2);
		}
		if(clip.type=="pencil"){
			clip.lineStyle (clip.lineSize, clip.lineColor);
			clip.moveTo(clip.x, clip.y);
			for( var a=0 ; a<clip.points.length; a++)
				clip.lineTo(clip.points[a].x, clip.points[a].y);
			clip.lineTo(clip.x2, clip.y2);
		}
		if (clip.type == "arrow") {
			clip.lineStyle (clip.lineSize, clip.lineColor);

			clip.moveTo(clip.x, clip.y);
			clip.lineTo(clip.x2, clip.y2);
			
			var angle = this.lineAngle(clip.x, clip.y, clip.x2, clip.y2);
			var offsetA = this.polarConversion(10, angle + 135);
			var offsetB = this.polarConversion(10, angle - 135);
			
			clip.lineTo(clip.x2 + offsetA.x, clip.y2 + offsetA.y);
			clip.moveTo(clip.x2, clip.y2);
			clip.lineTo(clip.x2 + offsetB.x, clip.y2 + offsetB.y);
		}
	}
	
	function shapePress(shape) {
		if(this.getTool()=="text" && shape.type=="text"){
			shape.shape_txt.selectable=true;
			refresh._visible=true;
			refresh.text_name=shape._name;
			Selection.setFocus(shape.shape_txt);
			Selection.setSelection(shape.activeCaretIndex, shape.activeCaretIndex);
		}
		else{
			refresh._visible=false;
		}
		if(this.getTool()!="pointer")
			return;
		this.drag_x = this.controls.getX();
		this.drag_y = this.controls.getY();
		
		var coord = shape.getBounds(shape._parent);

		shape.createEmptyMovieClip("active", this.getNextHighestDepth());
		shape.active.lineStyle(3, 0x0000FF,100);
		shape.active.drawRect( coord.xMin, coord.yMin , coord.xMax-coord.xMin, coord.yMax-coord.yMin);
		
		
		this.drag_min_x=this.controls.getX()-coord.xMin;
		this.drag_min_y=this.controls.getY()-coord.yMin;
		this.drag_max_x=this.controls.getX()-coord.xMax;
		this.drag_max_y=this.controls.getY()-coord.yMax;
		
		/*this.selectedShape = shape;
		clearInterval(this.activeId);
		this.activeId = setInterval(this, "activeShape", 50, shape);		
		*/
		
		shape.startDrag(false, 0 - coord.xMin, 0  - coord.yMin, this.controls.drawing_area._width -coord.xMax, this.controls.drawing_area._height - coord.yMax);
	}

	function shapeRelease(shape) {
		if(this.getTool()!="pointer")
			return;
		shape.active.clear();
		shape.active.removeMovieClip();
		shape.stopDrag();
		
		var coord = shape.getBounds(shape._parent);
		
		var shapeData = this.so.data[this.page][shape._name];
	
		var last_x=Math.max(0+this.drag_min_x,Math.min(this.controls.getX(), this.controls.drawing_area._width+this.drag_max_x));
		var last_y=Math.max(0+this.drag_min_y,Math.min(this.controls.getY(), this.controls.drawing_area._height+this.drag_max_y));
		
		if (this.drag_x != last_x || this.drag_y != last_y) {
			var delta_x = (last_x - this.drag_x);
			var delta_y = (last_y - this.drag_y);
			shapeData.x += delta_x;
			shapeData.y += delta_y;
	
			shapeData.x2 += delta_x;
			shapeData.y2 += delta_y;
			
			if(shapeData.type=="pencil" || shapeData.type=="highlight"){
				for(var i=0; shapeData.points[i]; i++){
					shapeData.points[i].x+=delta_x;
					shapeData.points[i].y+=delta_y;
				}
			}
		}
	}
	function cleanShapes() {
		for( var a in this.shapes ){
			this.shapes[a].clear();
			this.shapes[a].removeMovieClip();
			this.shapes.clear();
		}
	}
	
	function changePage(num:Number) {
		this.page = num;
		this.controls.setPage(num);
		this.redrawShapes();
	}
	
	function toPage(num:Number) {
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		this.so.data.pageNum = num;
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
		dialog.setTitle(_root.stringsManager.get("WBPLUS_CHOOSE_FILE_TITLE"));
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
				this._parent.newError(_root.stringsManager.get("WBPLUS_ERROR_LOAD") + " " + this.listURL, true);
			}
		}
	}

	function scroll (h:Number,v:Number) {
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
		
		this.so.data.hScroll = h;
		this.so.data.vScroll = v;
	}

	function zoom(z:Number) {
		
		var info = _root.getUserInformation();
		if(info.role != "moderator" && 
		   info.star != "moderator" &&
		   info.role != "poweruser" && 
		   info.star != "poweruser" )
			return;
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
		dialog.setTitle(_root.stringsManager.get("WBPLUS_LOAD_TITLE"));
		var dialogProgress = new Object();
		dialogProgress.parent=this;
		dialogProgress.win=dialog;
	
		dialogProgress.close = function (evt_obj:Object) {
			this.win.removeMovieClip();			
		};
		
		dialogProgress.progress = function (evt_obj:Object) {
			var spane = this.parent.movie.swf;
			this.win.setTitle(_root.stringsManager.get("WBPLUS_LOAD_PROGRESS_TITLE"));
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
		this.toPage(1);
		this.movie.swf.content.gotoAndStop(1);
	}
	function clearSWF() {
		this.toPage(1);
		this.loadSWF("none.swf");
	}
}