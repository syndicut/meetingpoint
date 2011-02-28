import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.*;
import it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.*;

class it.unipmn.di.Meeting.UIObjects.RWindow.Dialogs.ListBox extends BaseBox{

	var list:Array
	
	function setList(file_list:Array) {
		this.list=file_list;
		if(this.controls.list.loaded!=undefined)
			doList();
	}
	
	function doList() {
		this.controls.items_list.removeAll();
		var i;
		for(i=0;i<this.list.length && this.list[i] != undefined ;i++){
			this.controls.items_list.addItem(this.list[i]);
		}
	}
		
	function setTitle(title:String) {
		this.controls.title.text=title;
		this.controls.title.autoSize=true;
	}
	
	
	function setLabel(label:String) {
		this.controls.label.text=label;
		this.controls.label.autoSize=true;
	
	}
	
	function ListBox() {
		super();
		this.list=new Array();
	}
	
	function setSize(width:Number, height:Number){
		
		this.drawBackground(width, height);
		
		
		this.controls._y = (height/2);
		this.controls._x = (width/2);
		
	}
	
	function doClose(label:String) {
		var out=new Object();
		out.label = label;
		out.item = this.controls.items_list.selectedItem;
		var	i=0;
		while(i<this.events.length){
			if(this.events[i].type == "close"){
				this.events[i].action["close"](out);			
			}
			i++;
		}
	}
}
