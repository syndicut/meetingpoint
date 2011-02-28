import flash.display.*
import flash.filters.*
import flash.geom.*

/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.ColorMap extends MovieClip  {
	
	var addListener:Function
	var removeListener:Function
	var broadcastMessage:Function	
	
	private var mc:MovieClip
	private var cross_mc:MovieClip
	private var cross_mask:MovieClip
	
	private var bmp:BitmapData;
	private var _color:Number

	/*
	private var fillType:String = "linear"
	private var colors:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF,  0xFF00FF, 0xFF0000 ]
	private var alphas:Array = [100,      100,      100,      100,      100,       100,      100]
	private var ratios:Array = [0,        42,       64,        127,     184,       215,      255]
	private var matrix:Object = { matrixType:"box", x:0, y:0, w:175, h:187, r:0 }
	*/
	
	function ColorMap(){
		AsBroadcaster.initialize(this)
		this.addListener(this)
		
		mc = this.createEmptyMovieClip("mc", 1)
		mc._x = 1
		mc._y = 1
		
		cross_mc   = this.attachMovie("cross_mc",   "cross_mc",   2)
		cross_mask = this.attachMovie("cross_mask", "cross_mask", 3)
		cross_mc.setMask(cross_mask)
		
		init()
	}

	private function init():Void
	{
		mc.beginGradientFill(this._parent._parent.m_fillType, this._parent._parent.m_colors, this._parent._parent.m_alphas, this._parent._parent.m_ratios, this._parent._parent.m_matrix)
		mc.moveTo(0,0)
		mc.lineTo(175,0)
		mc.lineTo(175,187)
		mc.lineTo(0,187)
		mc.lineTo(0,0)
		mc.endFill()
		mc.createEmptyMovieClip("upper", 1)

		var fillType_1:String = "linear"
		var colors_1:Array = [0xFFFFFF, 0, 0x000000]
		var alphas_1:Array = [0, 0, 100]
		var ratios_1:Array = [0, 127, 255]
		var matrix_1:Object = { matrixType:"box", x:0, y:0, w:175, h:187, r:90*Math.PI/180 }

		mc.beginGradientFill(fillType_1, colors_1, alphas_1, ratios_1, matrix_1)
		mc.moveTo(0,0)
		mc.lineTo(175,0)
		mc.lineTo(175,187)
		mc.lineTo(0,187)
		mc.lineTo(0,0)

mc.endFill()
		
	
		mc.onPress = function()
		{		
			this.onMouseMove = function()
			{
				var point:Point = new Point(_xmouse, _ymouse)
				var rect:Rectangle = new Rectangle(_x, _y, _width, _height)
				if(rect.containsPoint(point))
				{
					this._parent.changing(this)
				}
				updateAfterEvent()
			}
			this._parent.changing(this)
			
		}
		mc.onRelease = function()
		{
			delete this.onMouseMove
		}
		mc.onReleaseOutside = mc.onRelease
		mc.onRollOut        = mc.onRollOut
		
		this.draw()
	}
	
	private function changing(mc:MovieClip)
	{
		var pixel:Number = bmp.getPixel(_xmouse - mc._x - 1, _ymouse - mc._y);
		this.cross_mc._x = _xmouse
		this.cross_mc._y = _ymouse
		this.broadcastMessage("change", this, pixel)
	}
	
	private function draw():Void
	{
		bmp.dispose()
		bmp = new BitmapData(mc._width, mc._height);
		bmp.draw(mc);		
	}
	
	private function change(mc:MovieClip, cl:Number)
	{
		_color = cl
	}
	
	
	public function set color(c:Number):Void
	{
		_color = c
	}
	
	public function get color():Number
	{
		return _color
	}
	
	public function findTheColor(cl:Number):Boolean
	{
		// TODO: da rivedere
		var rect:Rectangle = bmp.getColorBoundsRect(0xFFFFFFFF, 0xFF000000+cl, true)
		cross_mc._x = rect.x+(rect.width/2)+2
		cross_mc._y = rect.y+(rect.height/2)+2
		//trace(rect)
		return !(rect.x == 0 && rect.y == 0 && rect.width == bmp.width && rect.width == bmp.height)
	}

}