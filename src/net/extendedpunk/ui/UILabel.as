package fp.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	import fp.ext.EXTUtility;
	
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
		 * Set this to render image to a non-default buffer
		 */
		//TODO - fcole - Test this, also probably move to view controller level
		public var customBuffer:BitmapData = null;
		
		/**
		 * Constructor
		 * @param	postition	The initial position of the View, relative to its parent
		 * @param	initialText	The text to display in this view and determine its size
		 */
		public function UILabel(position:Point, initialText:Text) 
		{
			var size:Point = initialText != null ? 
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
		
		/**
		 * Override UIView's renderContent() to render text at this location
		 * @param	absoluteUpperLeft	Screen coordinate to place content at.
		 * @param	absoluteSize		Bounds to render content within.
		 * @param	scale				Zoom level, for scaling images to match.
		 */
		override protected function renderContent(absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			super.renderContent(absoluteUpperLeft, absoluteSize, scale);
			
			var oldScale:Number = _text.scale;
			_text.scale *= scale;
			_text.render(customBuffer != null ? customBuffer : FP.buffer, 
							absoluteUpperLeft, EXTUtility.ZERO_POINT);
			_text.scale = oldScale;
		}
	}
}
