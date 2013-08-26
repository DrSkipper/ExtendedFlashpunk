package fp.ext
{
	import flash.geom.Point;
	import net.flashpunk.World;

	// Hover Camera
	//   Camera with added functionality to allow a hovering
	//   animation around its target.
	//   This function can be used to create a number of effects,
	//   such as screen shakes, head bob, or just making a 
	//   static scene feel more lively.
	// Created by Fletcher 8/25/13
	public class EXTHoverCamera extends EXTCamera
	{
		public function EXTHoverCamera()
		{
			super();
			
			_hovering = false;
			_hoverTarget = new Point();
			_hoverVelocity = new Point();
			_maxHover = new Point();
			_hoverDistance = new Point();
			_hoverSpeed = 0.0;
			_hoverOffset = new Point();
		}
		
		// Set the camera to hover around its target point.
		//  variance - Maximum distance to stray
		//  speed - speed of movement
		public function enableHovering(xVariance:Number, yVariance: Number, speed:Number):void
		{
			_hovering = true;
			_maxHover = new Point(xVariance, yVariance);
			_hoverSpeed = speed;
			_hoverOffset = new Point();
			_hoverDistance = new Point();
			_hoverVelocity = new Point();
			this.findHoverTarget();
		}
		
		public function disableHovering():void
		{
			_hovering = false;
		}
		
		// Overridden EXTCamera methods
		override public function update():void
		{
			super.update();
			if (_hovering)
			{
				var hoverDistance:Point = _hoverTarget.subtract(_hoverOffset);
				var distanceMagnitude:Number = hoverDistance.length;
				var newTarget:Boolean = false;
				
//				if (distanceMagnitude <= 2 * _hoverSpeed)
				if ((hoverDistance.x < 0 && _hoverDistance.x >= 0) ||
					(hoverDistance.x >= 0 && _hoverDistance.x < 0) ||
					(hoverDistance.y < 0 && _hoverDistance.y >= 0) ||
					(hoverDistance.y >= 0 && _hoverDistance.y < 0))
				{
					newTarget = true;
					this.findHoverTarget();
					
					hoverDistance = _hoverTarget.subtract(_hoverOffset);
					_hoverDistance.x = hoverDistance.x;
					_hoverDistance.y = hoverDistance.y;
					_hoverVelocity.x = 0;
					_hoverVelocity.y = 0;
				}
				
				var _hoverVelocityMagnitude:Number = _hoverVelocity.length;
				hoverDistance.normalize(1.0);
				
				if (!newTarget && distanceMagnitude <= _hoverDistance.length / 3.0)
				{
					if (_hoverVelocityMagnitude > _hoverSpeed)
					{
						_hoverVelocity.x -= hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y -= hoverDistance.y * _hoverSpeed;
					}
					else
					{
						_hoverVelocity.x = hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y = hoverDistance.y * _hoverSpeed;
					}
				}
				else
				{
					if (distanceMagnitude > _hoverDistance.length * 2.0 / 3.0)
					{
						var maxSpeed:Number = _hoverSpeed * 5;
						
//						if (_hoverVelocityMagnitude < maxSpeed)
//						{
						_hoverVelocity.x += hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y += hoverDistance.y * _hoverSpeed;
//						}
//						else
//						{
//							_hoverVelocity.x = hoverDistance.x * _hoverSpeed;
//							_hoverVelocity.y = hoverDistance.y * _hoverSpeed;
//						}
					}
				}
				
				_hoverOffset.x += _hoverVelocity.x;
				_hoverOffset.y += _hoverVelocity.y;
			}
		}
		
		override public function prepareWorldForRender(world:World):void
		{
			super.prepareWorldForRender(world);
			
			if (_hovering)
			{
				world.camera.x = (int)(this.x + _hoverOffset.x);
				world.camera.y = (int)(this.y + _hoverOffset.y);
			}
		}
		
		
		//Private
		private var _hovering:Boolean;
		private var _hoverSpeed:Number;
		private var _maxHover:Point;
		private var _hoverOffset:Point;
		private var _hoverTarget:Point;
		private var _hoverVelocity:Point;
		private var _hoverDistance:Point;
		
		// Find a random point in an ellipse created by the hover variance
		private function findHoverTarget():void
		{
			if (_maxHover.x == 0.0)
			{
				_hoverTarget.x = 0;
				_hoverTarget.y = Math.random() * _maxHover.y;
			}
			else if (_maxHover.y == 0.0)
			{
				_hoverTarget.x = Math.random() * _maxHover.x;
				_hoverTarget.y = 0;
			}
			else
			{
				var randomAngle:Number = Math.random() * 360.0;
				var randomRoot:Number = Math.sqrt(Math.random() * 1.0);
				_hoverTarget.x = Math.cos(randomAngle) * randomRoot * _maxHover.x / 2.0;
				_hoverTarget.y = Math.sin(randomAngle) * randomRoot * _maxHover.y / 2.0;
			}
		}
	}
}
