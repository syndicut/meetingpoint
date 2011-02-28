import it.unipmn.di.Meeting.Connectors.IConnector; 
import it.unipmn.di.Meeting.Connectors.IClientComponent; 
import it.unipmn.di.Meeting.UIObjects.IUIWindowComponent;
import it.unipmn.di.Meeting.Utils.Size;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.CheckBox;
import mx.controls.TextArea;
import mx.controls.DataGrid;
import mx.controls.List;
import mx.controls.TextInput;	

	
class it.unipmn.di.Meeting.components.Poll.Poll extends MovieClip implements IClientComponent, IUIWindowComponent{

	var soName:String	   = "poll";
	var answersName:String	   = "answers";
	var resultsName:String	   = "results";
	var uri:String
	var status:String = "open"
	var prepare_mc:MovieClip
	var details_mc:MovieClip
	var openpoll_mc:MovieClip
	var openButton:Button
	var closeButton:Button
	var prepareButton:Button
	var connector:IConnector
	var name:String
	var so:SharedObject
	var soAnswers:SharedObject
	var soResults:SharedObject

	var answersListOn:Boolean = false;
	var comboOn:Boolean = false;
		
	var movie:MovieClip
	
	var borders:MovieClip
	var _parent:MovieClip
		
	function getURI():String {
			return this.uri;
	}

	function Poll(clip:MovieClip) {
		super();
		
		this.movie = clip;
		this.movie._parent = this;
		this.name = (this._name == null ? "_DEFAULT_" : this._name);
		
		this.attachMovie("Prepare", "prepare_mc", this.getNextHighestDepth(),{_parent:this,_x:4,_y:1, _visible:false});
		this.attachMovie("OpenPoll", "openpoll_mc", this.getNextHighestDepth(),{_parent:this,_x:4,_y:1, _visible:false});
		this.attachMovie("Details", "details_mc", this.getNextHighestDepth(),{_parent:this,_x:4,_y:1, _visible:false});
		
		this.uri="Poll";
		
		_root.core.addNetworkComponent(this);
		
		this.openpoll_mc.question_txt.autoSize=true;
		
		/*
		 * Translation
		 */
		// Open Poll Form
		this.prepare_mc.answer_txt.text = _root.stringsManager.get("POLL_ANSWERS");
		this.openpoll_mc.shareResults.label = _root.stringsManager.get("POLL_SHARE_RESULTS");
		_root.tooltip(this.openpoll_mc.shareResults, _root.stringsManager.get("POLL_SHARE_RESULTS_TT"));
		this.openpoll_mc.detailsButton.label = _root.stringsManager.get("POLL_BUTTON_DETAILS");
		_root.tooltip(this.openpoll_mc.detailsButton, _root.stringsManager.get("POLL_BUTTON_DETAILS_TT"));

		// Open Prepare Form

		this.prepare_mc.question_txt.text = _root.stringsManager.get("POLL_QUESTION");
		this.prepare_mc.answer_txt.text = _root.stringsManager.get("POLL_ANSWERS");
		this.prepare_mc.typeCombo.labels = [_root.stringsManager.get("POLL_TYPE_MULTIPLE"),_root.stringsManager.get("POLL_TYPE_SINGLE")];
		//_root.tooltip(this.prepare_mc.typeCombo, _root.stringsManager.get("POLL_TYPE_TT"));
		this.prepare_mc.addButton.label = _root.stringsManager.get("POLL_BUTTON_ADD");
		_root.tooltip(this.prepare_mc.addButton, _root.stringsManager.get("POLL_BUTTON_ADD_TT"));
		this.prepare_mc.delButton.label = _root.stringsManager.get("POLL_BUTTON_DEL");
		_root.tooltip(this.prepare_mc.delButton, _root.stringsManager.get("POLL_BUTTON_DEL_TT"));
		this.prepare_mc.clearButton.label = _root.stringsManager.get("POLL_BUTTON_CLEAR");
		_root.tooltip(this.prepare_mc.clearButton, _root.stringsManager.get("POLL_BUTTON_CLEAR_TT"));
		this.prepareButton.label = _root.stringsManager.get("POLL_BUTTON_PREPARE");
		_root.tooltip(this.prepareButton, _root.stringsManager.get("POLL_BUTTON_PREPARE_TT"));
		this.openButton.label = _root.stringsManager.get("POLL_BUTTON_OPEN");
		_root.tooltip(this.openButton, _root.stringsManager.get("POLL_BUTTON_OPEN_TT"));
		this.closeButton.label = _root.stringsManager.get("POLL_BUTTON_CLOSE");
		_root.tooltip(this.closeButton, _root.stringsManager.get("POLL_BUTTON_CLOSE_TT"));

	}
	
