/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.AdvancedColorButton extends MovieClip  {

	var addListener:Function
	var removeListener:Function
	var broadcastMessage:Function

	function AdvancedColorButton(){
		useHandCursor = false
		AsBroadcaster.initialize(this)
	}
	
	function onRollOver():Void
	{
		gotoAndStop(2)
	}
	
	function onRollOut():Void
	{
		gotoAndStop(1)
	}
	
	function onReleaseOutside():Void
	{
		gotoAndStop(1)
	}
	
	function onRelease():Void
	{
		broadcastMessage("click", this)
	}
	

}