import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.ButtonMinimize extends MovieClip{

	function ButtonMinimize() {
			this.draw();
	}
	
	function draw() {
	
			this.clear();
	
			var style = this._parent.getWindowStyle();
	
			this.beginFill(style.minimizeFillColor, style.minimizeTrasparency);
			this.lineStyle(1,style.minimizeBorderColor,100,true);
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
	
			this.lineStyle(2,style.minimizeIconColor,100,true);
			this.moveTo(2,10);
			this.lineTo(10,10);
			
	}
}