	function onDisconnect():Void{
	}
	
	function onConnect(con:IConnector):Void {
		
		this.connector = con;	

		var answersListener = new Object();
		answersListener.onStatus = function(info:Object):Void{
			_root.Log.print("Answers.onStatus: ", info);
		}
		answersListener.onSync = function (list){
			//_root.Log.print("Pool Answers onSync:", list);
			for (var a in list){
				if(list[a]["code"]=="change" || list[a]["code"]=="success"){
					var x = (this.data[list[a]["name"]]).label;
					var present = false;
					for(var i=0; i < this.parent.prepare_mc.answersList.length; i++){
						if(x == (this.parent.prepare_mc.answersList.getItemAt(i)).label)
							present=true;   
					}
					if(present==false){
						this.parent.prepare_mc.answersList.addItem(this.data[list[a]["name"]]);
					}
					
				}
				else if(list[a]["code"]=="delete"){
					for(var i=0; i<this.parent.prepare_mc.answersList.length; i++){
						if(list[a]["name"] == escape(this.parent.prepare_mc.answersList.getItemAt(i).label))
							this.parent.prepare_mc.answersList.removeItemAt(i);
					}
				}
			}
			
			this.parent.refreshGUI();
		}
		
		
		
		var resultsListener = new Object();
		resultsListener.onStatus = function(info:Object):Void{
			_root.Log.print("Results.onStatus: ", info);
		}
		resultsListener.onSync = function (list){
			//_root.Log.print("Pool Results onSync:", list);
			for (var a in list){
				if(list[a]["code"]=="change" || list[a]["code"]=="success"){
					var user = list[a]["name"];
					var vote = this.data[list[a]["name"]];
					
					var present = false;
					for(var i=0; i < this.parent.details_mc.resultsGrid.length; i++){
						if(user == (this.parent.details_mc.resultsGrid.getItemAt(i)).user &&
							vote == (this.parent.details_mc.resultsGrid.getItemAt(i)).vote )
							present=true;   
					}
					if(present==false){
						this.parent.details_mc.resultsGrid.addItem({user:this.parent.connector.users.getUserName(user),vote:this.data[list[a]["name"]]});
					}
					
				}
				else if(list[a]["code"]=="delete"){
					var user = list[a]["name"];
					var vote = this.data[list[a]["name"]];
					
					for(var i=0; i < this.parent.details_mc.resultsGrid.length; i++){
						if(user == (this.parent.details_mc.resultsGrid.getItemAt(i)).user &&
							vote == (this.parent.details_mc.resultsGrid.getItemAt(i)).vote )
							this.parent.details_mc.resultsGrid.removeItemAt(i);
					}
				}
			}
			this.parent.refreshGUI();
		}
		
		var listener = new Object();
		listener.onStatus = function(info:Object):Void{
			
			_root.Log.print("Poll.onStatus: ", info);
		}
		listener.onSync = function (list){
			
			for (var a in list){	
				_root.Log.print("Pool onSync: "+list[a]["code"]+" - " + list[a]["name"]+" = "+this.data[list[a]["name"]]);
				if(list[a]["code"]=="change" || list[a]["code"]=="success"){
					if(list[a]["name"]=="shareResults"){
						this.parent._parent.refreshWindow();
					}
					if(list[a]["name"]=="status"){			
						this.parent.setStatus(this.data.status);
						this.parent.refreshGUI();
					}
					if(list[a]["name"]=="type"){
						if(this.parent.comboOn){
							//trace("Type: "+this.data.type+" Before: "+this.parent.typeCombo.selectedIndex);
							var n = (this.data.type=="radio"? 1 : 0);
							if(this.parent.prepare_mc.typeCombo.selectedIndex != n)	
								this.parent.prepare_mc.typeCombo.selectedIndex=n;
						}
						if(this.data.type == "radio"){
							this.parent.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "RadioButtonCellRender"
						}
						else{
							this.parent.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "CheckBoxCellRender"
						}
					}
					
					if(list[a]["name"]=="question"){
						this.parent.prepare_mc.questionInput.text = this.data.question;
						this.parent.openpoll_mc.question_txt.text = this.data.question;
					}
				}
				else if(list[a]["code"]=="delete"){
					
				}
			}
			this.parent.refreshGUI();
		}
		this.so = this.connector.recordSharedObject(soName, this, listener, this, true);		
		this.soAnswers = this.connector.recordSharedObject(answersName, this, answersListener, this, true);
		this.soResults = this.connector.recordSharedObject(resultsName, this, resultsListener, this, true);
	}
	
