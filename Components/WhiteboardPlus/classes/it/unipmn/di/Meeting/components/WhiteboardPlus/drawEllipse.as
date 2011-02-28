MovieClip.prototype.drawEllipse = function(x, y, x2, y2) {
	if (arguments.length<4) {
		return;
	}
	// init variables
	var theta, xrCtrl, yrCtrl, angle, angleMid, px, py, cx, cy;
	// if only yRadius is undefined, yRadius = radius
	var radius = (x2-x)/2;
	var yRadius = (y2-y)/2;
	var center_x=x+((x2-x)/2);
	var center_y=y+((y2-y)/2);
	// covert 45 degrees to radians for our calculations
	theta = Math.PI/4;
	// calculate the distance for the control point
	xrCtrl = radius/Math.cos(theta/2);
	yrCtrl = yRadius/Math.cos(theta/2);
	// start on the right side of the circle
	angle = 0;
	this.moveTo(x2, center_y);

	// this loop draws the circle in 8 segments
	for (var i = 0; i<8; i++) {
		// increment our angles
		angle += theta;
		angleMid = angle-(theta/2);
		// calculate our control point
		cx = center_x+Math.cos(angleMid)*xrCtrl;
		cy = center_y+Math.sin(angleMid)*yrCtrl;
		// calculate our end point
		px = center_x+Math.cos(angle)*radius;
		py = center_y+Math.sin(angle)*yRadius;
		// draw the circle segment
		this.curveTo(cx, cy, px, py);
	}
};