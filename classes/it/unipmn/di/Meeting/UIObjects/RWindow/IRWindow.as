import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.Debug.*;
import it.unipmn.di.Meeting.Utils.*;
import it.unipmn.di.Meeting.Connectors.*;

/*
  Interface: IRWindow

  The IRWindow interface allows a component to communicate with the window containing it.

  >

  L'interfaccia IRWindow permette al componente di comunicare con la finestra che lo contiene.
*/
interface it.unipmn.di.Meeting.UIObjects.RWindow.IRWindow {



  /*
    Method: addEventListener

    Adds a listener for a given event.
	
	>
	
	Aggiunge un listener per un dato evento.

    Parameters:
      eventType - {String} event name / nome dell'evento
      listener - {Object} listener object / oggetto listener
  */
  function addEventListener(eventType:String, listener:Object):Void



  /*
    Method: newError

    Generates an error message and shows it in the popup area if the *popup*
	argument is True.
	
	>
	
	Genera un messaggio di errore e lo mostra nell'area di popup se l'argomento
	*popup* è True.

    Parameters:
      err - {String} error message / messaggio di errore
      popup - {Boolean} says if it has to be a popup or not
      level - {String} *not used* / *non usato*
      id - {int} *not used* / *non usato*
  */  
  function newError(err, popup, level, id):Void



  /*
    Method: pushStatusBarMessage

    Adds a message in the window status bar.

	>
	
	Aggiunge un messaggio nella status bar della finestra.

    Parameter:
      msg - {String} the message to add / il messaggio da aggiungere
  */ 
  function pushStatusBarMessage(msg:String):Void



  /*
    Method: popStatusBarMessage

    Removes the last message from the window status bar.

	>
	
	Elimina l'ultimo messaggio dalla status bar della finestra.
  */
  function popStatusBarMessage():Void



  /*
    Method: needToHideContentOnMove

    Says if the content is hidden while moving the window.

    >
   
    Dice se il contenuto viene nascosto quando si muove la finestra.

    Returns:
      {Boolean} True | False
  */
  function needToHideContentOnMove():Boolean



  /*
    Method: needToHideContentOnResize

    Says if the content is hidden while resizing the window.

    >
   
    Dice se il contenuto viene nascosto quando si ridimensiona la finestra.

    Returns:
      {Boolean} True o False
  */
  function needToHideContentOnResize():Boolean



  /*
    Method: hide

    Hides the window and its content.

	>
    
	Nasconde la finestra e il suo contenuto.
  */
  function hide():Void



  /*
    Method: hideContent
    
    Hides only the window content.

	Useful while moving or resizing a window to avoid frequent updates of the content.

	>
	
	Nasconde solo il contenuto della finestra.

    Utile nelle operazioni di spostamento o ridimensionamento per evitare il continuo aggiornamento del contenuto.
  */
  function hideContent():Void



  /*
    Method: showContent

	It is the opposite of <hideContent>. It shows the window content back.

	>

    È opposto a <hideContent>. Fà apparire nuovamente il contenuto della finestra.
  */
  function showContent():Void



  /*
    Method: show

	It is the opposite of <hide>. It shows back the window and its content.

	>

    È opposto a <hide>. Fà apparire nuovamente la finestra ed il suo contenuto.
  */
  function show():Void



  /*
    Method: getTitle

    Returns the window title.

	>
	
    Ritorna il titolo della finestra.

    Returns:
      {String} the window title / il titolo della finestra  
  */
  function getTitle():String



  /*
    Method: isTrasparent

    Returns True if the window is transparent.

	>
	
	Ritorna True se la finestra è trasparente.

    Returns:
      {Boolean} True | False

    See Also:
      <getTrasparent>
  */
  function isTrasparent():Boolean



  /*
    Method: getTrasparent

    Returns True if the window is transparent.

    >

	Ritorna True se la finestra è trasparente.

    Returns:
      {Boolean} True | False

    See Also:
      <isTrasparent>
  */
  function getTrasparent():Boolean



  /*
    Method: setTrasparent

    Sets the window transparence.

	>
	
    Imposta la trasparenza della finestra.

    Parameter:
      value - {Boolean} True | False
  */ 
  function setTrasparent(value:Boolean):Void



  /* Method: getWindowStyle

    Returns the window style.

	>
	
	Ritorna lo stile della finestra.

    Returns:
      {Object} the window style / lo stile della finestra

    See Also:
      <it.unipmn.di.Meeting.UIObjects.Style>
  */
  function getWindowStyle():Object



  /*
    Method: setWindowStyle

    Sets the window style.

	>
	
    Imposta lo stile della finestra.

    Parameter:
      newStyle - {Object} the window style / lo stile della finestra

    See Also:
      <it.unipmn.di.Meeting.UIObjects.IRWindow.Style>
  */
  function setWindowStyle(newStyle:Object):Void



