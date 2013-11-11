package net.extendedpunk.gameinput.control {
	import flash.ui.GameInputControl;

	import net.extendedpunk.gameinput.controller.GameController;

	/**
	 * This class was part of arkeus's (Lee Miller) AS3 Controller Input Library, changed to work within ExtendedFlashpunk.
	 * Github: https://github.com/arkeus/as3-controller-input
	 */
	
	public class TriggerControl extends ButtonControl {
		public function TriggerControl(device:GameController, control:GameInputControl) {
			super(device, control);
		}

		public function get distance():Number {
			return value;
		}
	}
}
