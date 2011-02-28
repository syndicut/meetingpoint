

class org.sepy.ColorPicker.ColorBox extends MovieClip
{
    private var face:MovieClip
    private var face_border:MovieClip

    public  var addListener:Function
    public  var removeListener:Function
    private var broadcastMessage:Function

    function ColorBox()
    {
        AsBroadcaster.initialize(this)
        this.useHandCursor = false

        face = this.attachMovie("face", "face", 1)
        face_border = this.attachMovie("face_borders", "face_border", 2)

        this.onRollOver = function()
        {
            broadcastMessage("over", this)
        }

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