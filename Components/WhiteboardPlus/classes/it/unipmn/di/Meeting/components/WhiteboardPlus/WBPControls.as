import it.unipmn.di.Meeting.Utils.Size;
import mx.containers.ScrollPane;
import mx.core.UIObject;

import org.sepy.ColorPicker.*;
import mx.component.Button;

class it.unipmn.di.Meeting.components.WhiteboardPlus.WBPControls extends MovieClip{
	var line_color:MovieClip
	var fill_color:MovieClip
	var bg:MovieClip
	var page_stepper:MovieClip
	var page_label:MovieClip
	var zoom_stepper:MovieClip
	var zoom_label:MovieClip
	var drawing_area:MovieClip
	var shape:Object
	var swf:MovieClip
	var spLoaded:Boolean = false
	var spContentPath:String = null

	function WBPControls(){
		this.shape = new Object();
		
		//this.createEmptyMovieClip("drawing_area", this.getNextHighestDepth());

		this.fill_color.swapDepths(this.getNextHighestDepth());
		this.line_color.swapDepths(this.getNextHighestDepth());
		
		this.initialize_drawing_area();
	}
	function onSPLoaded(path){
		spContentPath = path;
	}
	function isSPLoaded(){
		return spLoaded;
	}
	function scrollPaneLoaded(){
		spLoaded=true;
		if(spContentPath!=null){
			this._parent.loadPath(spContentPath);
		}
	}
	
	function initialize_drawing_area(){
		this.drawing_area.temp_clip.clear();
		this.drawing_area.temp_clip.removeMovieClip();
		
		this.drawing_area.clear();
		this.drawing_area.removeMovieClip();
		
		this.swf.content.createEmptyMovieClip("drawing_area", this.swf.content.getNextHighestDepth());
		this.drawing_area = this.swf.content.drawing_area;
		
		this.drawing_area.createEmptyMovieClip("temp_clip", this.drawing_area.getNextHighestDepth());
				
		this.drawing_area._parent = this;
		this.drawing_area.onPress=function(){
			//trace("onPress: "+this._parent.getX()+" "+this._parent.getY());
			var shape = new Object();
			
			shape.id = Math.round(Math.random()*1000);			
			shape.points = undefined;
			shape.type = this._parent._parent.getTool();
			shape.x = this._parent.getX();
			shape.y = this._parent.getY(); 
			shape.lineColor = this._parent._parent.getLineColor();
			shape.fillColor = this._parent._parent.getFillColor();
			shape.fillAlpha = this._parent._parent.getFillAlpha();
			shape.lineSize = this._parent._parent.getLineSize();

			switch(this._parent._parent.getTool()){
				case "pointer":
					return;
					break;
				case "arrow":
					this.onMouseMove=this.drawArrow;
					break;
				case "circle":
					this.onMouseMove=this.drawCircle;
					break;
				case "rectangle":
					this.onMouseMove=this.drawRectangle;
					break;
				case "pencil":
					shape.points = new Array();
					this.onMouseMove=this.drawPencil;
					break;
				case "highlight":
					shape.points = new Array();
					this.onMouseMove=this.drawHighlight;
					break;
				case "text":
					break;
				default:
					return;
					//trace("bho");
			}
			this._parent.shape = shape
			this.draw_drawing_area();
		}
		this.drawing_area.polarConversion = function(r, t) {
			// Converts Polar coordinates to Cartisian Coordinates
			// r = radius, t = theta in decimal
			// returns an object with the x and y position
			var x = r * Math.cos(t * (Math.PI / 180));
			var y = r * Math.sin(t * (Math.PI / 180));
			return {x:x, y:y};
		}
		this.drawing_area.lineAngle = function(x1, y1, x2, y2) {
			// Calculates the angle between two points
			// x1, y1 = the start of a line. x2, y2 = the end of a line
			// returns a decimal angle from -180 to 180
			return Math.atan2((y2 - y1), (x2 - x1)) * (180 / Math.PI);
		}
		this.drawing_area.drawArrow=function(){
			//trace("drawArrow");
			this.temp_clip.clear();
			this.temp_clip.swapDepths(this.getNextHighestDepth());
			var x2 = this._parent.getX();
			var y2 = this._parent.getY();
			
			this.temp_clip.lineStyle (this._parent.shape.lineSize, this._parent.shape.lineColor);
			
			
			this.temp_clip.moveTo(this._parent.shape.x, this._parent.shape.y);
			this.temp_clip.lineTo(x2, y2);
			
			var angle = this.lineAngle(this._parent.shape.x, this._parent.shape.y, x2, y2);
			var offsetA = this.polarConversion(10, angle + 135);
			var offsetB = this.polarConversion(10, angle - 135);
			
			this.temp_clip.lineTo(x2 + offsetA.x, y2 + offsetA.y);
			this.temp_clip.moveTo(x2, y2);
			this.temp_clip.lineTo(x2 + offsetB.x, y2 + offsetB.y);			
		}
		this.drawing_area.drawCircle=function(){
			this.temp_clip.clear();
			this.temp_clip.swapDepths(this.getNextHighestDepth());
			var x2 = this._parent.getX();
			var y2 = this._parent.getY();
					
			this.temp_clip.lineStyle (this._parent.shape.lineSize, this._parent.shape.lineColor);
			this.temp_clip.beginFill (this._parent.shape.fillColor, this._parent.shape.fillAlpha);
			this.temp_clip._parent._parent._parent.ellipse(this.temp_clip, this._parent.shape.x, this._parent.shape.y , x2, y2);
			this.temp_clip.endFill ();
		}
		this.drawing_area.drawHighlight=function(){
			var tmp_x = this._parent.getX();
			var tmp_y = this._parent.getY();
			this.temp_clip.swapDepths(this.getNextHighestDepth());
			this.temp_clip.lineStyle (this._parent.shape.lineSize*4, this._parent.shape.lineColor, 50);
			
			if(this._parent.shape.points.length == 0)
			{
				this.temp_clip.clear();
				this._parent.shape.points.push({x:tmp_x,y:tmp_y});
				this.temp_clip.moveTo(this._parent.shape.x, this._parent.shape.y);
				this.temp_clip.lineTo(tmp_x, tmp_y);
				return;
			}
			var dl = this._parent.shape.points[this._parent.shape.length-1];
			if( (tmp_x <= dl.x-2 || tmp_x >= dl.x+2) || (tmp_y <= dl.y-2 || tmp_y >= dl.y+2) ){
				this._parent.shape.points.push({x:tmp_x,y:tmp_y});
				this.temp_clip.lineTo(tmp_x, tmp_y);
			}	

		}
		this.drawing_area.drawPencil=function(){
			var tmp_x = this._parent.getX();
			var tmp_y = this._parent.getY();
			this.temp_clip.swapDepths(this.getNextHighestDepth());
			this.temp_clip.lineStyle (this._parent.shape.lineSize, this._parent.shape.lineColor);
			if(this._parent.shape.points.length == 0)
			{
				this.temp_clip.clear();
				this._parent.shape.points.push({x:tmp_x,y:tmp_y});
				this.temp_clip.moveTo(this._parent.shape.x, this._parent.shape.y);
				this.temp_clip.lineTo(tmp_x, tmp_y);
				return;
			}
			var dl = this._parent.shape.points[this._parent.shape.length-1];
			if( (tmp_x <= dl.x-2 || tmp_x >= dl.x+2) || (tmp_y <= dl.y-2 || tmp_y >= dl.y+2) ){
				this._parent.shape.points.push({x:tmp_x,y:tmp_y});
				this.temp_clip.lineTo(tmp_x, tmp_y);
			}	

		}
		this.drawing_area.drawRectangle=function(){
			var x2 = this._parent.getX();
			var y2 = this._parent.getY();
			
			this.temp_clip.swapDepths(this.getNextHighestDepth());
			
			this.temp_clip.lineStyle (this._parent.shape.lineSize, this._parent.shape.lineColor);
			
			this.temp_clip.beginFill (this._parent.shape.fillColor, this._parent.shape.fillAlpha);
			
			this.temp_clip._parent._parent._parent.rect(this.temp_clip, this._parent.shape.x, this._parent.shape.y , x2-this._parent.shape.x, y2-this._parent.shape.y);
			
			this.temp_clip.endFill ();
		}
		this.drawing_area.onRelease=this.drawing_area.onReleaseOutside=function(){
			this.onMouseMove=null;
			this.temp_clip.clear();

			switch(this._parent._parent.getTool()){
				case "pointer":
					return;
				case "arrow":
					break;
				case "circle":
					break;
				case "rectangle":
					break;
				case "pencil":
					break;
				case "highlight":
					break;
				case "text":
					this._parent.shape.text="Empty";
					break;
				default:
					//trace("bho");
					return;
			}
			
			this._parent.shape.x2 = this._parent.getX();
			this._parent.shape.y2 = this._parent.getY(); 
			
			
			this._parent._parent.newShape(this._parent.shape);
		}
		this.draw_drawing_area(this.swf.last_width,this.swf.last_height);
	}
	
