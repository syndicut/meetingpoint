
class it.unipmn.di.Meeting.UIObjects.WindowManager.ToolTip extends MovieClip {
	var tooltip_txt:TextField
	var notifyTimer:Number
	var text:String
	function hide() {
		this._visible=false;
	}
	
	function setText(text){
		this.tooltip_txt.text=text;
		this.tooltip_txt.autoSize = true;
		this.draw(this.tooltip_txt._width, this.tooltip_txt._height);
	}
	function setPosition(x, y){
		this._x=x;
		this._y=y;
	}
	function ToolTip(){
		super();
		this.notifyTimer  = 0;
		this.tooltip_txt.autoSize = true;
		this.notifyTimer = setInterval(this, "hide", 3000);
		this.tooltip_txt.text=this.text;
		this.tooltip_txt._width = this.tooltip_txt.textWidth;
	}
	function draw(w,h) {
		this.clear();
		this.beginFill(0xFAE803, 80);
		this.lineStyle(1,0xFFFF00,100,true);
		var angle = 3;
		var size_w = w;
		var size_h = h;
		this.moveTo(angle,0);
		this.curveTo(0,0,0,angle);
		this.lineTo(0,size_h-angle);
		this.curveTo(0,size_h,angle,size_h);
		this.lineTo(size_w-angle,size_h);
		this.curveTo(size_w,size_h,size_w,size_h-angle);
		this.lineTo(size_w,angle);
		this.curveTo(size_w,0, size_w-angle,0);
		this.lineTo(angle,0);
		this.endFill();
		
	}
	
}