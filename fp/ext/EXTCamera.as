package fp.ext
{
	import flash.geom.Point;
	
	import fp.ext.EXTConsole;
	import fp.ext.EXTOffsetType;
	import fp.ext.EXTUtility;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;

	// Extended Camera
	// Handles transformations to be made to the world before rendering
	// Created by Fletcher, 6/2/13
	public class EXTCamera
	{
		// Public Variables
		// x and y represent pixel coordinates in the world when zoom is at 1.0
		public var x:Number;    // Position (upper-left)
		public var y:Number;
		public var vx:Number;   // Velocity
		public var vy:Number;
		public var ax:Number;   // Acceleration
		public var ay:Number;
		public var zoom:Number; // Zoom
		public var zoomVelocity:Number;
		public var zoomAcceleration:Number;
		
		// Constructor
		public function EXTCamera()
		{
			x = y = 0.0;
			vx = vy = 0.0;
			ax = ay = 0.0;
			zoom = 1.0;
			
			_lastFrameX = _lastFrameY = 0.0;
			_lerping = false;
			_lerpStartPosition = new Point();
			_lerpDestination = new Point();
			_lerpTotalDistance = 0.0;
		}
		
		// Returns the current size of the view, given the camera's 
		//   current zoom value and the size of the screen.
		//TODO - fcole - Account for zoom level
		public function currentViewSize():Point
		{
			return new Point(FP.screen.width, FP.screen.height);
		}
		
		public function currentPosition(offsetType:EXTOffsetType, useLastFramePosition:Boolean = false):Point
		{
			var screenSize:Point = this.currentViewSize();
			var baseX:Number = useLastFramePosition ? _lastFrameX : this.x;
			var baseY:Number = useLastFramePosition ? _lastFrameY : this.y;
			
			if (offsetType == EXTOffsetType.TOP_LEFT)
				return new Point(baseX, baseY);
			if (offsetType == EXTOffsetType.TOP_RIGHT)
				return new Point(baseX + screenSize.x, baseY);
			if (offsetType == EXTOffsetType.BOTTOM_LEFT)
				return new Point(baseX, baseY + screenSize.y);
			if (offsetType == EXTOffsetType.BOTTOM_RIGHT)
				return new Point(baseX + screenSize.x, baseY + screenSize.y);
			if (offsetType == EXTOffsetType.CENTER)
				return new Point(baseX + screenSize.x / 2, baseY + screenSize.y / 2);
			if (offsetType == EXTOffsetType.TOP_CENTER)
				return new Point(baseX + screenSize.x / 2, baseY);
			if (offsetType == EXTOffsetType.BOTTOM_CENTER)
				return new Point(baseX + screenSize.x / 2, baseY + screenSize.y);
			if (offsetType == EXTOffsetType.LEFT_CENTER)
				return new Point(baseX, baseY + screenSize.y / 2);
			if (offsetType == EXTOffsetType.RIGHT_CENTER)
				return new Point(baseX + screenSize.x, baseY + screenSize.y / 2);
			
			EXTConsole.error("EXTCamera", "currentPosition()", "Invalid offset found: %s", offsetType.Text);
			return new Point();		
		}
		
		// Current position is offset by given values
		public function moveDistance(dx:Number, dy:Number):void
		{
			x += dx;
			y += dy;
		}
		
		// Current velocity is offset by given values
		public function alterVelocity(dvx:Number, dvy:Number):void
		{
			vx += dvx;
			vy += dvy;
		}
		
		// Current acceleration is offset by given values
		//  fx and fy are in units of pixels per second per second
		public function applyForce(fx:Number, fy:Number):void
		{
			ax += fx;
			ay += fy;
		}
		
		// Camera will smoothly animate to given position.
		//   px and py indicate target upper-left camera position.
		//TODO - fcole - Allow input of various lerping functions
		public function lerpToPosition(px:Number, py:Number):void
		{
			var oldStartPosition:Point = _lerpStartPosition;
			
			this.ax = 0;
			this.ay = 0;
			
			_lerpStartPosition.x = this.x;
			_lerpStartPosition.y = this.y;
			_lerpDestination.x = px;
			_lerpDestination.y = py;
			
			var diffX:Number = px - this.x;
			var diffY:Number = py - this.y;
			_lerpTotalDistance = Math.sqrt((diffX * diffX) + (diffY * diffY));
			
			if (_lerping)
			{
				var oldVMagnitude:Number = Math.sqrt((vx * vx) + (vy * vy));
				var xProportion:Number = diffX / _lerpTotalDistance;
				var yProportion:Number = diffY / _lerpTotalDistance;
				
				diffX = this.x - oldStartPosition.x;
				diffY = this.y - oldStartPosition.y;
				var oldDistance:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
				
				this.vx = xProportion * oldVMagnitude;
				this.vy = yProportion * oldVMagnitude;
				
				_lerpTotalDistance += oldDistance;
			}
			
			_lerping = true;
		}
		
		// More useful lerping method.
		//  offsetType - How the camera's view should align with the 
		//               given point upon completion
		public function lerpToCameraRelativePosition(px:Number, py:Number, offsetType:EXTOffsetType = null):void
		{
			// Assume we normally want the camera to center on the specified point
			if (offsetType == null)
				offsetType = EXTOffsetType.CENTER;
			
			var startingPoint:Point = this.currentPosition(EXTOffsetType.TOP_LEFT, true);
			var destination:Point = new Point(startingPoint.x + px, startingPoint.y + py);
			var screenSize:Point = this.currentViewSize();
			var distance:Point = EXTUtility.DistanceBetweenTwoContainers(startingPoint,
																		 destination, 
															  			 screenSize,
															  			 screenSize, 
																		 EXTOffsetType.TOP_LEFT, 
																		 offsetType);
			this.lerpToPosition(startingPoint.x + distance.x, 
								startingPoint.y + distance.y);
		}
		
		// Update the camera's world offsets
		public function update():void
		{
			if (_lerping)
				this.updateLerping();
			
			vx += ax;
			vy += ay;
			x += vx;
			y += vy;
			
			zoomVelocity *= zoomAcceleration;
			zoom *= zoomVelocity;
		}
		
		// Apply the camera's world offsets to the world
		public function prepareWorldForRender(world:World):void
		{
			_lastFrameX = this.x;
			_lastFrameY = this.y;
			
			world.camera.x = (int)(this.x);
			world.camera.y = (int)(this.y);
			//TODO - fcole - zoom
		}
		
		
		// Private
		private var _lastFrameX:Number;
		private var _lastFrameY:Number;
		
		private static const _LERP_SPEED_:Number = 0.5;
		private var _lerping:Boolean;
		private var _lerpStartPosition:Point;
		private var _lerpDestination:Point;
		private var _lerpTotalDistance:Number;
		
		//TODO - fcole - Allow input of various lerping functions
		private function updateLerping():void
		{
			var diffX:Number = _lerpDestination.x - this.x;
			var diffY:Number = _lerpDestination.y - this.y;
			var distance:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
			var reachedDestination:Boolean = true;
			
			if (distance > 0.0)
			{
				reachedDestination = false;
				var xProportion:Number = diffX / distance;
				var yProportion:Number = diffY / distance;
				var vMagnitude:Number = Math.sqrt((vx * vx) + (vy * vy));
				
				if (distance <= _lerpTotalDistance / 2.0)
				{
					if (vMagnitude > _LERP_SPEED_)
					{
						this.vx -= xProportion * _LERP_SPEED_;
						this.vy -= yProportion * _LERP_SPEED_;
					}
				}
				else
				{
					this.vx += xProportion * _LERP_SPEED_;
					this.vy += yProportion * _LERP_SPEED_;
				}
			}
			
			if (!reachedDestination)
			{
				var newVMagnitude:Number = Math.sqrt((vx * vx) + (vy * vy));
				if (newVMagnitude >= distance)
					reachedDestination = true;
			}
			
			if (reachedDestination)
			{
				_lerping = false;
				this.x = _lerpDestination.x;
				this.y = _lerpDestination.y;
				this.vx = 0;
				this.vy = 0;
				this.ax = 0;
				this.ay = 0;
			}
		}
	}
}
