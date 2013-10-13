package fp.ext
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
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
			
			_entities = new Vector.<Entity>();
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
			// Make sure to apply our camera's zoom to our entities' images
			var needToApplyZoom:Boolean = worldCamera.zoom != 1.0 && worldCamera.zoom != 0.0;
			
			if (needToApplyZoom)
				this.applyCameraZoomToEntities();
			
			// Render the entities
			super.render();
				
			if (needToApplyZoom)
				this.removeCameraZoomFromEntities();
			
			// Render the UI
			relativeUiController.render();
			staticUiController.render();
		}
		
		override public function add(e:Entity):Entity
		{
			_entities.push(e);
			return super.add(e);
		}
		
		
		// Protected
		protected var _entities:Vector.<Entity>;
		
		protected function applyCameraZoomToEntities():void
		{
			for each (var entity:Entity in _entities)
			{
				entity.x *= worldCamera.zoom;
				entity.y *= worldCamera.zoom;
				var entityGraphic:Graphic = entity.graphic;
				var imageForEntity:Image = entityGraphic as Image;
				
				if (imageForEntity != null)
					imageForEntity.scale *= worldCamera.zoom;
				
				if (entityGraphic != null)
				{
					entityGraphic.x *= worldCamera.zoom;
					entityGraphic.y *= worldCamera.zoom;
				}
			}
		}
		
		protected function removeCameraZoomFromEntities():void
		{
			for each (var entity:Entity in _entities)
			{
				entity.x /= worldCamera.zoom;
				entity.y /= worldCamera.zoom;
				var entityGraphic:Graphic = entity.graphic;
				var imageForEntity:Image = entityGraphic as Image;
				
				if (imageForEntity != null)
					imageForEntity.scale /= worldCamera.zoom;
					
				if (entityGraphic != null)
				{
					entityGraphic.x /= worldCamera.zoom;
					entityGraphic.y /= worldCamera.zoom;
				}
			}
		}
	}
}
