
class it.unipmn.di.Meeting.Utils.XmlIO extends XML{
	function XmlIO() {
	
		this.ignoreWhite = true;
	
	}

	function open(xmlFile:String, callback:Function) {
	
		this.onLoad = callback;
		this.load(xmlFile);
		
	}
	
	function parseString(xmlString:String) {
	
		this.parseXML(xmlString);
		
	}
}
