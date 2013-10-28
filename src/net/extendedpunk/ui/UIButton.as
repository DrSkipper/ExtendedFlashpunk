package net.extendedpunk.ui
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.extendedpunk.ext.EXTUtility;
	import net.extendedpunk.ui.UIImageView;

	/**
	 * UIButton
	 * A subclass of UIView which registers clicks, invokes callbacks when clicked,
	 *    and handles a visual clickable representation.
	 * Created by Fletcher, 10/20/13
	 */
	public class UIButton extends UITextButton
	{
		/**
		 * enabledImage : Image to be displayed when button is enabled for interaction and
		 *   not being interacted with. Is also used for other states as a default.
		 */
		public function get enabledImage():Image { return _enabledImage; }
		public function set enabledImage(i:Image):void { _enabledImage = i; updateImageSize(i) }
		
		/**
		 * disabledImage : Image displayed when this button is not enabled for interaction
		 */
		public function get disabledImage():Image { return _disabledImage; }
		public function set disabledImage(i:Image):void { _disabledImage = i; updateImageSize(i); }
		
		/**
		 * hoveringImage : Image displayed when button is enabled and mouse is hovering above it
		 */
		public function get hoveringImage():Image { return _hoveringImage; }
		public function set hoveringImage(i:Image):void { _hoveringImage = i; updateImageSize(i); }
		
		/**
		 * pressedImage : Image displayed when button is enabled and mouse is holding down on it
		 */
		public function get pressedImage():Image { return _pressedImage; }
		public function set pressedImage(i:Image):void { _pressedImage = i; updateImageSize(i); }
		
		/**
		 * selectedImage : Image displayed when button is enabled and in the selected state
		 */
		public function get selectedImage():Image { return _selectedImage; }
		public function set selectedImage(i:Image):void { _selectedImage = i; updateImageSize(i); }
		
		/**
		 * selectedHoveringImage : Image displayed mouse is hovering over button in selected state.
		 * 						   Rather than enabledImage, uses selectedImage as default.
		 */
		public function get selectedHoveringImage():Image { return _selectedHoveringImage; }
		public function set selectedHoveringImage(i:Image):void { _selectedHoveringImage = i; updateImageSize(i); }
		
		/**
		 * Direct access to helpful subview
		 */
		public var imageView:UIImageView = null;
		
		/**
		 * Constructor
		 * @param	position		 The initial position of the View, relative to its parent
		 * @param	size			 The initial size of the View. If null, will use baseImage's size
		 * @param	baseImage		 enabledImage's initial value, and default image for other states
		 * @param	initialText		 Text to display within the button
		 * @param	callback		 Function to call when this button is clicked
		 * @param	callbackArgument Argument to pass to callback function, if necessary
		 */
		public function UIButton(position:Point, size:Point, baseImage:Image, initialText:Text = null, 
								 callback:Function = null, callbackArgument:* = null)
		{
			if (size == null && baseImage != null)
				size = new Point(baseImage.width, baseImage.height);
			
			if (baseImage != null)
			{
				_enabledImage = baseImage;
				baseImage.scaledWidth = size.x;
				baseImage.scaledHeight = size.y;
			}
			
			this.imageView = new UIImageView(EXTUtility.ZERO_POINT, _enabledImage);
			this.addSubview(imageView);
			
			super(position, size, initialText, callback, callbackArgument);
		}
		
		/**
		 * Protected
		 */
		protected var _enabledImage:Image = null;
		protected var _disabledImage:Image = null;
		protected var _hoveringImage:Image = null;
		protected var _pressedImage:Image = null;
		protected var _selectedImage:Image = null;
		protected var _selectedHoveringImage:Image = null;
		
		protected function updateImageSize(image:Image):void
		{
			if (image != null)
			{
				image.scaledWidth = this.size.x;
				image.scaledHeight = this.size.y;
			}
		}
		
		override protected function switchToState(state:uint):void
		{
			super.switchToState(state);
			
			var newImage:Image = imageView.image;
			
			switch (state)
			{
				default:
				case ENABLED_STATE:
					newImage = _enabledImage;
					break;
				case DISABLED_STATE:
					newImage = _disabledImage != null ? _disabledImage : _enabledImage;
					break;
				case HOVERING_STATE:
					newImage = _hoveringImage != null ? _hoveringImage : _enabledImage;
					break;
				case PRESSED_STATE:
					newImage = _pressedImage != null ? _pressedImage : _enabledImage;
					break;
				case SELECTED_STATE:
					newImage = _selectedImage != null ? _selectedImage : _enabledImage;
					break;
				case SELECTED_HOVERING_STATE:
					if (_selectedHoveringImage != null)
						newImage = _selectedHoveringImage;
					else if (_selectedImage != null)
						newImage = _selectedImage;
					else
						newImage = _enabledImage;
					break;
			}
			
			if (newImage != imageView.image)
				imageView.image = newImage;
		}
	}
}
