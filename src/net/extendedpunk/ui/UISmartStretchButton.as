package net.extendedpunk.ui 
{
	import flash.geom.Point;
	
	/**
	 * UISmartStretchButton
	 * Another button type (in addition to UIButton) which leverages
	 * UISmartImageStretchView to create a button by stretching a 
	 * base image without artifacts around the sides.
	 * Created by Fletcher, 10/22/13
	 */
	public class UISmartStretchButton extends UIView 
	{
		/**
		 * Direct access to specific subviews
		 */
		public var enabledView:UISmartImageStretchView = null;
		public var disabledView:UISmartImageStretchView = null;
		public var hoveringView:UISmartImageStretchView = null;
		public var pressedView:UISmartImageStretchView = null;
		public var selectedView:UISmartImageStretchView = null;
		public var selectedHoveringView:UISmartImageStretchView = null;
		
		/**
		 * Text to be displayed for each state. Null properties will default to enabledText,
		 * except selectedHoveringText, which will default to selectedText.
		 */
		public var enabledText:Text = null;
		public var disabledText:Text = null;
		public var hoveringText:Text = null;
		public var pressedText:Text = null;
		public var selectedText:Text = null;
		public var selectedHoveringText:Text = null;
		
		/**
		 * Constructor
		 * Each of the source paramaters should be the image source to create the
		 * the Image objects for the button with. Unspecified images will default
		 * to enabledImageSource, except for selectedHoveringImageSource, which
		 * defaults to selectedImageSource.
		 * @param	position	The initial position of the View, relative to its parent
		 * @param	size		The initial size of the View
		 * @param	enabledImageSource			Source for enabled state Image
		 * @param	disabledImageSource			Source for disabled state Image
		 * @param	hoveringImageSource			Source for hovering state Image
		 * @param	pressedImageSource			Source for pressed state Image
		 * @param	selectedImageSource			Source for selected state Image
		 * @param	selectedHoveringImageSource	Source for selected hovering state Image
		 */
		public function UISmartStretchButton(position:Point, size:Point, 
											 enabledImageSource:*, 
											 disabledImageSource:* = null,
											 hoveringImageSource:* = null,
											 pressedImageSource:* = null,
											 selectedImageSource:* = null,
											 selectedHoveringImageSource:* = null) 
		{
			this.enabledView = new UISmartImageStretchView(position, size, enabledImageSource);
			
			if (disabledImageSource != null)
				this.disabledView = new UISmartImageStretchView(position, size, disabledImageSource);
			else
				this.disabledView = this.enabledView;
			
			if (hoveringImageSource != null)
				this.hoveringView = new UISmartImageStretchView(position, size, hoveringImageSource);
			else
				this.hoveringView = this.enabledView;
			
			if (pressedImageSource != null)
				this.pressedView = new UISmartImageStretchView(position, size, pressedImageSource);
			else
				this.pressedView = this.enabledView;
			
			if (selectedImageSource != null)
				this.selectedView = new UISmartImageStretchView(position, size, selectedImageSource);
			else
				this.selectecView = this.enabledView;
			
			if (selectedHoveringImageSource != null)
				this.selectedHoveringView = new UISmartImageStretchView(position, size, selectedHoveringImageSource);
			else
				this.selectedHoveringView = this.selectedView;
		}
		
		override public function update():void
		{
			super.update();
			
			// button update logic here
		}
	}
}
