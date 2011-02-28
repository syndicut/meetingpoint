import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.ButtonClose extends MovieClip{

	function ButtonClose() {
		this.draw();
	}
	
	function draw() {
	
			this.clear();
	
			var style = this._parent.getWindowStyle();
	
			this.beginFill(style.closeFillColor, style.closeTrasparency);
			this.lineStyle(1,style.closeBorderColor,100,true);
			var angle = 3;
			var size = 13;
			this.moveTo(angle,0);
			this.curveTo(0,0,0,angle);
			this.lineTo(0,size-angle);
			this.curveTo(0,size,angle,size);
			this.lineTo(size-angle,size);
			this.curveTo(size,size,size,size-angle);
			this.lineTo(size,angle);
			this.curveTo(size,0, size-angle,0);
			this.lineTo(angle,0);
			this.endFill();
			
			var l = size-angle;
			var r = size-l;
			
			this.lineStyle(2,style.closeIconColor,100,true);
			this.moveTo(r,r);
			this.lineTo(l,l);
			this.moveTo(r,l);
			this.lineTo(l,r);
			
	}
}
