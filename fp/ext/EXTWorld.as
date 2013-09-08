package fp.ext
{
	import flash.geom.Point;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import fp.ui.UIViewController;
	
	public class EXTWorld extends World
	{
		public var worldCamera:EXTCamera;
		public var staticUiController:UIViewController;
		public var relativeUiController:UIViewController;
		
		public function EXTWorld()
		{
			super();
			
			var screenSize:Point = new Point(FP.screen.width, FP.screen.height);
			worldCamera = new EXTCamera();
			staticUiController = new UIViewController(screenSize);
			relativeUiController = new UIViewController(screenSize, worldCamera);
		}
		
		override public function update():void
		{
			worldCamera.update();
			super.update();
			worldCamera.prepareWorldForRender(this);
			relativeUiController.update();
			staticUiController.update();
		}
		
		override public function render():void
		{
			super.render();
			relativeUiController.render();
			staticUiController.render();
		}
	}
}
