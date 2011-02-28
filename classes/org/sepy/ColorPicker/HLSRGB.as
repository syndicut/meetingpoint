import org.sepy.ColorPicker.RGB;

class org.sepy.ColorPicker.HLSRGB
{
	private var _red : Number = 0;
	private var _green : Number = 0;
	private var _blue : Number = 0;
	private var _hue : Number = 0;
	private var _luminance : Number = 0;
	private var _saturation : Number = 0;
	public function HLSRGB ()
	{

	}
	public function get red () : Number
	{
		return (_red);
	}
	public function set red (n : Number) : Void
	{
		_red = n;
		ToHLS ();
	}
	public function get green () : Number
	{
		return (_green);
	}
	public function set green (n : Number) : Void
	{
		_green = n;
		ToHLS ();
	}
	public function get blue () : Number
	{
		return (_blue);
	}
	public function set blue (n : Number) : Void
	{
		_blue = n;
		ToHLS ();
	}
	public function get luminance () : Number
	{
		return (_luminance);
	}
	public function set luminance (n : Number) : Void
	{
		if (n < 0 || n > 1)
		{
			trace (n + " exceeds luminance bounds.  Luminance must be between 0.0 and 1.0");
		} else
		{
			_luminance = n;
			ToRGB ();
		}
	}
	public function get hue () : Number
	{
		return (_hue);
	}
	public function set hue (n : Number) : Void
	{
		if (n < 0 || n > 360)
		{
			trace (n + " exceeds hue bounds.  Hue must be between 0.0 and 360.0");
		} else
		{
			_hue = n;
			ToRGB ();
		}
	}
	public function get saturation () : Number
	{
		return (_saturation);
	}
	public function set saturation (n : Number) : Void
	{
		if (n < 0 || n > 1)
		{
			trace (n + "exceeds saturation bounds.  Saturation must be between 0.0 and 1.0");
		} else
		{
			_saturation = n;
			ToRGB ();
		}
	}
	public function get color ():RGB {
		var c = new RGB(_red, _green, _blue);
		//c.setRGB(_red << 16 | _green << 8 | _blue);
		return(c);
	}
	
	public function getRGB():Number
	{
		return (_red << 16 | _green << 8 | _blue)
	}
	
	public function set color (o:RGB):Void {
		_red   = o.r;
		_green = o.g;
		_blue  = o.b;
		ToHLS();
	}
	public function lightenBy(n:Number):Void {
		_luminance *= (1 + n);
		if(_luminance > 1) {
			_luminance = 1;
		}
		ToRGB();
	}
	public function darkenBy(n:Number):Void {
		_luminance *= n;
		ToRGB();
	}
	private function ToHLS ():Void {
		var minval:Number = Math.min(_red, Math.min(_green, _blue));
		var maxval:Number = Math.max(_red, Math.max(_green, _blue));
		var mdiff:Number = maxval-minval;
		var msum:Number = maxval + minval;
		_luminance = msum / 510;
		if(maxval == minval) {
			_saturation = 0;
			_hue = 0;
		}
		else {
			var rnorm:Number = (maxval - _red) / mdiff;
			var gnorm:Number = (maxval - _green) / mdiff;
			var bnorm:Number = (maxval - _blue) / mdiff;
			_saturation = (_luminance <= .5) ? (mdiff/msum) : (mdiff / (510 - msum));
			if(_red == maxval) {
				_hue = 60 * (6 + bnorm - gnorm);
			} else if (_green == maxval) {
				_hue = 60 * (2 + rnorm - bnorm);
			} else if (_blue == maxval) {
				_hue = 60 * (4 + gnorm - rnorm);
			}
			_hue %= 360;
		}
	}
	private function ToRGB():Void {
		if(_saturation == 0){
			_red = _green = _blue = _luminance * 255;

		} else {
			var rm1:Number;
			var rm2:Number;
			if(_luminance <= 0.5) {
				rm2 = _luminance + _luminance * _saturation;
			} else {
				rm2 = _luminance + _saturation - _luminance * _saturation;
			}
			rm1 = 2 * _luminance - rm2;
			_red = ToRGB1(rm1, rm2, _hue + 120);
			_green = ToRGB1(rm1, rm2, _hue);
			_blue = ToRGB1(rm1, rm2, _hue - 120);
		}
	}
	private function ToRGB1(rm1:Number, rm2:Number, rh:Number):Number {
		if(rh > 360){
			rh -= 360;
		} else if (rh < 0) {
			rh += 360;
		}
		if(rh < 60) {
			rm1 = rm1 + (rm2 - rm1) * rh / 60;
		} else if (rh < 180) {
			rm1 = rm2;
		} else if (rh < 240) {
			rm1 = rm1 + (rm2 - rm1) * (240 - rh) / 60;
		}
		return(rm1 * 255);
	}
	
	public function toString():String
	{
		return "[R:"+red+", G:"+green+", B:"+blue+", H:"+hue+", S:"+saturation+", L:"+luminance+"]";
	}
}

