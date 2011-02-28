import mx.core.UIComponent
import mx.controls.RadioButton

class it.unipmn.di.Meeting.components.Poll.RadioButtonCellRender extends UIComponent
{
	private var owner : MovieClip; 
	private var radio : MovieClip;
	private var listOwner : MovieClip; 		// the reference we receive to the list
	private var getCellIndex : Function; 	// the function we receive from the list
	private var	getDataLabel : Function; 	// the function we receive from the list
	
	private static var PREFERRED_HEIGHT = 16; 	// The preferred height of the cell containing the ComboBox.
	private static var PREFERRED_WIDTH = 20; 	// The preferred width of the cell containing the Combobox.

	public function RadioButtonCellRender()
	{
	}

	public function createChildren(Void) : Void
	{
		radio = createObject("RadioButton", "radio", 1, {styleName:this, owner:this});
		radio.addEventListener("click", this);
		size();
	}

	public function size(Void) : Void
	{
		
		radio.enabled = listOwner.enabled;
		radio.setSize(PREFERRED_WIDTH, PREFERRED_WIDTH);
		radio._x = (__width - PREFERRED_WIDTH)/2;
		radio._y = (__height - PREFERRED_HEIGHT)/2;
	}

	public function setValue(str:String, item:Object, sel:Boolean) : Void
	{
		radio._visible = (item!=undefined);
		radio.selected = item[getDataLabel()];
	}

	public function getPreferredHeight(Void) : Number
	{
		return PREFERRED_HEIGHT;
	}

	public function getPreferredWidth(Void) : Number
	{
		return PREFERRED_WIDTH;
	}

	public function click()
	{
		if(listOwner.enabled==false)
		{
			radio.selected=!radio.selected;
			return;
		}
		if(radio.selected==true){
			for(var i=0; i < listOwner.dataProvider.length; i++){
				listOwner.dataProvider.editField(i, getDataLabel(), false);
			}
			listOwner.dataProvider.editField(getCellIndex().itemIndex, getDataLabel(), true);
			listOwner.selectedItem = this.owner;
			var index = getCellIndex();
			listOwner.selectedIndex = index.itemIndex;
			
			listOwner.dispatchEvent({type:"radio", target:this});
		}
	}

}