	function onStatus(info:Object):Void{

	}
	
	function getClass():String {
		
		return "Poll";
		
	}

	function questionInputChange(txt){
	}
	
	function close():Void {
		
		delete this.soAnswers.onSync;
		delete this.soResults.onSync;
		delete this.so.onSync;
		this.connector.unrecordAllSharedObject(this);
		this.connector.unrecordComponent(this);
		this.connector.removeComponent(this);
		this.movie.removeMovieClip();
		this.removeMovieClip();
	}
	
	
	function setSize(newWidth:Number, newHeight:Number):Void {
	
		this.prepareButton._y = (newHeight-3) - this.prepareButton._height;
		this.closeButton._y = this.prepareButton._y;
		this.openButton._y = this.prepareButton._y;
	
		this.details_mc.backButton._y = (newHeight-3) - this.details_mc.backButton._height;
		if(details_mc.resultsGrid.width != newWidth-8){
			details_mc.resultsGrid.getColumnAt(0).width = details_mc.resultsGrid.width/2;
			details_mc.resultsGrid.getColumnAt(1).width = details_mc.resultsGrid.width/2;
		}
//		if(openpoll_mc.answersGrid.width != newWidth-8){
			openpoll_mc.answersGrid.getColumnAt(0).width = 25;
			var info = _root.getUserInformation();
			if(this.so.data.shareResults == true ||
			   info.role == "moderator" || 
			   info.star == "moderator" ||
			   info.role == "poweruser" || 
			   info.star == "poweruser" ){
				
				openpoll_mc.answersGrid.getColumnAt(1).width = openpoll_mc.answersGrid.width-150;
				
				if(openpoll_mc.answersGrid.getColumnAt(1) != undefined && openpoll_mc.answersGrid.getColumnAt(2) == undefined)
					openpoll_mc.answersGrid.addColumnAt(2, "percent");
				if(openpoll_mc.answersGrid.getColumnAt(1) != undefined && openpoll_mc.answersGrid.getColumnAt(3) == undefined)
					openpoll_mc.answersGrid.addColumnAt(3, "votes");
				openpoll_mc.answersGrid.getColumnAt(2).width = 100;
				openpoll_mc.answersGrid.getColumnAt(3).width = 25;
				
				if(info.role == "moderator" || 
				   info.star == "moderator" ||
				   info.role == "poweruser" || 
				   info.star == "poweruser" )
					openpoll_mc.shareResults._visible=true;
				
				openpoll_mc.shareResults.selected=this.so.data.shareResults;
				openpoll_mc.answersGrid.getColumnAt(2).cellRenderer = "PercentCellRender";
			
				openpoll_mc.detailsButton._visible=true;
			}else{
				openpoll_mc.answersGrid.getColumnAt(1).width = openpoll_mc.answersGrid.width-25;
				openpoll_mc.answersGrid.removeColumnAt(2);
				openpoll_mc.answersGrid.removeColumnAt(2);
				openpoll_mc.shareResults._visible=false;
				
				openpoll_mc.detailsButton._visible=false;
			}
			openpoll_mc.answersGrid.resizableColumns = false;
			openpoll_mc.answersGrid.vScrollPolicy = "auto";
	
			if(this.so.data.type == "radio"){
				this.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "RadioButtonCellRender"
			}
			else{
				this.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "CheckBoxCellRender"
			}
			openpoll_mc.answersGrid.showHeaders = false;
//		}
		this.openpoll_mc.answersGrid.setSize(newWidth-8, this.prepareButton._y-50);
		
		this.details_mc.resultsGrid.setSize(newWidth-8, this.details_mc.backButton._y-5);
		
		this.prepare_mc.questionInput.setSize(newWidth-8,22);
		
		this.openpoll_mc.question_txt._width=newWidth-8; 
		this.prepare_mc.answersList.setSize(newWidth-8,(this.prepareButton._y-105));
	}
	
