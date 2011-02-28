import flash.net.FileReference;
import flash.external.*;
import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.Core.*;
import it.unipmn.di.Meeting.Connectors.*;

class it.unipmn.di.Meeting.Core.Core implements ICore{ 
	
	var net:IConnector;
	var local:Object;
	
	function Core(){
	
		_root.Log.print("Core init");
		
		this.net = new NetworkClass();

		this.local = new LocalClass();
				
	}
	
	function removeNetworkComponent (component:IClientComponent) :Void{
		
		this.net.removeComponent(component);
		
	}
	
	function removeLocalComponent (component:IClientComponent) :Void{
		
		this.local.removeComponent(component);
		
	}
	
	function addNetworkComponent (component:IClientComponent) :Void{
		this.net.addComponent(component);
	
	}
	
	function addLocalComponent (component:IClientComponent):Void {
		
		this.local.addComponent(component);
		
	}
	
	function disconnectNetwork ():Void {
		
		this.net.disconnect();
		this.net.close();
		
		
	}
	
	function disconnectLocal ():Void {
		
		this.local.disconnect();
		
	}
	
	
	function openNetwork (uri:String, params:Object):IConnector
	{
		_root.Log.print("Core openNetwork");
		this.net.open(uri, params);
		return this.net;
	}
	
	function connectNetwork ():Void{
		_root.Log.print("Core connectNetwork");
		this.net.connect();
	}
	
	
	function openLocal (uri:String):Void{
	
		this.local.open(uri);	
		
	}
	
	
	function connectLocal ():Void{
		
		this.local.connect();
		
	}
	
	
	function loadComponent (uri:String):Void{
		
		
	}
	
	
	function parseConfiguration (config:String):Void{
	
		
	
	}
	
	
	/*
	
		var listener:Object = new Object(); 
		
		listener.parent = object;
		listener.error = onErrorCallback;
		listener.onSelect = function(file:FileReference):Void {
			trace("onSelect: " + file.name);
			if(!file.upload(url)) {
				trace("Upload dialog failed to open.");
			}
		}
		
		listener.onCancel = function(file:FileReference):Void {
			trace("onCancel");
			this.error(parent,"onCancel");
		}
		
		listener.onOpen = function(file:FileReference):Void {
			trace("onOpen: " + file.name);
		}
		
		listener.onProgress = function(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
			trace("onProgress with bytesLoaded: " + bytesLoaded + " bytesTotal: " + bytesTotal);
		}
		
		listener.onComplete =  onCompleteCallback;
		
		
		listener.onHTTPError = function(file:FileReference):Void {
			trace("onHTTPError: " + file.name);
			
			this.error("onHTTP");
		}
		
		listener.onIOError = function(file:FileReference):Void {
			trace("onIOError: " + file.name);
			
			this.error("onIO");
		}
		
		listener.onSecurityError = function(file:FileReference, errorString:String):Void {
			trace("onSecurityError: " + file.name + " errorString: " + errorString);
			
			this.error("onSecurity");
		}
	
	
	
	
	*/
	
	function uploadFile (fileTypes:Array, url:String, callback:Object):Void{
		
		
		var fileRef:FileReference = new FileReference();
		callback.onSelect = function(file:FileReference):Void {
			if(!file.upload(this.url)) {
				trace("Upload dialog failed to open.");
			}
		}
		fileRef.addListener(callback);
		callback.fileRef = fileRef;
		var COOKIES = String(ExternalInterface.call("GETCOOKIES"));
		callback.url = url+"&"+COOKIES;
		fileRef.browse(fileTypes);
	
	}
	function downloadFile(url:String, callback:Object,name:String):Void{
		
		var fileRef:FileReference = new FileReference();
		fileRef.addListener(callback);
		
		if(!fileRef.download(url, name)) {
			trace("dialog box failed to open.");
		}
	}
}
