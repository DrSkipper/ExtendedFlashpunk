package fp.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import fp.ext.EXTUtility;
	import fp.ext.EXTConsole;
	
	/**
	 * UIImageView
	 * A subclass of UIView which renders an image within its bounds.
	 * Created by Fletcher, 9/7/13
	 */
	public class UIImageView extends UIView 
	{
		/**
		 * The image to render in this view
		 */
		public function get image():Image 
		{ 
			return _image;
		}
		public function set image(image:Image):void 
		{ 
			_image = image; 
			this.updateImage(); 
		}
		
		/**
		 * Set this to render image to a non-default buffer
		 */
		//TODO - fcole - Test this
		public var customBuffer:BitmapData = null;
		
		/**
		 * Constructor
		 * @param	position	The initial position of the View, relative to its parent
		 * @param	image		The image to render in this view and determine its size
		 */
		public function UIImageView(position:Point, initialImage:Image) 
		{
			var size:Point = image != null ? 
							 new Point(initialImage.scaledWidth, initialImage.scaledHeight) :
						     new Point();
			super(position, size);
			_image = initialImage;
		}
		
		/**
		 * Update the view's size according to the size of the image
		 */
		public function updateImage():void
		{
			this.size = _image != null ? 
						new Point(_image.scaledWidth, _image.scaledHeight) :
						new Point();
		}
		
		/**
		 * Protected
		 */
		protected var _image:Image;
		
		/**
		 * Override UIView's renderContent() to render an image at this location
		 * @param	absoluteUpperLeft	Screen coordinate to place content at.
		 * @param	absoluteSize		Bounds to render content within.
		 * @param	scale				Zoom level, for scaling images to match.
		 */
		override protected function renderContent(absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			super.renderContent(absoluteUpperLeft, absoluteSize, scale);
			
			var oldScale:Number = image.scale;
			image.scale *= scale;
			image.render(customBuffer != null ? customBuffer : FP.buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
			image.scale = oldScale;
		}
	}
}
