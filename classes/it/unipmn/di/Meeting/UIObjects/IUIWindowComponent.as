/*

	Interface: IUIWindowComponent

	A component must implement IUIWindowComponent to be considered as a window.
	
	>
	
	Un componente deve implementare IUIWindowComponent per essere considerato una finestra.

*/

import it.unipmn.di.Meeting.Utils.*;


interface it.unipmn.di.Meeting.UIObjects.IUIWindowComponent {

  /*

    Method: close

	This method is called when the window is asked to be closed.
	
	>
	
	A component must implement IUIWindowComponent to be considered as a window.

  */
	function close ( ):Void;



  /*

    Method: setSize

    This method is called when the window is asked to be resized.
	
	>
	
	Questo metodo viene richiamato quando viene richiesta la modifica delle dimensioni della finestra.

	Parameters:
      newWidth  - {Number} new width /
	  nuova larghezza

      newHeight - {Number} new height /
	  nuova altezza

  */
	function setSize (newWidth:Number, newHeight:Number):Void;



  /*

    Method: getPreferredSize

    This method is called when the default window size is requested.
	
	>
	
	Questo metodo viene richiamato quando viene richiesta ls dimensione predefinita della finestra.

    Returns:
      {Size} the default window size /
	  la dimensione predefinita della finestra

    See Also:
	  <it.unipmn.it.Meeting.Utils.Size>

  */
	function getPreferredSize():Size;



  /*

    Method: getMinimumSize

    This method is called when the minimum window size is requested.
	
	>
	
	Questo metodo viene richiamato quando viene richiesta ls dimensione minima della finestra.

    Returns:
      {Size} the minimum window size /
	  la dimensione minima della finestra

    See Also:
      <it.unipmn.di.Meeting.Utils.Size>

  */	
	function getMinimumSize():Size;

}