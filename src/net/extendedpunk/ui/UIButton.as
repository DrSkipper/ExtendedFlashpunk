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
		 *    NOTE - The button is deemed "selectable" if selectedImage is not null.
		 */
		public function get selectedImage():Image { return _selectedImage }
		public function set selectedImage(i:Image):void { _selectedImage = i; updateImageSize(i); }
		
		/**
		 * Direct access to helpful subviews
		 */
		public var imageView:UIImageView; // Used if smartStretchImage is false
		public var smartStretchView:UISmartImageStretchView; // Used if smartStretchImage is true
		public var label:UILabel;
		
		/**
		 * Constructor
		 * @param	position	The initial position of the View, relative to its parent
		 * @param	size		The initial size of the View. If null, will use baseImage's size
		 * @param	baseImage	enabledImage's initial value, and default image for other states
		 * @param	initialText	Text to display within the button
		 */
		public function UIButton(position:Point, size:Point, baseImage:Image, initialText:Text)
		{
			if (size == null && baseImage != null)
				size = new Point(baseImage.width, baseImage.height);
			
			super(position, size);
			
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
		 * Protected
		 */
		protected var _enabledImage:Image = null;
		protected var _disabledImage:Image = null;
		protected var _hoveringImage:Image = null;
		protected var _pressedImage:Image = null;
		protected var _selectedImage:Image = null;
		
		protected function updateImageSize(image:Image):void
		{
			if (image != null)
			{
				image.scaledWidth = this.size.x;
				image.scaledHeight = this.size.y;
			}
		}
		
//	http://active.tutsplus.com/tutorials/games/an-introduction-to-flashpunk-the-basics/
		//protected var _map:Spritemap;
		//protected var _over:Boolean;
		//protected var _clicked:Boolean;
		//protected var _callback:Function;
		//protected var _argument:*;
		//protected var _label:Text = null;
		//
		//public function UIButton(callback:Function, argument:*, x:Number = 0, y:Number = 0)
		//{
			//super(x, y);
			//this.centerOrigin();
			//
			//_callback = callback;
			//_argument = argument;
		//}
		//
		//
		//public function setSpritemap(asset:*, frameW:uint, frameH:uint, text:String = null):void
		//{
			//this._map = new Spritemap(asset, frameW, frameH);
			//
			//this._map.add("Up",   [2]);
			//this._map.add("Over", [1]);
			//this._map.add("Down", [0]);
			//
//			graphic = _map;
			//this._map.centerOrigin();
			//this.addGraphic(_map);
			//this.setHitbox(frameW, frameH);
			//this.layer = -2;
			//
			//if (text != null)
			//{
				//this._label = new Text(text, 0, 0);
				//this._label.centerOO();
				//this.addGraphic(this._label);
			//}
		//}
		//
		//override public function update():void
		//{
			//if (!world)
			//{
				//return;
			//}
			//
			//if (this._label != null)
				//this._label.update();
			//
			//_over = false;
			//_clicked = false;
			//
			//if (collidePoint(x - world.camera.x, y - world.camera.y, Input.mouseX, Input.mouseY))
			//{
				//if (Input.mouseReleased)
				//{
					//clicked();
				//}
				//else if (Input.mouseDown)
				//{
					//mouseDown();
				//}
				//else
				//{
					//mouseOver();
				//}
			//}
		//}
		//
		//protected function clicked():void
		//{
			//if (!_argument)
			//{
				//_callback();
			//}
			//else
			//{
				//_callback(_argument);
			//}
		//}
		//
		//protected function mouseOver():void
		//{
			//_over = true;
		//}
		//
		//protected function mouseDown():void
		//{
			//_clicked = true;
		//}
		//
		//override public function render():void
		//{
			//if (_clicked)
			//{
				//_map.play("Down");
			//}
			//else if (_over)
			//{
				//_map.play("Over");
			//}
			//else
			//{
				//_map.play("Up");
			//}
			//
			//super.render();
		//}
		
	}
	
}
