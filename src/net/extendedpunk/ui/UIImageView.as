package net.extendedpunk.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.extendedpunk.ext.EXTUtility;
	import net.extendedpunk.ext.EXTConsole;
	
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
		 * Constructor
		 * @param	position	The initial position of the View, relative to its parent
		 * @param	image		The image to render in this view and determine its size
		 */
		public function UIImageView(position:Point, initialImage:Image) 
		{
			var size:Point = initialImage != null ? 
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
		override protected function renderContent(buffer:BitmapData, absoluteUpperLeft:Point, 
												  absoluteSize:Point, scale:Number):void
		{
			super.renderContent(buffer, absoluteUpperLeft, absoluteSize, scale);
			
			if (_image != null)
			{
				var oldScale:Number = _image.scale;
				_image.scale *= scale;
				_image.render(buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
				_image.scale = oldScale;
			}
		}
	}
}
