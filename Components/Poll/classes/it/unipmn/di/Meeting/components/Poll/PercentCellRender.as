import mx.core.UIComponent
import mx.controls.DataGrid

class it.unipmn.di.Meeting.components.Poll.PercentCellRender extends UIComponent
{

	private var perc_txt : TextField;
	private var perc_value;
	private var perc : MovieClip;
	private var owner;						
	private var listOwner : DataGrid;		  
	private var getCellIndex : Function;	
	private var getDataLabel : Function;	
	private var needDraw : Boolean;
	private static var PREFERRED_WIDTH = 100; 			
	private static var PERCENT_HEIGHT = 20;			
	
	private var startDepth:Number = 10;

	// Constructor:  Should be empty.
	public function PercentCellRender()
	{
	}

	//Creates a percBox object and sets listeners.
	public function createChildren(Void) : Void
	{
		if(perc==null || perc==undefined)
			this.createEmptyMovieClip("perc", startDepth++);
		if(perc_txt==null || perc_txt==undefined)
			this.createTextField("perc_txt", startDepth++,0,0,0,0);

		perc_txt.autoSize=true;
		
		perc_txt.textColor = 0x000000;
		perc_txt.text = "0%";
		perc_txt._visible = false;
	}

	public function size(Void) : Void
	{
		if(this.needDraw == false)
			return;
		if(this.perc_value!= undefined && this.perc_value!= null){
			this.clear();
			
			perc_txt._visible = true;
			if(this.perc_value=="" || isNaN(this.perc_value))
				this.perc_value=0;
			else
				perc_txt.text=this.perc_value+"%"
			
			perc.setSize(__width, PERCENT_HEIGHT);
			this.lineStyle(1,0xcccccc,75);
			this.beginFill(0xcccccc,75);
			this.moveTo(0,0);
			this.lineTo((__width*this.perc_value)/100,0);
			this.lineTo((__width*this.perc_value)/100,PERCENT_HEIGHT);		
			this.lineTo(0,PERCENT_HEIGHT);
			this.lineTo(0,0);	
			this.endFill();
			
		}
		else 
			perc_txt._visible = false;
	}

	public function setValue(str:String, item:Object, sel:Boolean) : Void
	{
		this.perc_value = str;
		this.needDraw = (item!=undefined);
	}
	
	public function onLoad()
	{
	}
	
	public function getPreferredHeight(Void) : Number
	{
		return owner.__height;
	}

}
