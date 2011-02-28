
MovieClip.prototype.drawProgressBar = function(progressBar, colors):Void {
	
	if(colors == undefined){
		colors = new Object();
		colors.fillColor = 0x000000;
		colors.fillAlpha = 25;
		colors.borderColor = 0x000000; 
		colors.borderAlpha = 100;
	}
	
		this.clear();
		this.beginFill(colors.fillColor, colors.fillAlpha);
		this.lineStyle(1,0x000000,0,true);
		this.moveTo(progressBar._x,progressBar._y);
		this.lineTo(progressBar._x,progressBar._y+progressBar._height);
		this.lineTo(progressBar._x+progressBar._progressWidth,progressBar._y+progressBar._height);
		this.lineTo(progressBar._x+progressBar._progressWidth,progressBar._y);
		this.lineTo(progressBar._x,progressBar._y);
		this.endFill();
		this.lineStyle(1,colors.borderColor,colors.borderAlpha,true);
		this.moveTo(progressBar._x,progressBar._y);
		this.lineTo(progressBar._x,progressBar._y+progressBar._height);
		this.lineTo(progressBar._x+progressBar._width,progressBar._y+progressBar._height);
		this.lineTo(progressBar._x+progressBar._width,progressBar._y);
		this.lineTo(progressBar._x,progressBar._y);
};