import it.unipmn.di.Meeting.Utils.*;

interface it.unipmn.di.Meeting.Utils.IWebcamManager{
	function addListener(how)
	function removeListener(how)
	function getResolution():Size
	function getBandwidth():Number
	function getQuality():Number
	function getFPS():Number
	
}