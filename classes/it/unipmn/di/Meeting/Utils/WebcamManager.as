import it.unipmn.di.Meeting.Utils.*;

class it.unipmn.di.Meeting.Utils.WebcamManager  implements IWebcamManager{
	
	var resolution:Size;
	var bandwidth:Number = 0;
	var quality:Number = 0;
	var fps:Number
	var events:Object
	
	function WebcamManager() {	
		this.events = new Object();
		AsBroadcaster.initialize(events);
	}
	function addListener(how){
		events.addListener(how);
	}
	function removeListener(how){
		events.removeListener(how);
	}
	
	function getResolution():Size {	
		return this.resolution;
	}
	function setResolution(resolution:Size) {	
		this.resolution = resolution;
		events.broadcastMessage("change");
	}
	function getBandwidth():Number {	
		return this.bandwidth;
	}
	function setBandwidth(bandwidth:Number) {	
		this.bandwidth = bandwidth;
		events.broadcastMessage("change");
	}
	function getQuality():Number{	
		return this.quality;
	}
	function setQuality(quality:Number) {	
		this.quality = quality;
		events.broadcastMessage("change");
	}
	function setFPS(fps:Number) {
		this.fps = fps;
		events.broadcastMessage("change");
	}
	function getFPS():Number {	
		return this.fps;
	}
	
}