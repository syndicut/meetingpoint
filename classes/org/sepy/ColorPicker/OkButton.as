/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.OkButton extends MovieClip  {

	var addListener:Function
	var removeListener:Function
	var broadcastMessage:Function

	function OkButton(){
		useHandCursor = false
		AsBroadcaster.initialize(this)
	}
	
	function onRollOver():Void
	{
		gotoAndStop(1)
	}
	
	function onRollOut():Void
	{
		gotoAndStop(1)
	}
	
	function onReleaseOutside():Void
	{
		gotoAndStop(1)
	}
	
	function onPress():Void
	{
		gotoAndStop(2)
	}
	
	function onRelease():Void
	{
		gotoAndStop(1)
		broadcastMessage("click", this)
	}
	

}