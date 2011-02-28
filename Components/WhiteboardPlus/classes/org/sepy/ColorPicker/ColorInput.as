
class org.sepy.ColorPicker.ColorInput extends MovieClip
{
    public var addListener:Function
    public var removeListener:Function
    public var _color:Number
    private var broadcastMessage:Function

    private var input:TextField

    function ColorInput()
    {
        AsBroadcaster.initialize(this)

        var fmt:TextFormat = new TextFormat()
        fmt.font = "_sans"
        fmt.size = 10
        input = this.createTextField("input", 1, 2, 1, 57, 16);
        input.type = "input"
        input.maxChars = 7
        input.setNewTextFormat(fmt)
        input.addListener(this)
    }

    public function set color(value:Number)
    {
        _color = value
        input.text = "#" + org.sepy.ColorPicker.ColorPicker.ColorToString(value)
    }

    public function get color():Number
    {
        return _color
    }

    private function onChanged()
    {
        broadcastMessage("changed", input.text)
    }

    public function set enabled(value:Boolean)
    {
        input.selectable = value
    }

    public function get enabled():Boolean
    {
        return input.selectable
    }

}