	function detailsButton_click(){
		//trace("detailsButton: ");
		setStatus("details");
	}
	function shareResults_click(){
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" ){
			
			if(this.openpoll_mc.shareResults.selected == true)
				this.so.data.shareResults = true;
			else
				this.so.data.shareResults = false;
		}
	}
	
	function getPreferredSize():Size {
			var size=new Object();
			size.width=275;
			size.height=350;
			return(size);
	}
	function getMinimumSize():Size {
			var size=new Object();
			size.width=275;
			size.height=250;
			return(size);
	}

	function answerCell_radio(){
		var vote = this.openpoll_mc.answersGrid.selectedItem.label;
		var selected = this.openpoll_mc.answersGrid.selectedItem.selected
		
		this.connector.send(this.getURI(), "doVote",{type:"radio", vote:vote, selected:selected});

	}
	function answerCell_check(){

		var vote = this.openpoll_mc.answersGrid.selectedItem.label;
		var selected = this.openpoll_mc.answersGrid.selectedItem.selected
		
		this.connector.send(this.getURI(), "doVote",{type:"check", vote:vote, selected:selected});
	}

	function refreshGUI(s){	
		if(s == undefined || s == null){
			s = this.so.data.status;
			if(s == undefined || s == null)
				s="close";
		}
		if(s=="open" || s=="close"){
			this.openpoll_mc.answersGrid.enabled = true;
			this.openpoll_mc.question_txt.text = this.so.data.question;
				
				
			var total = 0;
			for(var i in  this.soResults.data){
				for(var j in  this.soResults.data[i])
					total++;
			}
			var info = _root.getUserInformation();
			openpoll_mc.answersGrid.removeAll();
			for(var i in  this.soAnswers.data){
				var votes = 0;
				var youVote = false;
				for(var j in  this.soResults.data){
						if(this.soResults.data[j][this.soAnswers.data[i]]){
							votes++;
							if(j == info.serverID){
								youVote=true;
							}
						}
				}
				openpoll_mc.answersGrid.addItem({selected:youVote, label:(this.soAnswers.data[i]), percent: Math.round((votes/total)*100), votes:votes});   
			}
			
			openpoll_mc.answersGrid.getColumnAt(0).width = 25;
			var info = _root.getUserInformation();
			if(this.so.data.shareResults == true ||
			   info.role == "moderator" || 
			   info.star == "moderator" ||
			   info.role == "poweruser" || 
			   info.star == "poweruser" ){
				
				openpoll_mc.answersGrid.getColumnAt(1).width = openpoll_mc.answersGrid.width-150;
				if(openpoll_mc.answersGrid.getColumnAt(1) != undefined && openpoll_mc.answersGrid.getColumnAt(2) == undefined)
					openpoll_mc.answersGrid.addColumnAt(2, "percent");
				if(openpoll_mc.answersGrid.getColumnAt(1) != undefined && openpoll_mc.answersGrid.getColumnAt(3) == undefined)
					openpoll_mc.answersGrid.addColumnAt(3, "votes");
				
				openpoll_mc.answersGrid.getColumnAt(2).width = 100;
				openpoll_mc.answersGrid.getColumnAt(3).width = 25;
			}else{
				openpoll_mc.answersGrid.getColumnAt(1).width = openpoll_mc.answersGrid.width-25;
				openpoll_mc.answersGrid.removeColumnAt(2);
				openpoll_mc.answersGrid.removeColumnAt(2);
			}
			openpoll_mc.answersGrid.resizableColumns = false;
			openpoll_mc.answersGrid.vScrollPolicy = "auto";
	
			if(this.so.data.type == "radio"){
				this.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "RadioButtonCellRender"
			}
			else{
				this.openpoll_mc.answersGrid.getColumnAt(0).cellRenderer = "CheckBoxCellRender"
			}
			openpoll_mc.answersGrid.getColumnAt(2).cellRenderer = "PercentCellRender";
			openpoll_mc.answersGrid.showHeaders = false;
			if(s=="close"){
				this.openpoll_mc.answersGrid.enabled = false;
			}
		}
		if(s=="prepare"){
			if(this.comboOn==true){
				//trace("Before: "+this.prepare_mc.typeCombo.selectedIndex);
				var n = (this.so.data.type=="radio"? 1 : 0);
				if(this.prepare_mc.typeCombo.selectedIndex != n)	
					this.prepare_mc.typeCombo.selectedIndex=n;
				//trace("Now: "+this.prepare_mc.typeCombo.selectedIndex);
			}
			if(answersListOn){
				//trace("Prepare: ");
				this.prepare_mc.answersList.removeAll();		
				for(var i in  this.soResults.data){
					this.soResults.data[i]=null;
				}			
				for(var i in  this.soAnswers.data){
					//trace("Insert: "+(this.soAnswers.data[i]).label);
					this.prepare_mc.answersList.addItem({label:(this.soAnswers.data[i]), data:(this.soAnswers.data[i])});   
				}
				this.prepare_mc.questionInput.text = (this.so.data.question==undefined?_root.stringsManager.get("POLL_QUESTION_MSG"):this.so.data.question);
			}
		}
		if(s=="details"){
			this.details_mc.resultsGrid.removeAll();
			for(var i in  this.soResults.data){
				for(var j in  this.soResults.data[i]){
					this.details_mc.resultsGrid.addItem({user:this.connector["users"].getUserName(i),vote:this.soResults.data[i][j]});
				}
			}
		}
	}
	function backButton_click(){
		setStatus(this.so.data.status);
	}
	
	function setStatus(s:String){
		this.status = s;
		
		if(s=="open"){
			this.prepare_mc._visible = false;
			this.details_mc._visible = false;
			this.openpoll_mc._visible = true;
			this.closeButton.enabled = true;
			this.openButton.enabled = false;
			this.prepareButton.enabled = true;
		}
		if(s=="prepare"){
			var info = _root.getUserInformation();
			if(info.role == "moderator" || 
			   info.star == "moderator" ||
			   info.role == "poweruser" || 
			   info.star == "poweruser" ){
				
				this.prepare_mc._visible = true;
				this.details_mc._visible = false;
				this.openpoll_mc._visible = false;
			}
			this.prepareButton.enabled = false;
			this.closeButton.enabled = true;
			this.openButton.enabled = true;
		}
		if(s=="close"){
			this.prepare_mc._visible = false;
			this.details_mc._visible = false;
			this.openpoll_mc._visible = true;
			this.closeButton.enabled = false;
			this.openButton.enabled = true;
			this.prepareButton.enabled = true;
		}
		if(s=="details"){
			this.prepare_mc._visible = false;
			this.details_mc._visible = true;
			this.openpoll_mc._visible = false;
			this.closeButton._visible = false;
			this.openButton._visible = false;
			this.prepareButton._visible = false;
		}else{
			this.closeButton._visible = true;
			this.openButton._visible = true;
			this.prepareButton._visible = true;
		}
		this.refreshGUI(s);
		
	}
	function prepareButton_click() {
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "setState",{state:"prepare"});
	}
	function openButton_click() {
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "setState",{state:"open", question: this.prepare_mc.questionInput.text});
	}
	function closeButton_click() {
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "setState",{state:"close"});
	}
	function addButton_click() {
		var x = this.prepare_mc.answerInput.text;
		if(x=="" || x==null)
			return;

		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "addAnswer",{answer:x});		
	}
	function delArrayItem(a:Array, i){
		for(var j=0; j < a.length; j++){
			if(a[j]==i){
				a[j] = null;
				a.splice(j,1);
			}
		}
	}
	function clearButton_click() {
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "clearAnswers",{});		
	}	
	function delButton_click() {
		var x = this.prepare_mc.answerInput.text;
		if(x=="" || x==null)
			return;
		var info = _root.getUserInformation();
		if(info.role == "moderator" || 
		   info.star == "moderator" ||
		   info.role == "poweruser" || 
		   info.star == "poweruser" )
			this.connector.send(this.getURI(), "delAnswer",{answer:x});		
	}	
	function typeChange(){
		var tar = this.prepare_mc.typeCombo.getItemAt(this.prepare_mc.typeCombo.selectedIndex);
		//trace("Target: "+this.prepare_mc.typeCombo.selectedIndex+" " + tar.data);	
		this.so.data.type = tar.data;
	}
	function answersChange(tar){
		this.prepare_mc.answerInput.text = tar.label;
	}
}
