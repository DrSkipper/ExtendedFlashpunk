package net.extendedpunk.gameinput.control {
	import flash.events.Event;
	import flash.ui.GameInputControl;

	import net.extendedpunk.gameinput.ControllerInput;
	import net.extendedpunk.gameinput.controller.GameController;

	/**
	 * This class was part of arkeus's (Lee Miller) AS3 Controller Input Library, changed to work within ExtendedFlashpunk.
	 * Github: https://github.com/arkeus/as3-controller-input
	 */
	
	public class ButtonControl extends GameControl {
		private var changed:Boolean = false;
		private var minimum:Number;
		private var maximum:Number;

		public function ButtonControl(device:GameController, control:GameInputControl, minimum:Number = 0.5, maximum:Number = 1) {
			super(device, control);
			this.minimum = minimum;
			this.maximum = maximum;
		}

		public function get pressed():Boolean {
			return updatedAt >= ControllerInput.previous && held && changed;
		}

		public function get released():Boolean {
			return updatedAt >= ControllerInput.previous && !held && changed;
		}

		public function get held():Boolean {
			return value >= minimum && value <= maximum;
		}

		override protected function onChange(event:Event):void {
			var beforeHeld:Boolean = held;
			super.onChange(event);
			changed = held != beforeHeld;
		}
	}
}
