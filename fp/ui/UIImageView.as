package fp.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import fp.ext.EXTUtility;
	import fp.ext.EXTConsole;
	
	/**
	 * UIImageView
	 * A subclass of UIView which renders an image within its bounds.
	 * Created by Fletcher, 9/7/13
	 */
	public class UIImageView extends UIView 
	{
		public var image:Image;
		public var customBuffer:BitmapData = null;
		
		public function UIImageView(position:Point, image:Image) 
		{
			var size:Point = image != null ? new Point(image.scaledWidth, image.scaledHeight) : EXTUtility.ZERO_POINT;
			super(position, size);
			
			this.image = image;
		}
		
		override protected function renderContent(absoluteUpperLeft:Point, absoluteSize:Point, scale:Number):void
		{
			super.renderContent(absoluteUpperLeft, absoluteSize, scale);
			
			var oldScale:Number = image.scale;
			image.scale *= scale;
			image.render(customBuffer != null ? customBuffer : FP.buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
			image.scale = oldScale;
		}
	}
}
