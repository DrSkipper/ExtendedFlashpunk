package net.extendedpunk.ext
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.extendedpunk.ui.UIViewController;
	
	/**
	 * Extended World
	 * Subclass of Flashpunk's World which now contains references
	 * to a fully functional camera and root UI objects.
	 * Created by Fletcher, 8/25/13
	 */
	public class EXTWorld extends World
	{
		public var worldCamera:EXTCamera;
		public var staticUiController:UIViewController;		// Controls non-camera relative UI
		public var relativeUiController:UIViewController;	// Controls camera relative UI
		
		/**
		 * Constructor
		 */
		public function EXTWorld()
		{
			super();
			
			_entities = new Vector.<Entity>();
			var screenSize:Point = new Point(FP.screen.width, FP.screen.height);
			worldCamera = new EXTCamera();
			staticUiController = new UIViewController(screenSize);
			relativeUiController = new UIViewController(screenSize, worldCamera);
		}
		
		/**
		 * Update the world's camera, entities, and UI
		 */
		override public function update():void
		{
			// Update the world, and camera
			worldCamera.update();
			super.update();
			
			// Prepare the world for rendering using camera's position
			this.camera.x = (int)(this.worldCamera.x * this.worldCamera.zoom);
			this.camera.y = (int)(this.worldCamera.y * this.worldCamera.zoom);
			
			// Update the UI
			relativeUiController.update();
			staticUiController.update();
		}
		
		/**
		 * Render the world's entities and UI
		 */
		override public function render():void
		{
			// Make sure to apply our camera's zoom to our entities' images
			//NOTE - This hackish solution for zooming allows us the desired effect without
			//		 directly messing with Flashpunk's code or other overhead like adding a
			//		 number of subclasses
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
		
		/**
		 * Adds the Entity to the World at the end of the frame.
		 * Overridden so we can keep track of entities.
		 * @param	e		Entity object you want to add
		 * @return	The added Entity object
		 */
		override public function add(e:Entity):Entity
		{
			_entities.push(e);
			return super.add(e);
		}
		
		
		/**
		 * Protected
		 * See NOTE in render() method above for explanation of usage
		 */
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
