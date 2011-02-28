
class it.unipmn.di.Meeting.UIObjects.Style  {

		
	function Style() {	
	
	}
	
	static function getDefault(){
		var newStyle = new Object();
		newStyle.backgroundColor = 0xEEEEEE;
		newStyle.backgroundGradient = false;
		newStyle.backgroundGradientColors = [0xCCCCCC, 0xFFFFFF, 0xCCCCCC];
		newStyle.backgroundGradientAlphas = [100, 100, 100];
		newStyle.backgroundGradientRatios = [0, 0x7F, 0xFF];
		newStyle.backgroundGradientMatrixAdapted = true;
		newStyle.backgroundGradientMatrix = {matrixType:"box", x:100, y:100, w:200, h:200, r:(0/180)*Math.PI};
		newStyle.backgroundTrasparency = 100;
		newStyle.borderColor = 0xB4BCBC;
		newStyle.fillColor = 0xEEEEEE;
		newStyle.fillColorGradient = true;
		newStyle.fillColorGradientColors = [0xCCCCCC, 0xFFFFFF, 0xCCCCCC];
		newStyle.fillColorGradientAlphas = [100, 100, 100];
		newStyle.fillColorGradientRatios = [0, 0x7F, 0xFF];
		newStyle.fillColorGradientMatrixAdapted = true;
		newStyle.fillColorGradientMatrix = {matrixType:"box", x:100, y:100, w:200, h:200, r:(0/180)*Math.PI};
		newStyle.controllerTrasparency = 100;
		newStyle.closeFillColor = 0xFF0000;
		newStyle.minimizeFillColor = 0x333333;
		newStyle.maximizeFillColor = 0x333333;
		newStyle.closeTrasparency = 100;
		newStyle.minimizeTrasparency = 100;
		newStyle.maximizeTrasparency = 100;
		newStyle.closeBorderColor = 0xB4BCBC;
		newStyle.minimizeBorderColor = 0xB4BCBC;
		newStyle.maximizeBorderColor = 0xB4BCBC;
		newStyle.closeIconColor = 0xFFFFFF;
		newStyle.minimizeIconColor = 0xFFFFFF;
		newStyle.maximizeIconColor = 0xFFFFFF;
		newStyle.titleColor = 0x333333;
		newStyle.titleSelectedColor = 0xFF0000;
		newStyle.statusMessageColor = 0x333333;
		newStyle.gripColor = 0xBBBBBB;
		return newStyle;
		
	}
	
}