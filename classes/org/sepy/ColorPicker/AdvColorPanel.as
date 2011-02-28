import org.sepy.ColorPicker.HLSRGB;
import org.sepy.ColorPicker.RGB;

import flash.geom.*

/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.AdvColorPanel extends MovieClip {

    public var addListener:Function
    public var removeListener:Function
    private var broadcastMessage:Function
	
	private var _color:Number

	private var upper_bar:Button
	private var color_map:MovieClip
	private var color_slider:MovieClip
	private var color_display:MovieClip
	private var ok_btn:MovieClip
	private var close_btn:MovieClip
	
	private var _hue:Number
	private var _saturation:Number
	private var _luminosity:Number
	private var _red:Number
	private var _green:Number
	private var _blue:Number
	
	private var _hue_mc:MovieClip
	private var _saturation_mc:MovieClip
	private var _luminosity_mc:MovieClip
	private var _red_mc:MovieClip
	private var _green_mc:MovieClip
	private var _blue_mc:MovieClip
	private var _hlsrgb:HLSRGB;
	
	function AdvColorPanel()
	{
		AsBroadcaster.initialize(this)
		this.addListener(this)
		
		_hlsrgb = new HLSRGB();
		color_map    = this.attachMovie("ColorMap", "color_map", 3, {_x:10, _y:8})
		color_slider = this.attachMovie("ColorSlider", "color_slider", 4, {_x: color_map._x + color_map._width + 10, _y:color_map._y});
        color_display = this.attachMovie("color_display", "color_display", 5, {_x: color_map._x, _y: color_map._y + color_map._height})
		
        _hue_mc        = this.attachMovie("IntInput", "_hue_mc", 6, {_x: 125, _y: color_map._y + color_map._height, label:"H", variable:"hue"})
        _saturation_mc = this.attachMovie("IntInput", "_saturation_mc", 7, {_x: _hue_mc._x, _y: _hue_mc._y + _hue_mc._height + 2, label:"S", variable:"saturation"})
        _luminosity_mc = this.attachMovie("IntInput", "_luminosity_mc", 8, {_x: _hue_mc._x, _y: _saturation_mc._y + _saturation_mc._height + 2, label:"L", variable:"luminance"})
		
        _red_mc   = this.attachMovie("IntInput", "_red_mc", 9, {_x: 175, _y: _hue_mc._y, label:"R", variable:"red"})
        _green_mc = this.attachMovie("IntInput", "_saturation_mc", 10, {_x: _red_mc._x, _y: _saturation_mc._y, label:"G", variable:"green"})
        _blue_mc  = this.attachMovie("IntInput", "_luminosity_mc", 11, {_x: _red_mc._x, _y: _luminosity_mc._y, label:"B", variable:"blue"})
		
		ok_btn =    this.attachMovie("OkButton", "ok_btn", 12, {_x:color_map._x, _y: _blue_mc._y})
		close_btn = this.attachMovie("CancelButton", "close_btn", 13, {_x:ok_btn._x + ok_btn._width, _y: _blue_mc._y})
		
		init();
	}
	
	function init()
	{
		this.onMouseUp = function()
		{
			var rect:Rectangle = new Rectangle(_x, _y, _width, _height)
			var pt:Point = new Point(_xmouse, _ymouse)
			if(!rect.containsPoint(pt))
			{
				close()
			}
		}
		
		_hue_mc.max        = 360
		_saturation_mc.max = 240
		_luminosity_mc.max = 240
		
		_red_mc.max   = 255
		_green_mc.max = 255
		_blue_mc.max  = 255
		
		_hue_mc.addListener(this)
		_saturation_mc.addListener(this)
		_luminosity_mc.addListener(this)
		_red_mc.addListener(this)
		_green_mc.addListener(this)
		_blue_mc.addListener(this)		
		
		// color slider init
		color_slider.color = color
		color_slider.addListener(this)
		
		// color map init
		color_map.addListener(this)
		
		// color display init
        color_display.addListener(this)
		
		close_btn.addListener(this)
		ok_btn.addListener(this)
		
		// color map select color
		if(color_map.findTheColor(color))
		{
			//trace('founded color');
			
		} else {
			//trace('cannot find the color')
		}
		this.broadcastMessage("change", this, color)
		updateHLS(color_slider.getCurrentColor(), true);
		
	}
	
	/**
	 * user inserted a value into the HLSRGB text fields
	 * 
	 * @param  mc 
	 */
	
	private function changed(mc:MovieClip, value:Number):Void
	{
		//_hlsrgb = new HLSRGB();
		/*
		_hlsrgb.hue        = _hue_mc.value
		_hlsrgb.saturation = _saturation_mc.value/_saturation_mc.max
		_hlsrgb.luminance  = _luminosity_mc.value/_luminosity_mc.max
		*/
		_hlsrgb.color = new RGB(_red_mc.value, _green_mc.value, _blue_mc.value)
		/*
		hlsrgb.red   = _red_mc.value
		_hlsrgb.green = _green_mc.value
		_hlsrgb.blue  = _blue_mc.value
		*/
		//trace('(1)changed to: ' + _hlsrgb)
		/*
		switch(mc)
		{
			case _hue_mc:
				_hlsrgb.hue = value
				break
			case _saturation_mc:
				_hlsrgb.saturation = value/_saturation_mc.max
				break
			case _luminosity_mc:
				_hlsrgb.luminance = value/_luminosity_mc.max
				break
		}
		*/
		//trace('(2)changed to: ' + _hlsrgb)
		var hcolor:Number = _hlsrgb.getRGB()
		color_map.findTheColor(hcolor)
		this.broadcastMessage("change", this, hcolor)
	}
	
	/**
	 * ColorMap is changed
	 * 
	 * @param  mc 
	 * @param  cl 
	 */
	
	private function change(mc:MovieClip, cl:Number):Void
	{
		if(mc == color_map)
		{
			color = cl
			color_slider.color = color
			color_display.color = color_slider.getCurrentColor()
			updateHLS(color_slider.getCurrentColor(), true);
		} else if(mc == this)
		{
			color = cl
			color_slider.color = color
			color_display.color = color_slider.getCurrentColor()
			updateHLS(color_slider.getCurrentColor(), false);
		}
	}
	
	private function changing(cl:Number):Void
	{
		color_display.color = cl
		color = cl
		updateHLS(color_slider.getCurrentColor(), true);
	}
	
	private function updateHLS(cl:Number, updateObject:Boolean)
	{
		if(updateObject)
		{
			var rgb:Object = org.sepy.ColorPicker.ColorPicker.ColorToRGB(cl)
			_hlsrgb.hue = _hlsrgb.saturation = _hlsrgb.luminance = 0
			_hlsrgb.red   = rgb.red
			_hlsrgb.green = rgb.green
			_hlsrgb.blue  = rgb.blue
		}
		red        = Math.round(_hlsrgb.red)
		green      = Math.round(_hlsrgb.green)
		blue       = Math.round(_hlsrgb.blue)
		
		hue        = _hlsrgb.hue
		saturation = _hlsrgb.saturation
		luminosity = _hlsrgb.luminance
	}
	
	private function click(mc:MovieClip)
	{
		if(mc == ok_btn)
		{
			// ok button clicked
			broadcastMessage("click", this)
			close()
		} else if(mc == close_btn)
		{
			close()
		}
	}
	
	public function close()
	{
		broadcastMessage("unload", this)
	}
	
	public function set color(v:Number)
	{
		_color = v
	}
	
	public function get color():Number
	{
		return _color
	}
	
	public function set hue(v:Number)
	{
		v = Math.round(v)
		_hue = v
		_hue_mc.value = v
	}
	
	public function set saturation(v:Number)
	{
		v = Math.round(v*240)
		_saturation = v
		_saturation_mc.value = v
	}

	public function set luminosity(v:Number)
	{
		v = Math.round(v*240)
		_luminosity = v
		_luminosity_mc.value = v
	}
	
	public function set red(v:Number)
	{
		_red = v
		_red_mc.value = v
	}

	public function set green(v:Number)
	{
		_green = v
		_green_mc.value = v
	}
	
	public function set blue(v:Number)
	{
		_blue = v
		_blue_mc.value = v
	}	

}