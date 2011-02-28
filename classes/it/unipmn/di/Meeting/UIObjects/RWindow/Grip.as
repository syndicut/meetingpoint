import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.Grip extends MovieClip{
	function Grip() {
		this.draw();
	}
	function draw(){
		this.clear();
	
		var style = this._parent.getWindowStyle();
		this.lineStyle(1,style.gripColor);
		
		this.moveTo(0,12);
		this.lineTo(12,0);
		this.moveTo(4,12);
		this.lineTo(12,4);
		this.moveTo(8,12);
		this.lineTo(12,8);
	}
}
