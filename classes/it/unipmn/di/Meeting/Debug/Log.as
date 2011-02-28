/**
 *
 *  Logging Lib
 *
 *
**/

class it.unipmn.di.Meeting.Debug.Log {
	
	function Log()
	{
		
	}
	var logs:Array = new Array();
	var save_logs:Boolean = true;	
	var events:Object= new Object();
	
	function addEventListener(eventType:String, listener:Object){
		var newEvent = new Object();
		newEvent.type = eventType;
		newEvent.action = listener;
		if(this.events[eventType]==undefined || this.events[eventType]==null)
			this.events[eventType]=new Array();
		
		this.events[eventType].push(newEvent);
	}
	
	function getLogs(){
		
		return logs;
	}
	
	function sendEvent(type, param) {
		var ev = this.events[type];
		
		for (var i = 0; i< ev.length; i++)
			ev[i].action[type](param);
	}
	
	function print(what, rec, limit, level)
	{
		var date = new Date();
		var time = date.getFullYear()+"/"+(date.getMonth()+1) +"/"+(date.getDay()+1)+"-"+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"."+date.getMilliseconds();
		function output(o,limit) {
			if(limit != undefined && limit<=0)
				return;
			var retObj = "";
			var tab:String = "    ";
			//
			if (o instanceof Function) {
				retObj = o;
			} else if (o instanceof Date) {
				retObj = o;
			} else if (o instanceof XML) {
				retObj = o;
			} else if (o instanceof Array) {
				retObj += "[object Array]";
				for (var i in o) {
					retObj += "\n"+tab+"["+i+"]: "+((limit!=undefined)?output(o[i], limit-1):output(o[i]));
				}
			} else if (o instanceof Object) {
				retObj += "[object Object]";
				for (var prop in o) {
					retObj += "\n"+tab+prop+": "+((limit!=undefined)?output(o[prop], limit-1):output(o[prop]));
				}
			} else {
				retObj = o;
			}
			return retObj;
		};
		var orec = ((rec!=undefined)?output(rec,limit):".");
		if(save_logs){
		    logs.push({ time:time, what:what, rec:orec });
		}
		this.sendEvent('log', { time:time, what:what, rec:""+orec });
		
		trace(time +" # "+ what + orec);		
	}
}
