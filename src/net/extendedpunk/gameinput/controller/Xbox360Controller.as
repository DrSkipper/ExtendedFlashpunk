package net.extendedpunk.gameinput.controller {
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import net.extendedpunk.gameinput.control.ButtonControl;
	import net.extendedpunk.gameinput.control.DirectionalPadControl;
	import net.extendedpunk.gameinput.control.JoystickControl;
	import net.extendedpunk.gameinput.control.TriggerControl;

	/**
	 * This class was part of arkeus's (Lee Miller) AS3 Controller Input Library, changed to work within ExtendedFlashpunk.
	 * Github: https://github.com/arkeus/as3-controller-input
	 */
	
	/**
	 * A class containing the bindings for a single Xbox 360 controller.
	 */
	public class Xbox360Controller extends GameController {
		/** The A face button. */
		public var a:ButtonControl;
		/** The B face button. */
		public var b:ButtonControl;
		/** The X face button. */
		public var x:ButtonControl;
		/** The Y face button. */
		public var y:ButtonControl;

		/** Left shoulder button. */
		public var lb:ButtonControl;
		/** Left shoulder trigger. */
		public var lt:TriggerControl;
		/** Left joystick. */
		public var leftStick:JoystickControl;

		/** Right shoulder button. */
		public var rb:ButtonControl;
		/** Right shoulder trigger. */
		public var rt:TriggerControl;
		/** Right joystick. */
		public var rightStick:JoystickControl;

		public var dpad:DirectionalPadControl;

		public var back:ButtonControl;
		public var start:ButtonControl;

		public function Xbox360Controller(device:GameInputDevice) {
			super(device);
		}

		override protected function bindControls():void {
			var controlMap:Object = {};
			for (var i:uint = 0; i < device.numControls; i++) {
				var control:GameInputControl = device.getControlAt(i);
				controlMap[control.id] = control;
			}

			a = new ButtonControl(this, controlMap['BUTTON_4']);
			b = new ButtonControl(this, controlMap['BUTTON_5']);
			x = new ButtonControl(this, controlMap['BUTTON_6']);
			y = new ButtonControl(this, controlMap['BUTTON_7']);

			lb = new ButtonControl(this, controlMap['BUTTON_8']);
			rb = new ButtonControl(this, controlMap['BUTTON_9']);
			lt = new TriggerControl(this, controlMap['BUTTON_10']);
			rt = new TriggerControl(this, controlMap['BUTTON_11']);

			leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_14']);
			rightStick = new JoystickControl(this, controlMap['AXIS_2'], controlMap['AXIS_3'], controlMap['BUTTON_15']);

			dpad = new DirectionalPadControl(this, controlMap['BUTTON_16'], controlMap['BUTTON_17'], controlMap['BUTTON_18'], controlMap['BUTTON_19']);

			back = new ButtonControl(this, controlMap['BUTTON_12']);
			start = new ButtonControl(this, controlMap['BUTTON_13']);
		}

		override public function reset():void {
			a.reset();
			b.reset();
			x.reset();
			y.reset();
			lb.reset();
			rb.reset();
			lt.reset();
			rt.reset();
			leftStick.reset();
			rightStick.reset();
			dpad.reset();
			back.reset();
			start.reset();
		}
	}
}
