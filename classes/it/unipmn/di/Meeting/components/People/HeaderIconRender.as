import mx.controls.DataGrid;
import mx.controls.gridclasses.DataGridColumn;

class it.unipmn.di.Meeting.components.People.HeaderIconRender extends mx.core.UIComponent
{
/** Reference to the renderer graphic */
private var icon:MovieClip;

/** Reference to the data grid that owns this renderer */
private var owner:DataGrid;

/**
* A reference to the data grid column object
* that this header renderer is contained in
*/
private var column:DataGridColumn;

/** Constructor */
public function HeaderIconRender ()
{

}

/** create the button within the cell */
private function createChildren ():Void
{
}

private function getColumnReference ():Void
{
/*trace ("Is column a DataGridColumn : " + (column instanceof DataGridColumn));
trace ("column : " + column);
trace ("\rproperties:");
for (var i in column)
trace ("\t" + i + " : " + column[i]);
*/
}

/**
* Method that must be implemented on all CellRenderers. A cell renderer class that
* extends UIComponent (which extends UIObject) must implement size() instead of setSize().
* This method will resize and position the CellRenderer whenever the user resizes the columns
*/
private function size ():Void
{
	if(icon != undefined)
		icon.removeMovieClip();
// create an instance of the icon
	icon = createObject (column["columnIcon"], "icon", 1);

}

/**
* Method that must be implemented on all CellRenderers.
* Sets the visibility of the cellRenderer to false if there is no info for the specified row.
* Also places data on the cellRenderer so that it can be rendered correctly. This method
* will usually be called when the user makes changes to the data grid... like scrolling and
* resizing.
*
* @param pSuggested A value to be used for the cell renderer's text, if any is needed.
* @param pItem An object that is the entire item to be rendered. The cell renderer can use properties of this object for rendering.
* @param pSel A string with the following possible values: "normal", "highlighted", and "selected".
*/
private function setValue (pSuggested:Number, pItem:Object, pSel:Boolean):Void
{
// This doLater is inherited from UIObject......this allows the need time for this
// class to initialize and allow the column property to be available to reference
//doLater (this, "getColumnReference");
}

/**
* Method that must be implemented on all CellRenderers.
* This is especially important for getting the right height of text within the cell. If you set this value higher
* than the rowHeight property of the component, cells will bleed above and below the rows.
*
* It tells the rows of the list how to center the cell and how to adjust the cell's height if necessary.
* If necessary, you can return a constant (for example, 22), or you can measure and return the height
* of the contents. You can also return owner.height, which is the height of the row.
*
* @return The preferred height of a cell.
*/
private function getPreferredHeight ():Number
{
return owner._height;
}
}