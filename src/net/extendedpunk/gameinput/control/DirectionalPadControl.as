package net.extendedpunk.gameinput.control {
	import flash.ui.GameInputControl;

	import net.extendedpunk.gameinput.controller.GameController;

	/**
	 * This class was part of arkeus's (Lee Miller) AS3 Controller Input Library, changed to work within ExtendedFlashpunk.
	 * Github: https://github.com/arkeus/as3-controller-input
	 */
	
	public class DirectionalPadControl {
		public var up:ButtonControl;
		public var down:ButtonControl;
		public var left:ButtonControl;
		public var right:ButtonControl;

		public function DirectionalPadControl(device:GameController, up:GameInputControl, down:GameInputControl, left:GameInputControl, right:GameInputControl) {
			this.up = new ButtonControl(device, up);
			this.down = new ButtonControl(device, down);
			this.left = new ButtonControl(device, left);
			this.right = new ButtonControl(device, right);
		}

		public function reset():void {
			up.reset();
			down.reset();
			left.reset();
			right.reset();
		}
	}
}
