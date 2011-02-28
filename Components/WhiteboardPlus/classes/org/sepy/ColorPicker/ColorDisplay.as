
class org.sepy.ColorPicker.ColorDisplay extends MovieClip
{
    public var addListener:Function
    public var removeListener:Function
    private var broadcastMessage:Function
    private var face:MovieClip

    function ColorDisplay()
    {
        AsBroadcaster.initialize(this)
        this.useHandCursor = false

        face = this.attachMovie("face", "face", 1)
        face._x = 1
        face._y = 1
        face._width  = 39
        face._height = 17

        this.onRelease = function()
        {
            broadcastMessage("click", this)
        }

    }

    public function set color(value:Number)
    {
        face.color = value
    }

    public function get color():Number
    {
        return face.color
    }

    public function getRGB():String
    {
        return "0x"+face.color.toString(16)
    }
}