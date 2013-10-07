package fp.ui
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.FP;
	import fp.ext.EXTOffsetType;
	import fp.ext.EXTUtility;
	import fp.ext.EXTColor
	
	/**
	 * UIView
	 * Super class for all UI elements. UI should generally be structured as a tree
	 *    of UIViews (and it's subclasses), with the subviews to be located within
	 *    the parent views, and adopting the parents' transformations.
	 * Created by Fletcher, 4/25/13
	 */
	public class UIView
	{
		// Standard positioning fields
		public var position:Point;
		public var size:Point;
		
		// Offsets to measure positions from.
		// Defaults to centering this view in the center of it's parent's view.
		public var offsetAlignmentInParent:EXTOffsetType = EXTOffsetType.CENTER;
		public var offsetAlignmentForSelf:EXTOffsetType = EXTOffsetType.CENTER;
		
		// Set the background of the View to a constant color.
		// Useful for debugging, or for drawing colored quads in UI.
		public function get backgroundColor():EXTColor
		{ 
			if (_backgroundColor == null)
				_backgroundColor = new EXTColor();
			return _backgroundColor;
		}
		
		/**
		 * Constructor. Set up initial transforms.
		 * @param	position	The initial position of the View, relative to its parent
		 * @param	size		The initial size of the View
		 */
		public function UIView(position:Point, size:Point) 
		{
			this.position = new Point(position.x, position.y);
			this.size = new Point(size.x, size.y);
		}
		
		/**
		 * Add a subview, which inherits the transforms of this view, as a subview.
		 * @param	subview	The View to add as a subview
		 */
		public function addSubview(subview:UIView):void
		{
			if (_subviews == null)
				_subviews = new Vector.<UIView>();
			
			_subviews.push(subview);
		}
		
		/**
		 * Remove a View from this View's list of subviews.
		 * @param	subview	The View to remove from this View's subviews.
		 * @return			The View which was removed, or null if it wasn't found.
		 */
		public function removeSubview(subview:UIView):UIView
		{
			var removedView:UIView = null;
			
			if (_subviews != null)
			{
				var removed:Vector.<UIView>  = _subviews.splice(_subviews.indexOf(subview), 1);
				if (removed != null && removed.length > 0)
					removedView = removed.pop();
			}
			
			return removedView;
		}
		
		/**
		 * Update the View. Override this function in order to perform 
		 *    view-specific computations, but remember to call super.update()
		 *    or the subviews will not be updated.
		 */
		public function update():void
		{
			for each (var view:UIView in _subviews)
				view.update();
		}
		
		/**
		 * Render the View. This function should NOT need to be overridden in normal cases.
		 * @param	parentAbsolutePosition	The true upper left screen coordinate of the parent view.
		 * @param	parentSize				The true drawing size of the parent.
		 * @param	scale					How much to scale the view by - Used to account for zoom in camera-relative UI.
		 */
		public function render(parentAbsolutePosition:Point, parentSize:Point, scale:Number):void
		{
			var myOffset:Point = new Point(this.position.x, this.position.y);
			var mySize:Point = new Point(this.size.x, this.size.y);
			
			if (scale != 1.0)
			{
				myOffset.x *= scale;
				myOffset.y *= scale;
				mySize.x *= scale;
				mySize.y *= scale;
			}
			
			var myRelativeUpperLeft:Point = EXTUtility.UpperLeftifyCoordinate(myOffset, mySize, this.offsetAlignmentForSelf);
			var myAbsoluteUpperLeft:Point = EXTUtility.AbsolutePositionOfPointInContainer(parentAbsolutePosition, parentSize, myRelativeUpperLeft, this.offsetAlignmentInParent);
			
			// Logic to render content of this view occurs now
			this.renderContent(myAbsoluteUpperLeft, mySize, scale);
			
			// Now we draw our subviews
			for each (var view:UIView in _subviews)
				view.render(myAbsoluteUpperLeft, mySize, scale);
		}
		
		
		// Protected
		
		// Array of subviews
		// Public access through addSubview() and removeSubview()
		protected var _subviews:Vector.<UIView> = null;
		
		// Handling of background color
		protected var _backgroundColor:EXTColor = null;
		protected var _backgroundColorCanvas:Canvas = null;
		protected var _backgroundColorRectangle:Rectangle = null;
		
		/**
		 * Logic to render any content specific to a given UIView subclass. Even still,
		 *    should usually only be overridden by UIImageView and UILabelView.
		 * @param	absoluteUpperLeft	Screen coordinate to place content at.
		 * @param	absoluteSize		Bounds to render content within.
		 * @param	scale				Zoom level, for scaling images to match.
		 */
		protected function renderContent(absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			if (_backgroundColor != null)
			{
				if (_backgroundColorCanvas == null)
				{
					_backgroundColorCanvas = new Canvas(FP.screen.width, FP.screen.height);
					_backgroundColorRectangle = new Rectangle();
				}
				
				_backgroundColorRectangle.width = absoluteSize.x;
				_backgroundColorRectangle.height = absoluteSize.y;;
				_backgroundColorCanvas.fill(_backgroundColorRectangle, _backgroundColor.webColor, _backgroundColor.alpha);
				_backgroundColorCanvas.render(FP.buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
			}
			
			// Overridden in UIImageView and UILabelView
		}
	}
}
