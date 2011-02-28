import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;

class it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.QuestionBox extends BaseBox{

	function setLabel(label:String) {
		this.controls.label.htmlText=label;
		this.controls.label.autoSize=true;
	}
	
	function QuestionBox() {
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
		out.input = this.controls.input.text;
		var	i=0;
		while(i<this.events.length){
			if(this.events[i].type == "close"){
				this.events[i].action["close"](out);			
			}
			i++;
		}
	}
}
