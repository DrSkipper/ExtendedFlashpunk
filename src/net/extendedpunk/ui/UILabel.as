package net.extendedpunk.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Text;
	import net.extendedpunk.ext.EXTUtility;
	
	/**
	 * UILabel
	 * A subclass of UIView which displays text within its bounds.
	 * Created by Fletcher, 10/19/13
	 */
	public class UILabel extends UIView 
	{
		/**
		 * The text to display in this view
		 */
		public var text:Text;
		
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
		
		override public function update():void
		{
			// Update the view's size according to the size of the text
			if (this.text != null)
			{
				this.size.x = this.text.scaledWidth;
				this.size.y = this.text.scaledHeight;
			}
			
			super.update();
		}
		
		/**
		 * Protected
		 *
		 * Override UIView's renderContent() to render text at this location
		 * @param	absoluteUpperLeft	Screen coordinate to place content at.
		 * @param	absoluteSize		Bounds to render content within.
		 * @param	scale				Zoom level, for scaling images to match.
		 */
		override protected function renderContent(buffer:BitmapData, absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			super.renderContent(buffer, absoluteUpperLeft, absoluteSize, scale);
			
			if (this.text != null)
			{
				var oldScale:Number = this.text.scale;
				this.text.scale *= scale;
				this.text.render(buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
				this.text.scale = oldScale;
			}
		}
	}
}
