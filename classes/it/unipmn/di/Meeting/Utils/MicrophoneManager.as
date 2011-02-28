import it.unipmn.di.Meeting.Utils.*;

class it.unipmn.di.Meeting.Utils.MicrophoneManager implements IMicrophoneManager{
	
	var events:Object
	
	function MicrophoneManager() {
		this.events = new Object();
		AsBroadcaster.initialize(this.events);
	}
	
	function addListener(how){
		events.addListener(how);
	}
	
	function removeListener(how){
		events.removeListener(how);
	}
	
	var rate:Number
	
	function setRate(rate:Number) {	
		this.rate = rate;
		this.events.broadcastMessage("change");
	}
	function getRate():Number {	
		return this.rate;
	}
}