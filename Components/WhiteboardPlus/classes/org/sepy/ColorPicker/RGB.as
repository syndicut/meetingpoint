/**
 *
 * @author
 * @version
 **/
class org.sepy.ColorPicker.RGB   {

	private var _r:Number
	/**
	 * 
	 * @usage   
	 * @param   newr 
	 * @return  
	 */
	public function set r (newr:Number):Void {
		_r = newr;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get r ():Number {
		return _r;
	}

	private var _g:Number
	/**
	 * 
	 * @usage   
	 * @param   newg 
	 * @return  
	 */
	public function set g (newg:Number):Void {
		_g = newg;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get g ():Number {
		return _g;
	}

	private var _b:Number
	/**
	 * 
	 * @usage   
	 * @param   newb 
	 * @return  
	 */
	public function set b (newb:Number):Void {
		_b = newb;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get b ():Number {
		return _b;
	}


	function RGB(red:Number, green:Number, blue:Number){
		_r = red
		_g = green
		_b = blue
	}

	/**
	 * Return the RGB representation
	 * 
	 * @usage   
	 * @return  
	 */
	
	public function getRGB():Number
	{
		return (r << 16 | g << 8 | b);
	}

	/**
	 * Display object representation
	 * 
	 * @usage   
	 * @return  
	 */
	
	public function toString():String
	{
		return "[R:" + r + ", G:" + g + ", B:" + b + "]";
	}

}