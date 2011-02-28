import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import mx.containers.ScrollPane;

import mx.core.UIObject;

	
class it.unipmn.di.Meeting.components.ScrollWindow extends MovieClip implements IClientComponent, IUIWindowComponent{

	
	var soName:String	   = "content";
	var uri:String
	var name:String
	var scroller:ScrollPane;
	var connector:IConnector
	var so:SharedObject
	var movie:MovieClip
	var _parent:MovieClip
	
	function getURI():String {
			
			return this.uri;
			
	}
	
	function ScrollWindow(clip:MovieClip) {
		
		this.movie._parent = this;
		
		this.name = (this._name == null ? "_DEFAULT_" : this._name);
	
		this.uri="ScrollWindow";

		this.movie.createClassObject(mx.containers.ScrollPane, "scroller", this.getNextHighestDepth());
		this.movie.scroller.contentPath = "banner.jpg"
		
		var completeListener:Object = new Object();
		completeListener.complete = function(evt_obj:Object) {
			trace(evt_obj.target.contentPath + " has completed loading.");
		};
		// Aggiunge un listener.
		this.movie.scroller.addEventListener("complete", completeListener);
		
		//_root.core.addNetworkComponent(this);
		
		var style = new Object();
		style.backgroundColor = 0x000000;
		this._parent.setStyle(style);
		
	}
	function onDisconnect():Void{
	}
	function onConnect(con:IConnector):Void {
		
		this.connector = con;	
		
		this.so = this.connector.recordSharedObject("content", this, this, this, false);
		
	}
	function onSync(list){
	
		trace("ScrollWindow.onSync: ");
		for (var a in list){
			trace(a+" = "+list[a]);
			for (var b in list[a])
				trace(b+" = "+list[a][b]);		
		}
	}
	
	function onStatus(info:Object):Void{
	
	}
	
	function getClass():String {
		
		return "ScrollWindow";
		
	}
	
	function close() {
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.movie.unloadMovie();
		this.unloadMovie();
	}
	
	

	
	function setSize(newWidth:Number, newHeight:Number):Void {
		trace("Scroller Window w: "+newWidth+" h:"+newHeight);
		this.movie.scroller.setSize(newWidth, newHeight);
		/*this.clear();
		this.lineStyle(1,0xff0000,100);
		this.moveTo(0,0);
		this.lineTo(newWidth,0);
		this.lineTo(newWidth,newHeight);
		this.lineTo(0,newHeight);
		this.lineTo(0,0);
		*/
	}
	
	function getPreferredSize():Size {
			var size=new Object();
			size.width=300;
			size.height=250;
			return(size);
	
	}
	function getMinimumSize():Size {
			var size=new Object();
			size.width=250;
			size.height=200;
			return(size);
	}
}
