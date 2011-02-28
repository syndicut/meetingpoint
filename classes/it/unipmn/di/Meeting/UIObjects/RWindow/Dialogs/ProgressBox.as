import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;

class it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.ProgressBox extends BaseBox{

	var angle:Number = 0;
	
	function setTitle(title:String) {
		this.controls.title.text=title;
		this.controls.title.autoSize=true;
	}
	
	function setProgress(perc:Number) {
		
		this.controls.label.text=perc+"%";
		this.controls.progress._rotation = ((Math.PI/180)*(2*perc))/(Math.PI/180);
		
		if(perc == 100){
			this.doClose("Complete");
		}
	}
	
	function ProgressBox() {
		super();
	}
	
	function setSize(width:Number, height:Number){
		
		this.drawBackground(width, height);
		
		
		this.controls._y = (height/2);
		this.controls._x = (width/2);
		
	}
	
	function doClose(label:String) {
		var out=new Object();
		out.label = label;
		var	i=0;
		while(i<this.events.length){
			if(this.events[i].type == "close"){
				this.events[i].action["close"](out);			
			}
			i++;
		}
	}
}
