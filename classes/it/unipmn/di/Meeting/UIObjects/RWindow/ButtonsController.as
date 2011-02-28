import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.RWindow.ButtonsController extends MovieClip{
	
	var close:MovieClip
	var minimize:MovieClip
	var maximize:MovieClip
	
	function ButtonsController() {
	
		this.attachMovie("ButtonClose","close",this.getNextHighestDepth());
		this.attachMovie("ButtonMinimize","minimize",this.getNextHighestDepth());
		this.attachMovie("ButtonMaximize","maximize",this.getNextHighestDepth());
		
		this.onLoad=function(){
			this.close._x=-17.5;
			
			this.maximize._x=-35;
			
			this.minimize._x=-52.5;		
			
			
			this.close.onRelease=this.minimize.onRelease=this.maximize.onRelease= function(){
				var info = _root.getUserInformation();
				if(info.role != "poweruser" && 
				   info.star != "poweruser" ){
					return;				
				}
				
				
				if(this.getRestore!= undefined){
					this.setRestore(!this.getRestore());
					if(this.getRestore())
						this._parent._parent.doEvent("restore");
					else
						this._parent._parent.doEvent(this._name);
					return;
				}
				this._parent._parent.doEvent(this._name);
			}
		}
	}
	
	function setState(newState) {
		if(newState=="maximized"){
			this.maximize.setRestore(false);	
		}
		else{
			this.maximize.setRestore(true);	
		}
	}
	
	
	
	function getWindowStyle() {
		return this._parent.getWindowStyle();
	}
	
	function draw(){
		this.close.draw();
		this.minimize.draw();
		this.maximize.draw();
	}
	
	function setSize(newWidth, newHeight) {
				this._x=newWidth-3;
				this._y=3;
				this.close.draw();
				this.minimize.draw();
				this.maximize.draw();
	}
}