	function setPage(num:Number){
		this.page_stepper.value = num;
		this.swf.content.gotoAndStop(num);
	}
	
	function setSize(newWidth:Number,newHeight:Number){
		var width = newWidth-this.bg._width;
		this.swf.setSize(width, newHeight);
		
		draw_drawing_area(width,newHeight)
		
		this.swf.last_width=width;
		this.swf.last_height=newHeight;
		this.bg._height=newHeight+1;
		
		this.zoom_stepper._y=newHeight-68;
		this.zoom_label._y=newHeight-86;
		this.page_stepper._y=newHeight-25;
		this.page_label._y=newHeight-43;
	}

	function draw_drawing_area(newWidth:Number,newHeight:Number){
		//trace("content w:"+this.swf.content._width+ "  h:"+this.swf.content._height);
		this.drawing_area.swapDepths(this.swf.getNextHighestDepth());
		this.drawing_area.clear();
		this.drawing_area.lineStyle(1, 0x000000, 0);
		this.drawing_area.beginFill (0x000000, 0);
		this.drawing_area.moveTo(0, 0);
		this.drawing_area.lineTo(Math.max(newWidth,this.swf.content._width*(this.swf.content._xscale/100)), 0);
		this.drawing_area.lineTo(Math.max(newWidth,this.swf.content._width*(this.swf.content._xscale/100)), Math.max(newHeight,this.swf.content._height*(this.swf.content._yscale/100)));
		this.drawing_area.lineTo(0, Math.max(newHeight,this.swf.content._height*(this.swf.content._yscale/100)));
		this.drawing_area.lineTo(0, 0);
		
		this.drawing_area.endFill ();
	}
	
	function getX():Number{
		return Math.max(0+this._parent.getLineSize(), Math.min(this.drawing_area._width-this._parent.getLineSize(), this.drawing_area._xmouse));
	}
	function getY():Number{
		return Math.max(0+this._parent.getLineSize(), Math.min(this.drawing_area._height-this._parent.getLineSize(), this.drawing_area._ymouse));
	}
	
	
}
	