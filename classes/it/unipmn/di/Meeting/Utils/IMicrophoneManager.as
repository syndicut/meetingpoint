import it.unipmn.di.Meeting.Utils.*;

interface it.unipmn.di.Meeting.Utils.IMicrophoneManager  {
	function addListener(how)
	function removeListener(how)
	function getRate():Number
}