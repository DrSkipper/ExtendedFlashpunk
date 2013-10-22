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
		 * Text to be displayed on each of the images above. Once again, null properties will 
		 * default to enabledText, except selectedHoveringText, which will default to selectedText.
		 */
		public var enabledText:Text = null;
		public var disabledText:Text = null;
		public var hoveringText:Text = null;
		public var pressedText:Text = null;
		public var selectedText:Text = null;
		public var selectedHoveringText:Text = null;
		
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
			this.enabledText = initialText;
			
			if (baseImage != null)
			{
				_enabledImage = baseImage;
				baseImage.scaledWidth = size.x;
				baseImage.scaledHeight = size.y;
			}
			
			this.imageView = new UIImageView(EXTUtility.ZERO_POINT, _enabledImage);
			this.label = new UILabel(EXTUtility.ZERO_POINT, initialText);
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
						this.switchToState(PRESSED_STATE);
					}
					else
					{
						if (!this.selected || !this.selectable)
							this.switchToState(HOVERING_STATE);
						else
							this.switchToState(SELECTED_HOVERING_STATE);
					}
				}
				else
				{
					if (this.selected)
						this.switchToState(SELECTED_STATE);
					else
						this.switchToState(ENABLED_STATE);
				}
				
				if (needsToSendCallback)
					this.invokeCallback();
			}
			else
			{
				this.switchToState(DISABLED_STATE);
			}
		}
		
		/**
		 * Protected
		 */
		protected static const ENABLED_STATE:uint = 0;
		protected static const DISABLED_STATE:uint = 1;
		protected static const HOVERING_STATE:uint = 2;
		protected static const PRESSED_STATE:uint = 3;
		protected static const SELECTED_STATE:uint = 4;
		protected static const SELECTED_HOVERING_STATE:uint = 5;
		
		protected var _enabledImage:Image = null;
		protected var _disabledImage:Image = null;
		protected var _hoveringImage:Image = null;
		protected var _pressedImage:Image = null;
		protected var _selectedImage:Image = null;
		protected var _selectedHoveringImage:Image = null;
		
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
		
		protected function switchToState(state:uint):void
		{
			var newImage:Image = imageView.image;
			var newText:Text = label.text;
			
			switch (state)
			{
				default:
				case ENABLED_STATE:
					newImage = _enabledImage;
					newText = this.enabledText;
					break;
				case DISABLED_STATE:
					newImage = _disabledImage != null ? _disabledImage : _enabledImage;
					newText = this.disabledText != null ? this.disabledText : this.enabledText;
					break;
				case HOVERING_STATE:
					newImage = _hoveringImage != null ? _hoveringImage : _enabledImage;
					newText = this.hoveringText != null ? this.hoveringText : this.enabledText;
					break;
				case PRESSED_STATE:
					newImage = _pressedImage != null ? _pressedImage : _enabledImage;
					newText = this.pressedText != null ? this.pressedText : this.enabledText;
					break;
				case SELECTED_STATE:
					newImage = _selectedImage != null ? _selectedImage : _enabledImage;
					newText = this.selectedText != null ? this.selectedText : this.enabledText;
					break;
				case SELECTED_HOVERING_STATE:
					if (_selectedHoveringImage != null)
						newImage = _selectedHoveringImage;
					else if (_selectedImage != null)
						newImage = _selectedImage;
					else
						newImage = _enabledImage;
					
					if (this.selectedHoveringText != null)
						newText = this.selectedHoveringText;
					else if (this.selectedText != null)
						newText = this.selectedText;
					else
						newText = this.enabledText;
					break;
			}
			
			if (newImage != imageView.image)
				imageView.image = newImage;
			
			if (newText != label.text)
				label.text = newText;
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
