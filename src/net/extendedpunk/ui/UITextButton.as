package net.extendedpunk.ui
{
	import flash.geom.Point;
	import net.extendedpunk.ext.EXTUtility;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * UITextButton
	 * Super class for UIButton and UISmartStretchButton. Can be instantiated
	 * to create a button with a label but no image.
	 * Created by Fletcher, 10/27/13
	 */
	public class UITextButton extends UIView
	{
		/**
		 * Text to be displayed on each of the images above. Null properties will default
		 * to enabledText, except selectedHoveringText, which will default to selectedText.
		 */
		public var enabledText:Text = null;
		public var disabledText:Text = null;
		public var hoveringText:Text = null;
		public var pressedText:Text = null;
		public var selectedText:Text = null;
		public var selectedHoveringText:Text = null;
		
		/**
		 * Direct access to helpful subview
		 */
		public var label:UILabel = null;
		
		/**
		 * States and transitions
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(e:Boolean):void { toggleEnabledState(e); }
		public function get selected():Boolean { return _selected; }
		public function set selected(s:Boolean):void { toggleSelectedState(s); }
		public var selectable:Boolean = false;
		public var unselectIfClickedWhileSelected:Boolean = true;
		
		/**
		 * Constructor
		 * @param	position		 The initial position of the View, relative to its parent
		 * @param	size			 The initial size of the View. If null, will use baseImage's size
		 * @param	initialText		 Text to display within the button. Initializes enabledText.
		 * @param	callback		 Function to call when this button is clicked
		 * @param	callbackArgument Argument to pass to callback function, if necessary
		 */
		public function UITextButton(position:Point, size:Point, initialText:Text = null,  
									 callback:Function = null, callbackArgument:* = null)
		{
			super(position, size);
			
			_callback = callback;
			_argument = callbackArgument;
			this.enabledText = initialText;
			
			this.label = new UILabel(EXTUtility.ZERO_POINT, initialText);
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
				
				if (_mouseIsOverView)
				{
					if (Input.mousePressed)
					{
						_pressed = true;
						this.switchToState(PRESSED_STATE);
					}
					else if (Input.mouseReleased && _pressed)
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
					
					if (!Input.mouseDown)
					{
						_pressed = false;
						
						if (!this.selected || !this.selectable)
							this.switchToState(HOVERING_STATE);
						else
							this.switchToState(SELECTED_HOVERING_STATE);
					}
				}
				else
				{
					_pressed = false;
					
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
		
		protected var _enabled:Boolean = true;
		protected var _selected:Boolean = false;
		protected var _pressed:Boolean = false;
		
		protected var _callback:Function;
		protected var _argument:*;
		
		/**
		 * Logic to execute when switching to the given button state
		 */
		protected function switchToState(state:uint):void
		{
			var newText:Text = label.text;
			
			switch (state)
			{
				default:
				case ENABLED_STATE:
					newText = this.enabledText;
					break;
				case DISABLED_STATE:
					newText = this.disabledText != null ? this.disabledText : this.enabledText;
					break;
				case HOVERING_STATE:
					newText = this.hoveringText != null ? this.hoveringText : this.enabledText;
					break;
				case PRESSED_STATE:
					newText = this.pressedText != null ? this.pressedText : this.enabledText;
					break;
				case SELECTED_STATE:
					newText = this.selectedText != null ? this.selectedText : this.enabledText;
					break;
				case SELECTED_HOVERING_STATE:
					if (this.selectedHoveringText != null)
						newText = this.selectedHoveringText;
					else if (this.selectedText != null)
						newText = this.selectedText;
					else
						newText = this.enabledText;
					break;
			}
			
			if (newText != label.text)
				label.text = newText;
		}
		
		/**
		 * Helpers for toggling a couple states
		 */
		public function toggleEnabledState(shouldBeOn:Boolean):void
		{
			if (shouldBeOn != _enabled)
			{
				if (shouldBeOn)
					switchToState(ENABLED_STATE);
				else
					switchToState(DISABLED_STATE);
			}
			_enabled = shouldBeOn;
		}
		
		public function toggleSelectedState(shouldBeOn:Boolean):void
		{
			if (shouldBeOn != _selected)
			{
				if (_enabled)
				{
					if (shouldBeOn)
					{
						if (!_mouseIsOverView)
							switchToState(SELECTED_STATE);
						else
							switchToState(SELECTED_HOVERING_STATE);
					}
					else
					{
						if (!_mouseIsOverView)
							switchToState(ENABLED_STATE);
						else
							switchToState(HOVERING_STATE);
					}
				}
			}
			_selected = shouldBeOn;
		}
		
		/**
		 * Send the callback for this button
		 */
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
