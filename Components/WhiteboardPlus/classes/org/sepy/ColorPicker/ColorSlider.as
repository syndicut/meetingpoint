import flash.display.BitmapData
import flash.geom.Rectangle


/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.ColorSlider extends MovieClip  {
	
	var addListener:Function
	var removeListener:Function
	var broadcastMessage:Function		
	
	private var mc:MovieClip
	private var slider:MovieClip
	private var _color:Number
	private var bmp:BitmapData
	
	function ColorSlider(){
		AsBroadcaster.initialize(this)
		mc = this.createEmptyMovieClip("mc", 1)
		mc._x = 1
		mc._y = 1
		mc.useHandCursor = false
		mc.onPress = function()
		{
			this._parent.changing(this)
			this.onMouseMove = function()
			{
				if(_ymouse >= 0 && _ymouse <= this._height)
				{
					this._parent.changing(this)
				}
				updateAfterEvent();
			}
		}
		mc.onRelease = function()
		{
			delete this.onMouseMove;
		}
		mc.onRollOut = mc.onRelease
		mc.onReleaseOutside = mc.onRelease
		
		slider = this.attachMovie("slider_mc", "slider", 2, {_x:15, _y : 98})
	}
	
	private function changing(mc:MovieClip)
	{
		slider._y = mc._ymouse
		var px:Number = bmp.getPixel(5, slider._y)
		broadcastMessage("changing", px)
	}
	
	public function getCurrentColor():Number
	{
		return bmp.getPixel(5, slider._y)
	}
	
	public function set color(c:Number):Void
	{
		_color = c
		draw()
	}
	
	public function get color():Number
	{
		return _color
	}

	private function draw():Void
	{
		mc.clear();
		var colors:Array = [0x000000, color, 0xFFFFFF];
		var alphas:Array = [100, 100, 100];
		var ratios:Array = [0, 127, 255];
		var matrix:Object = {matrixType:"box", x:0, y:0, w:187, h:187, r:270*Math.PI/180};
		mc.clear();
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix, "reflect", "linear");
		mc.moveTo(0, 0);
		mc.lineTo(12, 0);
		mc.lineTo(12, 187);
		mc.lineTo(0, 187);
		mc.lineTo(0, 0);
		mc.endFill();
		
		bmp.dispose()
		bmp = new BitmapData(mc._width, mc._height, false)
		bmp.draw(mc)
		//trace(bmp.getColorBoundsRect(color, color, true))
	}
	
	

}