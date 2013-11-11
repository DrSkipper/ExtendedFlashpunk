package net.extendedpunk.gameinput.control {
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	import net.extendedpunk.gameinput.ControllerInput;
	import net.extendedpunk.gameinput.controller.GameController;

	/**
	 * This class was part of arkeus's (Lee Miller) AS3 Controller Input Library, changed to work within ExtendedFlashpunk.
	 * Github: https://github.com/arkeus/as3-controller-input
	 */
	
	public class GameControl {
		private var device:GameController;
		private var control:GameInputControl;

		public var value:Number = 0;
		public var updatedAt:uint = 0;

		public function GameControl(device:GameController, control:GameInputControl) {
			this.device = device;
			this.control = control;

			if (control != null) {
				this.control.addEventListener(Event.CHANGE, onChange);
			}
		}

		public function reset():void {
			value = 0;
			updatedAt = 0;
		}

		protected function onChange(event:Event):void {
			value = (event.target as GameInputControl).value;
			updatedAt = ControllerInput.now;
		}
	}
}
