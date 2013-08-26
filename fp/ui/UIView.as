package fp.ui
{
	import flash.geom.Point;
	
	// UIView
	// Super class for all UI elements. UI should generally be structured as a tree
	//    of UIViews (and it's subclasses), with the subviews to be located within
	//    the parent views, and adopt the parents' transformations.
	// Created by Fletcher, 4/25/13
	public class UIView
	{
		// Standard positioning fields
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		
		// For specialized placement/pivoting
		// Generally (and by default) set to center of view
		public var pivotToParent:Point = null;
		public var pivotForChildren:Point = null;
		
		// Array of subviews
		// Public access through addSubview() and removeSubview()
		protected var _subviews:Vector.<UIView> = null;
		
		public function UIView(x:Number, y:Number, width, height) 
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function addSubview(subview:UIView):void
		{
			if (_subviews == null)
				_subviews = new Vector.<UIView>();
			
			_subviews.push(subview);
		}
		
		public function removeSubview(subview:UIView):void
		{
			if (_subviews != null)
				_subviews.splice(_subviews.indexOf(subview), 1);
		}
		
		public function update():void
		{
			//TODO - fcole - Update each child
		}
		
		public function render():void
		{
			//TODO - fcole - Render each child, in order
		}
	}
}
