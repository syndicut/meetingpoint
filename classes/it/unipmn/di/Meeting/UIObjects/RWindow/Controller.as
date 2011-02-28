import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.Controller extends MovieClip{

	var gearButton:MovieClip
	var bg:MovieClip
	var grip:MovieClip
	
	function Controller() {
		
		this.createEmptyMovieClip("bg", this.getNextHighestDepth());

		this.attachMovie("GearButton", "gearButton",this.getNextHighestDepth());
		
		this.gearButton._width=this.gearButton._height=15;
		this.gearButton._x=1;
		this.gearButton._y=1;
		
		this.attachMovie("Grip", "grip",this.getNextHighestDepth());
		
		
		/*this.createTextField("status_txt",this.getNextHighestDepth(),3,3,100,19);
		
		var style = this._parent.getWindowStyle();
		var my_fmt = new TextFormat();
		my_fmt.bold = false;
		my_fmt.font = "Arial";
		my_fmt.size = 10;
		my_fmt.color = style.statusMessageColor;
		this.status_txt.setNewTextFormat(my_fmt);
		this.status_txt.autoSize=true;	
		this.status_txt.selectable = false;
		*/
		
		this.gearButton.onRelease=this.gearButton.onReleaseOutside=function(){
			var info = _root.getUserInformation();
			if(info.role!="poweruser" && info.star!="poweruser")
				return;
			var menu = this._parent._parent.getMenu();
			menu.clicked=true;
			menu.show(this._x+this._parent._x+this._parent._parent._x,this._parent._y+this._parent._parent._y-menu.height);
		
		}
		this.bg.onPress=function(){
			var info = _root.getUserInformation();
			if(info.role!="poweruser" && info.star!="poweruser")
				return;
			this._parent._parent.setFocus();
			this._parent._parent.setUrgencyHint(false);
		}
		this.grip.onPress=function(){
			var info = _root.getUserInformation();
			if(info.role!="poweruser" && info.star!="poweruser")
				return;
			this._parent._parent.setFocus();
			this._parent._parent.setUrgencyHint(false);
			this._parent._parent.lockWindow(true);
			if(this._parent._parent.needToHideContentOnResize())
				this._parent._parent.hideContent();
			this._parent.startX=this._parent._parent._xmouse;
			this._parent.startY=this._parent._parent._ymouse;
			var size = this._parent._parent.getSize();
			this._parent.startW=size.width;
			this._parent.startH=size.height;
		
			this.onMouseMove=function(){
				
				var newW=this._parent.startW+(this._parent._parent._xmouse-this._parent.startX);
				var newH=this._parent.startH+(this._parent._parent._ymouse-this._parent.startY);

				var pos = this._parent._parent.getPosition();
				var limits = this._parent._parent._parent.getContentLimits();
								
				
				if(newW<150) newW=150;
				if(newH<100) newH=100;
				
				
				var maxX = Math.min(Math.floor(newW), Math.floor(limits.right-pos.x));
				var maxY = Math.min(Math.floor(newH), Math.floor(limits.bottom-pos.y));
				
				this._parent._parent.setSize(Math.floor(maxX),Math.floor(maxY));
			}
		}
		this.grip.onReleaseOutside = this.grip.onRelease=function(){
			this.onMouseMove=null;
			
			var info = _root.getUserInformation();
			if(info.role!="poweruser" && info.star!="poweruser")
				return;
			
			if(this._parent._parent.needToHideContentOnResize())
				this._parent._parent.showContent();
			this._parent._parent.lockWindow(false);
			this._parent._parent.onSizeModification();
			this._parent._parent.setState("normal");
		}
	}
	function getWindowStyle() {
	
		return this._parent.getWindowStyle();
		
	}
	
	function getSize() {
		var size = new Object();
		
		size.height= this._height;
		
		size.width=this._width;
		
		return size;
		
	}
	
	function setSize(newWidth, newHeight) {
			this._y = newHeight-15;
			this.grip._x= newWidth - 13;
			this.grip._y=2;
			this.clear();
			this.bg.clear();
			
			var style = this._parent.getWindowStyle();
			if(style.fillColorGradient){
				if(style.fillColorGradientMatrixAdapted){
					style.fillColorGradientMatrix.x=0;
					style.fillColordGradientMatrix.y=0;
					style.fillColorGradientMatrix.w=newWidth;
					style.fillColorGradientMatrix.h=18;
				}
				
				this.bg.beginGradientFill( "linear",
									   style.fillColorGradientColors,
									   style.fillColorGradientAlphas, 
									   style.fillColorGradientRatios, 
									   style.fillColorGradientMatrix );
			}
			else				
				this.bg.beginFill(style.fillColor, style.controllerTrasparency);
			this.bg.lineStyle(1,style.borderColor,100,true);
			
			var angle=4;
			var size = 15;
			this.bg.moveTo(0,0);
			this.bg.lineTo(newWidth,0);
			this.bg.lineTo(newWidth,size-angle);
			this.bg.curveTo(newWidth,size,newWidth-angle,size);
			this.bg.lineTo(angle,size);
			
			this.bg.curveTo(0,size,0,size-angle);
			this.bg.lineTo(0,0);
			this.bg.endFill();
			
	}
}
