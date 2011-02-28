
class org.sepy.ColorPicker.IntInput extends MovieClip
{
    public var addListener:Function
    public var removeListener:Function
    public var _value:Number
    private var broadcastMessage:Function

    private var input :TextField
    private var tlabel:TextField
	private var _label:String
	private var _max:Number

    function IntInput()
    {
        AsBroadcaster.initialize(this)

        var fmt:TextFormat = new TextFormat()
        fmt.font = "_sans"
        fmt.size = 10
		
		tlabel = this.createTextField("tlabel", 1, 2, 1, 31, 16);
		tlabel.setNewTextFormat(fmt)
		tlabel.text = label
		
        input = this.createTextField("input", 2, 22, 1, 31, 16);
        input.type = "input"
        input.maxChars = 3
		input.restrict = "[0-9]"
        input.setNewTextFormat(fmt)
        input.addListener(this)
    }

    public function set value(value:Number)
    {
        _value = value
        input.text = _value.toString(10)
    }

    public function get value():Number
    {
        return _value
    }

    private function onChanged()
    {
		var v:Number = Number(input.text)
		if(isNaN(v))
		{
			input.text = '0'
		}
		if(v > max && max != undefined)
		{
			input.text = max.toString()
		}
		_value = Number(input.text)
        broadcastMessage("changed", this, Number(input.text))
    }

    public function set enabled(value:Boolean)
    {
        input.selectable = value
    }

    public function get enabled():Boolean
    {
        return input.selectable
    }

	public function set label(value:String):Void
	{
		_label = value
		tlabel.text = value
	}
	
	public function get label():String
	{
		return _label
	}

	public function set max(v:Number)
	{
		_max = v
	}
	
	public function get max():Number
	{
		return _max
	}

}