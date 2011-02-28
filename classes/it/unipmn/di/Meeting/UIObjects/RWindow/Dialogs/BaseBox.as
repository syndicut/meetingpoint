import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;

class it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.BaseBox extends MovieClip{

	var events:Array;
	var bg:MovieClip;
	var controls:MovieClip
	
	function addEventListener(eventType:String, listener:Object) {
		var newEvent = new Object();
		newEvent.type=eventType;
		newEvent.action=listener;
		this.events[this.events.length]=newEvent;
		
	}
	
	function setLabel(label:String) {
		this.controls.label.text=label;
		this.controls.label.autoSize=true;
	
	}
	
	function BaseBox() {
				
		this.swapDepths(9999);
		
		this.events=new Array();
		
	}
		
	function drawBackground(width:Number, height:Number){
		
		this.createEmptyMovieClip("bg",0);
		this.controls.swapDepths(1);
		this.bg.beginFill(0x333333, 75);
		this.bg.lineStyle(1,0x000000,0,true);
		this.bg.moveTo(0,0);
		this.bg.lineTo(0,height);
		this.bg.lineTo(width,height);
		this.bg.lineTo(width,0);
		this.bg.endFill();
	
		this.bg.onPress=function(){};
		this.bg.onRelease=function(){};
	}

}
