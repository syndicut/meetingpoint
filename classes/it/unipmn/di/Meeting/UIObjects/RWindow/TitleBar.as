import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.TitleBar extends MovieClip{
	var title_txt:TextField
	
	function TitleBar() {
		
		this.createTextField("title_txt",this.getNextHighestDepth(),5,5,100,21);
	
		var style = this._parent.getWindowStyle();
		var my_fmt = new TextFormat();
		my_fmt.bold = true;
		my_fmt.font = "Arial";
		my_fmt.size = 11;
		my_fmt.color = style.titleColor;
		this.title_txt.setNewTextFormat(my_fmt);
		this.title_txt.autoSize=true;		
	}
	
	function setTitle (title) {
		this.title_txt.text = title;
	}
	function onPress () {
		var info = _root.getUserInformation();
		if(info.role!="poweruser" && info.star!="poweruser")
			return;
		this._parent.lockWindow(true);
		this._parent.setUrgencyHint(false);
		
		if(this._parent.needToHideContentOnMove())
			this._parent.hideContent();
			
		this._parent.setFocus();
		
		var limits = this._parent._parent.getContentLimits();
		var size = this._parent.getSize();
		
		this._parent.startDrag(false, limits.left+1, limits.top, limits.right - size.width - 1, Math.floor(limits.bottom-size.height));
		var style = this._parent.getWindowStyle();
		this.title_txt.textColor = style.titleSelectedColor;
	}
	
	function onReleaseOutside(){
		
		this._parent.stopDrag();
		var info = _root.getUserInformation();
		if(info.role!="poweruser" && info.star!="poweruser")
			return;
		if(this._parent.needToHideContentOnMove())
			this._parent.showContent();
		var style = this._parent.getWindowStyle();
		this.title_txt.textColor = style.titleColor;
		this._parent.moveTo(this._parent._x,this._parent._y);
		this._parent.lockWindow(false);
		this._parent.onPositionModification();
		
		
	}
	
	function onRelease () {
		this._parent.stopDrag();
		var info = _root.getUserInformation();
		if(info.role!="poweruser" && info.star!="poweruser")
			return;
		if(this._parent.needToHideContentOnMove())
			this._parent.showContent();
		var style = this._parent.getWindowStyle();
		this.title_txt.textColor = style.titleColor;
		this._parent.moveTo(this._parent._x,this._parent._y);
		this._parent.lockWindow(false);
		this._parent.onPositionModification();
	}
	
	function getSize () {
		var size = new Size();
		
		size.height= this._height;
		
		size.width=this._width;
		
		return size;
		
	}
	
	function normal () {
			var width = this._width;
			var style = this._parent.getWindowStyle();
			this.title_txt._y = 3;
			this.title_txt.textColor = style.titleColor;
			this.clear();
			if(style.fillColorGradient){
				if(style.fillColorGradientMatrixAdapted){
					style.fillColorGradientMatrix.x=0;
					style.fillColordGradientMatrix.y=0;
					style.fillColorGradientMatrix.w=width-1;
					style.fillColorGradientMatrix.h=30;
				}
				this.beginGradientFill( "linear",
									   style.fillColorGradientColors,
									   style.fillColorGradientAlphas, 
									   style.fillColorGradientRatios, 
									   style.fillColorGradientMatrix );
			}
			else				
				this.beginFill(style.fillColor, style.controllerTrasparency);
			this.lineStyle(1,style.borderColor,100,true);
			this.draw(width-1);
			this.endFill();		
	}
	
	function inverted () {
			var width = this._width;
			var style = this._parent.getWindowStyle();
			this.title_txt._y = 3;
			this.title_txt.textColor = style.titleSelectedColor;
			this.clear();
			if(style.fillColorGradient){
				if(style.fillColorGradientMatrixAdapted){
					style.fillColorGradientMatrix.x=0;
					style.fillColordGradientMatrix.y=0;
					style.fillColorGradientMatrix.w=width-1;
					style.fillColorGradientMatrix.h=30;
				}
				this.beginGradientFill( "linear",
									   style.fillColorGradientColors,
									   style.fillColorGradientAlphas, 
									   style.fillColorGradientRatios, 
									   style.fillColorGradientMatrix );
			}
			else				
				this.beginFill(style.borderColor, style.controllerTrasparency);
			this.lineStyle(1,style.fillColor,100,true);
	
			this.draw(width-1);
	
			this.endFill();	
	
	}
	
	function draw (width) {
			var angle=4;
			var barHeight = 20;
			this.moveTo(angle,0);
			this.curveTo(0,0,0,angle);
			this.lineTo(0, barHeight);
			this.lineTo(width,barHeight);
			this.lineTo(width,angle);
			this.curveTo(width,0,width-angle,0);
			this.lineTo(angle,0);
	}
	
	function setSize (newWidth, newHeight) {
			this.title_txt._y = 3;
	
			this.clear();
			var style = this._parent.getWindowStyle();
			if(style.fillColorGradient){
				if(style.fillColorGradientMatrixAdapted){
							style.fillColorGradientMatrix.x=0;
							style.fillColordGradientMatrix.y=0;
							style.fillColorGradientMatrix.w=newWidth;
							style.fillColorGradientMatrix.h=30;
				}
				this.beginGradientFill( "linear",
									   style.fillColorGradientColors,
									   style.fillColorGradientAlphas, 
									   style.fillColorGradientRatios, 
									   style.fillColorGradientMatrix );
			}
			else	
				this.beginFill(style.fillColor, style.controllerTrasparency);
			this.lineStyle(1,style.borderColor,100,true);
		
			this.draw(newWidth);
			
			//this._width=newWidth;
			
	}

}
