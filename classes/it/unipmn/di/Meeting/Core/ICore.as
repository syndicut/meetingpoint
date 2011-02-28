/*
	Interface: ICore
	
	ICore is an interface allowing components to get access to Core methods.
	
	>
	
	ICore è un'interfaccia che permette ai componenti di accedere a metodi
	della classe Core.

*/

import it.unipmn.di.Meeting.*;
import it.unipmn.di.Meeting.Core.*;
import it.unipmn.di.Meeting.Connectors.*;

interface it.unipmn.di.Meeting.Core.ICore	{
	
	
/*

	Method: removeNetworkComponent
	
	This method is usually called by a component that wants to be removed from
	the list of network components.

	Calling this method causes the connection to close.

	>

	Questo metodo viene richiamato solitamente da un componente che vuole essere
	rimosso dalla lista dei componenti di rete.
	
	La chiamata al metodo comporta la chiusura della connessione.


	Paramenter:
	  component - {IClientComponent} the component instance /
	  l'istanza del componente

*/
	function removeNetworkComponent (component:IClientComponent) :Void



	
/*

	Method: removeLocalComponent
	
	This method is usually called by a component that wants to be removed from
	the list of local components (connected through LocalConnection).

	Calling this method causes the connection to close.
	
	>
	
	Questo metodo viene richiamato solitamente da un componente che vuole essere
	rimosso dalla lista dei componenti di locali (collegati tramite LocalConnection).

	La chiamata al metodo comporta la chiusura della connessione.


	Paramenter:
	  component - {IClientComponent} the component instance /
	l'istanza del componente

*/
	function removeLocalComponent (component:IClientComponent):Void



/*

	Method: addNetworkComponent
	
	This method is usually called by a component that wants to be added to
	the list of network components.

	Calling this method causes the component to connect if the Connector is already
	connected.
	
	>
	
	Questo metodo viene richiamato solitamente da un componente
	che vuole essere aggiunto alla lista dei componenti di rete.

	La chiamata al metodo comporta la connessione del componente se in
	precendeza era stata effettuata la connessione del Connector.


	Paramenter:
	  component - {IClientComponent} the component instance  /
	  l'istanza del componente

*/
	function addNetworkComponent (component:IClientComponent):Void

/*

	Method: addLocalComponent
	
	This method is usually called by a component that wants to be added to
	the list of local components (connected through LocalConnection).

	Calling this method causes the component to connect if the Connector is already
	connected.
	
	>
	
	Questo metodo viene richiamato solitamente da un componente
	che vuole essere aggiunto alla lista dei componenti locali
	(collegati tramite LocalConnection).
	
	La chiamata al metodo comporta la connessione del componente se in
	precendeza era stata effettuata la connessione del Connector.


	Paramenter:
	  component - {IClientComponent} the component instance /
	  l'istanza del componente

*/
	function addLocalComponent (component:IClientComponent):Void


/*

	Method: disconnectNetwork
	
	This method fully disconnects all network components and the Connector itself.
	
	>
	
	Questo metodo effettua la disconnessione completa di tutti i componenti
	di rete e del Connector stesso.

*/
	function disconnectNetwork ():Void



/*

	Method: disconnectLocal
	
	This method fully disconnects all local components and the Connector itself.
	
	Questo metodo effettua la disconessione completa di tutti i componenti
	Locali e del Connector stesso.

*/
	function disconnectLocal ():Void	



/*

	Method: openLocal
	
	_not fully implemented_
	
	>
	
	_non completamente implementato_


*/
	function openLocal (uri:String):Void



/*

	Method: openNetwork
	
	This method opens a network connection.
	
	>
	
	Questo metodo apre una connessione di rete.


	Paramenter:
      URI - {String} destination URI /
	  URI di destinazione	 

	  params - {Object} parameters passed to the server on connection phase /
	  paramentri passati al server nella fase di connessione
	
	
	Returns:
	  {IConnector} the generated Connector instance /
	  l'istanza del Connector che è stato generato

*/
	function openNetwork (uri:String, params:Object):IConnector


/*

	Method: connectNetwork
	
	This method fully connects all already added network components and the
	Connector itself.

	>
	
	Questo metodo effettua la connessione completa di tutti i componenti di rete
	già aggiunti e del Connector stesso.

*/
	function connectNetwork ():Void


/*

	Method: connectLocal
	
	This method fully connects all already added local components and the
	Connector itself.
	
	>
	
	Questo metodo effettua la connessione completa di tutti i componenti locali
	già aggiunti e del Connector stesso.

*/
	function connectLocal ():Void


/*

	Method: uploadFile
	
	This method uploads a file of type(s) *fileTypes* to the address specified
	by *URL*, after having set the callbacks.
	
	The callbacks let to know how the transfer task is going on and
	to get error information.
	
	>

	Questo metodo effettua l'upload di un file di tipo/i *fileTypes*
	all'indirizzo *URL* dopo aver settato le callback.

	Le callback permettono di sapere come procede il trasferimento e le informazioni
	di errore.


	Paramenter:
	  fileTypes - {Array} array containing the allowed file types /
	  array contenente i tipi di file accettati
	  
	  URL - {String} destination URL of the file
	  URL di destinazione del file
 	  
	  callback - {Object} contains the methods needed for managing the transfer /
	  contiene i metodi necessari alla gestione del trasferimento

*/
	function uploadFile (fileTypes:Array, url:String, callback:Object):Void

/*

	Method: downloadFile
	
	This method downloads a file of name *name* from the address specified
	by *URL*, after having set the callbacks.
	
	The callbacks let to know how the transfer task is going on and
	to get error information.
	
	>
	
	Questo metodo effettua il download di un file dal nome *name* dall'indirizzo
	*URL* dopo aver settato le callback.

	Le callback permettono di sapere come procede il trasferimento e le
	informazioni di errore.


	Paramenter:
	  name - {String} filename
	  URL -  {String} destination URL of the file /
	  URL di destinazione del file
 	  callback - {Object} contains the methods needed for managing the transfer /
	  contiene i metodi necessari alla gestione del trasferimento

*/
	function downloadFile(url:String, callback:Object,name:String):Void
}
