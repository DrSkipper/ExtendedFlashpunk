package net.extendedpunk.ui
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.extendedpunk.ext.EXTUtility;
	import net.extendedpunk.ext.EXTOffsetType;
	import net.extendedpunk.ui.UIImageView;

	/**
	 * UIButton
	 * A subclass of UIView which registers clicks, invokes callbacks when clicked,
	 *    and handles a visual clickable representation.
	 * Created by Fletcher, 10/20/13
	 */
	public class UIButton extends UIView
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
		public function get disabledImage():Image { return _disabledImage }
		public function set disabledImage(i:Image):void { _disabledImage = i; updateImageSize(i); }
		
		/**
		 * hoveringImage : Image displayed when button is enabled and mouse is hovering above it
		 */
		public function get hoveringImage():Image { return _hoveringImage }
		public function set hoveringImage(i:Image):void { _hoveringImage = i; updateImageSize(i); }
		
		/**
		 * pressedImage : Image displayed when button is enabled and mouse is holding down on it
		 */
		public function get pressedImage():Image { return _pressedImage }
		public function set pressedImage(i:Image):void { _pressedImage = i; updateImageSize(i); }
		
		/**
		 * selectedImage : Image displayed when button is enabled and in the selected state.
		 */
		public function get selectedImage():Image { return _selectedImage }
		public function set selectedImage(i:Image):void { _selectedImage = i; updateImageSize(i); }
		
		/**
		 * Direct access to helpful subviews
		 */
		public var imageView:UIImageView = null;
		public var label:UILabel = null;
		
		/**
		 * States and transitions
		 */
		public var enabled:Boolean = true;
		public var selected:Boolean = false;
		public var selectable:Boolean = false;
		public var unselectIfClickedWhileSelected:Boolean = true;
		
		/**
		 * Constructor
		 * @param	position		 The initial position of the View, relative to its parent
		 * @param	size			 The initial size of the View. If null, will use baseImage's size
		 * @param	baseImage		 enabledImage's initial value, and default image for other states
		 * @param	initialText		 Text to display within the button
		 * @param	callback		 Function to call when this button is clicked
		 * @param	callbackArgument Argument to pass to callback function, if necessary
		 */
		public function UIButton(position:Point, size:Point, baseImage:Image, initialText:Text, 
								 callback:Function, callbackArgument:*)
		{
			if (size == null && baseImage != null)
				size = new Point(baseImage.width, baseImage.height);
			
			super(position, size);
			
			_callback = callback;
			_argument = callbackArgument;
			
			if (baseImage != null)
			{
				_enabledImage = baseImage;
				baseImage.scaledWidth = size.x;
				baseImage.scaledHeight = size.y;
			}
			
			imageView = new UIImageView(EXTUtility.ZERO_POINT, _enabledImage);
			label = new UILabel(EXTUtility.ZERO_POINT, initialText);
			this.addSubview(imageView);
			this.addSubview(label);
		}
		
		/**
		 * Override UIView's update to check for user interaction
		 */
		override public function update():void
		{
			super.update();
			
			if (this.enabled)
			{
				var needsToSendCallback:Boolean = false;
				
				if (_mouseIsOverButton)
				{
					if (Input.mousePressed)
					{
						needsToSendCallback = true;
						
						if (this.selectable)
						{
							if (!this.selected)
								this.selected = true;
							else if (this.unselectIfClickedWhileSelected)
								this.selected = false;
						}
					}
					
					if (Input.mouseDown)
					{
						this.switchToImage(_pressedImage);
					}
					else
					{
						//TODO - fcole - Allow separate hovering image when selected?
						if (!this.selected || !this.selectable)
							this.switchToImage(_hoveringImage);
						else
							this.switchToImage(_selectedImage);
					}
				}
				else
				{
					if (this.selected)
						this.switchToImage(_selectedImage);
					else
						this.switchToImage(_enabledImage);
				}
				
				if (needsToSendCallback)
					this.invokeCallback();
			}
			else
			{
				this.switchToImage(_disabledImage);
			}
		}
		
		/**
		 * Protected
		 */
		protected var _enabledImage:Image = null;
		protected var _disabledImage:Image = null;
		protected var _hoveringImage:Image = null;
		protected var _pressedImage:Image = null;
		protected var _selectedImage:Image = null;
		
		protected var _mouseIsOverButton:Boolean = false;
		protected var _callback:Function;
		protected var _argument:*;
		
		/**
		 * Override renderContent() so we can check if the mouse is within our absolute bounds
		 */
		//TODO - fcole - This shouldn't really be done during the render phase, should the UI
		//    update tree also contain absolute position information?
		override protected function renderContent(absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			_mouseIsOverButton = EXTUtility.PointIsInsideContainer(new Point(Input.mouseX, Input.mouseY), absoluteUpperLeft, absoluteSize, EXTOffsetType.TOP_LEFT);
		}
		
		protected function updateImageSize(image:Image):void
		{
			if (image != null)
			{
				image.scaledWidth = this.size.x;
				image.scaledHeight = this.size.y;
			}
		}
		
		protected function switchToImage(image:Image):void
		{
			if (image != null && imageView.image != image)
				imageView.image = image;
		}
		
		protected function invokeCallback():void
		{
			if (_callback != null)
			{
				if (_argument != null)
					_callback(_argument);
				else
					_callback();
			}
		}
	}
}
