
class it.unipmn.di.Meeting.Utils.StringsManager {
	
	var xml:XML 
	var loaded:Boolean
	var language:String
	var dictionary:Object

	function StringsManager(server_location:String, l:String)
	{
		loaded=false;
		xml = new XML();
		xml["manager"] = this;
		xml.onLoad = function(success:Boolean) {
			if (success) {
				this.manager.loaded=true;
				this.manager.load_dictionary();
				_root.Log.print("Language Pack successfull loaded");
			}
			else{
				this.manager.loaded=false;
				_root.Log.print("Language Pack error on loading data");
			}
		}
		this.dictionary = new Object(); 
		this.language=l;
	 	xml.load(server_location);
	}
	
	function get(what:String){
		var word = this.dictionary[what];
		if(word != undefined && word != null )
			return word;
		else
			return what;
	}
	
	function load_dictionary(){
		var j:Number;
		var ELEMENT_NODE:Number = 1;
		var a:Array = xml.childNodes[0].childNodes;
		for (j=0;j<=a.length;j++){
			if(a[j].nodeType == ELEMENT_NODE && a[j].attributes.id!= undefined && a[j].attributes.id != null){
				this.dictionary[a[j].attributes.id] = a[j].childNodes;
			}		
		}
		delete xml;
	}
}