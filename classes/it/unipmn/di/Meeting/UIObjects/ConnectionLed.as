import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.ConnectionLed extends UIObject{
	
	var connected:Boolean
	var active:MovieClip
	var blinkNum:Number
	var blinkTimer:Number
	var onConnection:MovieClip
	var onDisconnection:MovieClip
	
	
	function ConnectionLed() {
		this.connected = false;	
		this.active=this.onDisconnection;
		this.setSize(0,0); // Usato per il refresh
	}

	function isConnected() {
		
		return this.connected;
	
	}
	
	function blinkStatus(value) {
		//trace("Blinking: "+this.active+" - "+this.blinkNum);
		if(this.blinkNum <= 0){
			clearInterval(this.blinkTimer);
			this.active._alpha = 100;
			return;
		}
		if(this.active._alpha<=20)
			this.active._alpha =100;
		else
			this.active._alpha=20;
		this.blinkNum--;
	}
		
	function setConnected(value) {
		clearInterval(this.blinkTimer);
		
		this.connected = value;
		
		this.active = (value==true)? this.onConnection :this.onDisconnection;
		
		
		this.blinkNum = 20;
		this.blinkTimer = setInterval(this, "blinkStatus", 500);
		
		this.setSize(0,0); // Usato per il refresh
		
	}

	function setSize(w,h) {
	
			this.onConnection._visible= this.isConnected();
		
			this.onDisconnection._visible= !( this.isConnected() );
		
	}
}