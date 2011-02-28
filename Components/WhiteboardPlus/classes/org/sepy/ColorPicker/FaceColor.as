

class org.sepy.ColorPicker.FaceColor extends MovieClip
{
    private var _color:Number

    function FaceColor()
    {
    }

    public function set color(value:Number)
    {
        var c:Color = new Color(this)
        _color = value
        c.setRGB(value)
    }

    public function get color():Number
    {
        return _color
    }


    public function getRGB():String
    {
        return "0x"+_color.toString(16)
    }

}