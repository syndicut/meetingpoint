import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.ButtonMaximize extends MovieClip{

	var restore:Boolean

	function ButtonMaximize() {
			this.draw();
			this.restore=true;
	}
	
	function getRestore() {
	
		return this.restore;
		
	}
	
	function setRestore(value) {
		this.restore=value;
		this.draw();
		
	}
		
	function draw() {
			this.clear();
	
			var style = this._parent.getWindowStyle();
	
			this.beginFill(style.maximizeFillColor, style.maximizeTrasparency);
			this.lineStyle(1,style.maximizeBorderColor,100,true);
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
	
			if(this.restore){
				this.lineStyle(1,style.maximizeIconColor,100,true);
				this.moveTo(3,3);
				this.lineTo(3, 10);
				this.lineTo(10, 10);
				this.lineTo(10, 3);
				this.lineStyle(2,style.maximizeIconColor,100,true);
				this.moveTo(3.5,3);
				this.lineTo(10, 3);
			}
			else{
				this.lineStyle(1,style.maximizeIconColor,100,true);
				this.moveTo(3,3);
				this.lineTo(3, 8);
				this.lineTo(8, 8);
				this.lineTo(8, 2);
				this.lineStyle(2,style.maximizeIconColor,100,true);
				this.moveTo(3.5,3);
				this.lineTo(8, 3);
				
				this.lineStyle(1,style.maximizeIconColor,100,true);
				this.moveTo(6,6);
				this.lineTo(6,11);
				this.lineTo(11, 11);
				this.lineTo(11, 6);
				this.lineStyle(2,style.maximizeIconColor,100,true);
				this.moveTo(6,6);
				this.lineTo(11, 6);
			}
	}
}
