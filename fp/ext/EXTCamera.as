package fp.ext
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import fp.ext.EXTConsole;
	import fp.ext.EXTOffsetType;
	import fp.ext.EXTUtility;

	/**
	 * Extended Camera
	 * Handles transformations to be made to the world before rendering
	 * Created by Fletcher, 6/2/13
	 */
	public class EXTCamera
	{
		/**
		 * Public Variables
		 * x and y represent pixel coordinates in the world when zoom is at 1.0
		 */
		public var x:Number = 0;      // Position (upper-left)
		public var y:Number = 0;
		public var vx:Number = 0;     // Velocity
		public var vy:Number = 0;
		public var ax:Number = 0;  	  // Acceleration
		public var ay:Number = 0;
		public var zoom:Number = 1.0; // Zoom
		public var zoomVelocity:Number = 0;
		public var zoomAcceleration:Number = 0;
		
		/**
		 * Constructor
		 */
		public function EXTCamera()
		{
			_lastFrameX = _lastFrameY = 0.0;
			_lerping = false;
			_lerpStartPosition = new Point();
			_lerpDestination = new Point();
			_lerpTotalDistance = 0.0;
		}
		
		/**
		 * @return	The current size of the view, given the camera's 
		 *    current zoom value and the size of the screen.
		 */
		public function currentViewSize():Point
		{
			return new Point(FP.screen.width / this.zoom, FP.screen.height / this.zoom);
		}
		
		/**
		 * Get the current position of the camera
		 * @param	offsetType				Specifies which alignment of the camera to use
		 * @param	useLastFramePosition	Whether to use coordinates from the end of the last tick
		 */
		public function currentPosition(offsetType:EXTOffsetType, useLastFramePosition:Boolean = false):Point
		{
			var screenSize:Point = this.currentViewSize();
			var baseX:Number = (useLastFramePosition ? _lastFrameX : this.x);
			var baseY:Number = (useLastFramePosition ? _lastFrameY : this.y);
			
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
		
		/**
		 * Set the position of the camera
		 * @param	offsetType	How the camera's view frame should align with the given position
		 * @param	newPoint	The coordinates to align the camera with
		 */
		public function setCurrentPosition(offsetType:EXTOffsetType, newPosition:Point):void
		{
			var screenSize:Point = this.currentViewSize();
			newPosition = EXTUtility.UpperLeftifyCoordinate(newPosition, screenSize, offsetType);
			this.x = newPosition.x;
			this.y = newPosition.y;
		}
		
		/**
		 * Move the camera a given amount
		 * @param	dx	Offset to move camera by along x-axis
		 * @param	dy	Offste to move camera by along y-axis
		 */
		public function moveDistance(dx:Number, dy:Number):void
		{
			x += dx;
			y += dy;
		}
		
		/**
		 * Change the camera's velocity
		 * @param	dvx	Offset to apply to x velocity
		 * @param	dvy	Offset to apply to y velocity
		 */
		public function alterVelocity(dvx:Number, dvy:Number):void
		{
			vx += dvx;
			vy += dvy;
		}
		
		/**
		 * Change the camera's acceleration
		 * @param	fx	Force to apply to camera along x-axis, in pixels per second per second
		 * @param	fy	Force to apply to camera along y-axis, in pixels per second per second
		 */
		public function applyForce(fx:Number, fy:Number):void
		{
			ax += fx;
			ay += fy;
		}
		
		/**
		 * Modify the zoom level of the camera while anchoring at a specific location.
		 *    (Editing the zoom attribute directly will zoom from the upper-left corner).
		 * @param	zoomDelta				The amount to change the zoom by
		 * @param	anchorPoint				The point to anchor the zoom at
		 * @param	measureFromOffsetType	Where the anchor point is measured from, within the camera's view
		 */
		public function zoomWithAnchor(zoomDelta:Number, anchorPoint:Point, measureFromOffsetType:EXTOffsetType):void
		{
			var currentSize:Point = this.currentViewSize();
			var fromUpperLeft:Point = EXTUtility.UpperLeftifyCoordinate(anchorPoint, currentSize, measureFromOffsetType);
			var xProportion:Number = fromUpperLeft.x / currentSize.x;
			var yProportion:Number = fromUpperLeft.y / currentSize.y;
			
			zoom += zoomDelta;
			
			var newSize:Point = this.currentViewSize();
			var newXWithProportion:Number = xProportion * newSize.x;
			var newYWithProportion:Number = yProportion * newSize.y;
			
			var xDiff:Number = newXWithProportion - fromUpperLeft.x;
			var yDiff:Number = newYWithProportion - fromUpperLeft.y;
			
			this.moveDistance(xDiff, yDiff);
			_lerpDestination.x += xDiff;
			_lerpDestination.y += yDiff;
		}
		
		/**
		 * Camera will smoothly animate to given position.
		 * @param	px	Target upper-left x position for camera
		 * @param	py	Target upper-left y position for camera
		 */
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
			
			var diffX:Number = px - _lerpStartPosition.x;
			var diffY:Number = py - _lerpStartPosition.y;
			_lerpTotalDistance = Math.sqrt((diffX * diffX) + (diffY * diffY));
			
			if (_lerping)
			{
				var oldVMagnitude:Number = Math.sqrt((vx * vx) + (vy * vy));
				var xProportion:Number = diffX / _lerpTotalDistance;
				var yProportion:Number = diffY / _lerpTotalDistance;
				
				diffX = _lerpStartPosition.x - oldStartPosition.x;
				diffY = _lerpStartPosition.y - oldStartPosition.y;
				var oldDistance:Number = Math.sqrt((diffX * diffX) + (diffY * diffY));
				
				this.vx = xProportion * oldVMagnitude;
				this.vy = yProportion * oldVMagnitude;
				
				_lerpTotalDistance += oldDistance;
			}
			
			_lerping = true;
		}
		
		/**
		 * More useful lerping method.
		 * @param	px			X location, in screen coordinates, which camera should lerp to
		 * @param	py			Y location, in screen coordinates, which camera should lerp to
		 * @param	offsetType	How the camera should align with the given location (defaults to CENTER)
		 */
		public function lerpToCameraRelativePosition(px:Number, py:Number, offsetType:EXTOffsetType = null):void
		{
			// Assume we normally want the camera to center on the specified point
			if (offsetType == null)
				offsetType = EXTOffsetType.CENTER;
			
			px /= this.zoom;
			py /= this.zoom;
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
		
		/**
		 * Update the camera's world offsets
		 */
		public function update():void
		{
			if (_lerping)
				this.updateLerping();
			
			vx += ax;
			vy += ay;
			x += vx;
			y += vy;
			
			zoomVelocity += zoomAcceleration;
			zoom += zoomVelocity;
			
			_lastFrameX = this.x;
			_lastFrameY = this.y;
		}
		
		
		/**
		 * Private
		 */
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
