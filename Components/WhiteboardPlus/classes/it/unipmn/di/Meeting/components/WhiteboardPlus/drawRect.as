/*-------------------------------------------------------------
	mc.drawRect is a method for drawing rectangles and
	rounded rectangles. Regular rectangles are
	sufficiently easy that I often just rebuilt the
	method in any file I needed it in, but the rounded
	rectangle was something I was needing more often,
	hence the method. The rounding is very much like
	that of the rectangle tool in Flash where if the
	rectangle is smaller in either dimension than the
	rounding would permit, the rounding scales down to
	fit.
-------------------------------------------------------------*/
MovieClip.prototype.drawRect = function(x, y, w, h) {
	// ==============
	// mc.drawRect() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
	// 
	// x, y = top left corner of rect
	// w = width of rect
	// h = height of rect
	// cornerRadius = [optional] radius of rounding for corners (defaults to 0)
	// ==============
	if (arguments.length<4) {
		return;
	}
		this.moveTo(x, y);
		this.lineTo(x+w, y);
		this.lineTo(x+w, y+h);
		this.lineTo(x, y+h);
		this.lineTo(x, y);
};