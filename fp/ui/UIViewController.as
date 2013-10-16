package fp.ui 
{
	import flash.geom.Point;
	import fp.ext.EXTUtility;
	import fp.ext.EXTCamera;
	import fp.ui.UIView;
	import fp.ext.EXTConsole;
	
	/**
	 * UIViewController
	 * Top level of a UIView tree. May be configured to manage its views
	 *    relative to a camera, or be placed statically on the screen.
	 * Created by Fletcher, 9/7/13
	 */
	public class UIViewController 
	{
		/**
		 * The root view of the UI tree managed by this controller.
		 * UI for this tree should be added as subviews to this view.
		 */
		public var rootView:UIView;
		
		/**
		 * Constructor. Usually UI positioning is independent of camera location,
		 *    but a camera to draw relative to may be specified if there is a 
		 *    desire to have UIViews located in the game word. The bounds of a 
		 *    view controller are usually equal to the size of the screen.
		 * @param	bounds		Size of the root view of this view controller.
		 * @param	camera		[Optional] Camera to measure relative positions to.
		 */
		public function UIViewController(bounds:Point, camera:EXTCamera = null) 
		{
			rootView = new UIView(EXTUtility.ZERO_POINT, bounds);
			_camera = camera;
		}
		
		/**
		 * Update the UI owned by this controller
		 */
		public function update():void
		{
			rootView.update();
		}
		
		/**
		 * Render the UI owned by this controller
		 */
		public function render():void
		{
			var offsetPosition:Point = EXTUtility.ZERO_POINT;
			var bounds:Point = new Point(rootView.size.x, rootView.size.y);
			var scale:Number = 1.0;
			
			if (_camera != null)
			{
				offsetPosition = new Point(-_camera.x * _camera.zoom, -_camera.y * _camera.zoom);
				scale = _camera.zoom;
				bounds.x *= scale;
				bounds.y *= scale;
			}
			
			rootView.render(offsetPosition, bounds, scale);
		}
		
		/**
		 * Protected
		 */
		protected var _camera:EXTCamera = null;
	}
}
