package fp.ui 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Text;
	
	/**
	 * UILabel
	 * A subclass of UIView which displays text within its bounds.
	 * Created by Fletcher, 10/19/2013
	 */
	public class UILabel extends UIView 
	{
		/**
		 * The text to display in this view
		 */
		public function get text():Text
		{
			return _text;
		}
		public function set text(text:Text):void
		{
			_text = text;
			this.updateText();
		}
		
		/**
		 * Constructor
		 * @param	postition	The initial position of the View, relative to its parent
		 * @param	initialText	The text to display in this view and determine its size
		 */
		public function UILabel(postition:Point, initialText:Text) 
		{
			var size:Point = text != null ? 
							 new Point(initialText.scaledWidth, initialText.scaledHeight) :
							 new Point();
			super(position, size);
			text = initialText;
		}
		
		/**
		 * Update the view's size according to the size of the text
		 */
		public function updateText():void
		{
			this.size = _text != null ? 
						new Point(_text.scaledWidth, _text.scaledHeight) :
						new Point();
		}
		
		/**
		 * Protected
		 */
		protected var _text:Text;
	}
}