  /*
    Method: getState

    Returns the current window state.

	>
	
	Ritorna lo stato corrente della finestra.

    Returns:
    {String} the name of the current window state / il nome dello stato corrente della finestra
  */
  function getState():String



  /*
    Method: setState

    Sets the window state.

	>
	
	Imposta lo stato della finestra.

    Parameter:
      newState - {String} the name of the window state to set / il nome dello stato della finestra da impostare
  */
  function setState(newState:String):Void



  /*
    Method: getType
    
    *NOT YET IMPLEMENTED*

	>
	
	*NON ANCORA IMPLEMENTATO*
  */
  function getType():String



  /*
    Method: setType

    *NOT YET IMPLEMENTED*

	>
	
	*NON ANCORA IMPLEMENTATO*
  */
  function setType(newType:String):Void



  /*
    Method: setFocus
    
    Gives the current focus to this window.

	>
	
	Assegna il focus alla finestra.
  */
  function setFocus():Void



  /*
    Method: getSize
    
	Returns the window size.

	>
	
    Ritorna la dimensione della finestra.

    Returns:
      {Size} the window size as a Size object / la dimensione della finestra come oggetto Size

    See Also:
      <it.unipmn.it.Meeting.Utils.Size>
  */
  function getSize():Size



  /*
    Method: getLastPosition
    
	Returns the last window position.

	>
	
    Ritorna l'ultima posizione della finestra.

    Returns:
      {Position} the last window position as a Position object /
	  l'ultima posizione della finestra come oggetto Position

    See Also:
      <it.unipmn.it.Meeting.Utils.Position>
  */ 
  function getLastPosition():Position



  /*
    Method: setLastPosition
    
	Sets the window position

    Imposta la posizione della finestra.

    Parameter:
      pos - {Position} the window position as a Position object /
	  la posizione della finestra come oggetto Position

    See Also:
      <it.unipmn.it.Meeting.Utils.Position>
  */ 
  function setLastPosition(pos:Position):Void



  /*
    Method: getPosition
    
	Returns the current window position.

	>
	
    Ritorna la posizione corrente della finestra.

    Returns:
      {Position} the current window position as a position object /
	  la posizione corrente della finestra come oggetto Position

    See Also:
      <it.unipmn.it.Meeting.Utils.Position>
  */ 
  function getPosition():Position



  /*
    Method: setUrgencyHint

    Sets the window blink.

	>
	
	Imposta il lampeggio della finestra.

    Parameter:
      value - {Boolean} True | False
  */
  function setUrgencyHint(value:Boolean):Void



  /*
    Method: setFullscreen

    Makes the window the only one visible on the screen, removing status bar or something.

    >
	
    Rende la finestra l'unica visibile sullo schermo, eliminando barre di stato o altro.

    Parameter:
      value - {Boolean} True | False
  */
  function setFullscreen(value:Boolean):Void



  /*
    Method: setPosition

    Moves the window to the specified position.

	>
	
	Colloca la finestra alla posizione indicata.

    Parameter:
      pos - {Position} position on the screen in WindowManager coordinates /
	  posizione nello schermo in coordinate del WindowManager

    See Also:
      <it.unipmn.di.Meeting.Utils.Position>
  */
  function setPosition(pos:Position):Void



  /*
    Method: moveTo

    Moves the window to the specified coordinates.

	>

    Colloca la finestra alle coordinate indicate.

    Parameters:
      x - {Number} x coordinate / coordinata x
      y - {Number} y coordinate / coordinata y
  */
  function moveTo(x:Number, y:Number):Void



  /*

    Method: setSize

    It is called when the window is asked to change its size.

	>
	
	Viene richiamato quando viene richiesta la modifica delle dimensioni della finestra.

    Parameters:
      newWidth  - {Number} new width / nuova larghezza
      newHeight - {Number} new height / nuova altezza
  */
  function setSize(newWidth:Number, newHeight:Number):Void



  /*
    Method: getMenu

    Returns the window menu in the standard format used by the Menu class.

	>
	
	Ritorna il menu della finestra nel formato standard usato dalla classe Menu.

    Returns:
      {XML} the window menu / il menu della finestra
  */
  function getMenu():XML



  /*
    Method: setMenu

    Sets the window menu in the standard format used by the Menu class.

	>
	
    Imposta il menu della finestra nel formato standard usato per la classe Menu.

    Parameter:
      newMenu - {XML} the new window menu / il nuovo menu della finestra
  */
  function setMenu(newMenu:XML):Void



  /*
    Method: close

    Closes the window.

	>
	
    Chiude la finestra.
  */
  function close():Void



}
