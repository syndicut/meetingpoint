import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.UIObjects.*;
import mx.core.UIObject;

class it.unipmn.di.Meeting.UIObjects.WindowManager.ClockApplet {

	var clockInterval:Number
	var timeColor:Number
	var refreshInterval:Number
	
	
	function ClockApplet() {
		this.clockInterval = setInterval(this.updateTime,this.refreshInterval,this);
		this.setColor(this.timeColor);
	}
	
	function setRefreshInterval (interval){  
		this.refreshInterval=interval;
		clearInterval(this.clockInterval);
		this.clockInterval = setInterval(this.updateTime,this.refreshInterval,this);
	}
	
	function stop (){  
		clearInterval(this.clockInterval);
	}
	
	function start (){  
		this.clockInterval = setInterval(this.updateTime,this.refreshInterval,this);
	}
	
	function setColor (color){  
		_parent.timeLabel.textColor = color;
	}
	
	function updateTime (from){  
		from.time=new Date(); 
		from.timeLabel.text = (from.time.getHours()<10?"0":"")+from.time.getHours()+":"+(from.time.getMinutes()<10?"0":"")+from.time.getMinutes()+":"+(from.time.getSeconds()<10?"0":"")+from.time.getSeconds();
	}
}