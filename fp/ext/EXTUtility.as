package fp.ext
{
	import flash.geom.Point;
	import flash.utils.describeType;
	
	// Utility Class with various convenience functions, mostly relating to offsets.
	// Created by Fletcher, 8/25/13
	public class EXTUtility
	{
		static public const ZERO_POINT:Point = new Point(0, 0);
		
		// Helper function for assisting automation of fake AS3 Enums
		// Credit: http://scottbilas.com/blog/faking-enums-in-as3/
		public static function InitEnumConstants(inType :*) :void
		{
			var type :XML = describeType(inType);
			for each (var constant :XML in type.constant)
			{
				inType[constant.@name].Text = constant.@name;
			}
		}
		
		// Find the distance between two rectangular containers on the screen.
		// p1 and p2 - Points in the first and second containers, respectively
		// containerSize1 & 2 - The sizes of the two containers
		// offsetType1 & 2 - Where the given points are located in the containers
		public static function DistanceBetweenTwoContainers(p1:Point, 
															p2:Point, 
															containerSize1:Point, 
															containerSize2:Point, 
															offsetType1:EXTOffsetType = null, 
															offsetType2:EXTOffsetType = null):Point
		{
			if (offsetType1 == null)
				offsetType1 = EXTOffsetType.TOP_LEFT;
			if (offsetType2 == null)
				offsetType2 = EXTOffsetType.TOP_LEFT;
			
			var p1Normalized:Point = UpperLeftifyCoordinate(p1, containerSize1, offsetType1);
			var p2Normalized:Point = UpperLeftifyCoordinate(p2, containerSize2, offsetType2);
			
			return new Point(p2Normalized.x - p1Normalized.x, p2Normalized.y - p1Normalized.y);
		}
		
		// Helper function mostly meant to be used internally here,
		//  DistanceBetweenTwoContainers() should be the more commonly needed method.
		public static function UpperLeftifyCoordinate(p:Point, containerSize:Point, offsetType:EXTOffsetType):Point
		{
			var pNormalized:Point = new Point(p.x, p.y);
			
			if (offsetType == EXTOffsetType.CENTER)
			{
				pNormalized.x = p.x - containerSize.x / 2;
				pNormalized.y = p.y - containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.TOP_CENTER)
			{
				pNormalized.x = p.x - containerSize.x / 2;
				pNormalized.y = p.y;
			}
			else if (offsetType == EXTOffsetType.BOTTOM_CENTER)
			{
				pNormalized.x = p.x - containerSize.x / 2;
				pNormalized.y = p.y - containerSize.y;
			}
			else if (offsetType == EXTOffsetType.LEFT_CENTER)
			{
				pNormalized.x = p.x;
				pNormalized.y = p.y - containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.RIGHT_CENTER)
			{
				pNormalized.x = p.x - containerSize.x;
				pNormalized.y = p.y - containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.BOTTOM_RIGHT)
			{
				pNormalized.x = p.x - containerSize.x;
				pNormalized.y = p.y - containerSize.y;
			}
			else if (offsetType == EXTOffsetType.TOP_RIGHT)
			{
				pNormalized.x = p.x - containerSize.x;
				pNormalized.y = p.y;
			}
			else if (offsetType == EXTOffsetType.BOTTOM_LEFT)
			{
				pNormalized.x = p.x;
				pNormalized.y = p.y - containerSize.y;
			}
			// TOP_LEFT case covered by default value
			
			return pNormalized;
		}
		
		// Given the absolute point (i.e. on the screen) of a container, and a point with 
		//   relative coordinates within that container, find the absolute position of the
		//   point within the container.
		public static function AbsolutePositionOfPointInContainer(absoluteUpperLeftPositionOfContainer:Point, 
																  containerSize:Point, 
																  pointOffsetInContainer:Point, 
																  offsetType:EXTOffsetType)
																  :Point
		{
			var absolutePoint:Point = new Point(absoluteUpperLeftPositionOfContainer.x, absoluteUpperLeftPositionOfContainer.y);
			var returnValue:Point = new Point(pointOffsetInContainer.x, pointOffsetInContainer.y);
			
			if (offsetType == EXTOffsetType.TOP_LEFT)
			{
				// no x change
				// no y change
			}
			else if (offsetType == EXTOffsetType.CENTER)
			{
				absolutePoint.x += containerSize.x / 2;
				absolutePoint.y += containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.TOP_CENTER)
			{
				absolutePoint.x += containerSize.x / 2;
				// no y change
			}
			else if (offsetType == EXTOffsetType.BOTTOM_CENTER)
			{
				absolutePoint.x += containerSize.x / 2;
				absolutePoint.y += containerSize.y;
			}
			else if (offsetType == EXTOffsetType.LEFT_CENTER)
			{
				// no x change
				absolutePoint.y += containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.RIGHT_CENTER)
			{
				absolutePoint.x += containerSize.x;
				absolutePoint.y += containerSize.y / 2;
			}
			else if (offsetType == EXTOffsetType.BOTTOM_RIGHT)
			{
				absolutePoint.x += containerSize.x;
				absolutePoint.y += containerSize.y;
			}
			else if (offsetType == EXTOffsetType.TOP_RIGHT)
			{
				absolutePoint.x += containerSize.x;
				// no y change
			}
			else if (offsetType == EXTOffsetType.BOTTOM_LEFT)
			{
				// no x change
				absolutePoint.y += containerSize.y;
			}
			else
			{
				EXTConsole.warn("EXTUtility", "AbsolutePositionOfPointInContainer", 
								"Unknown OffsetType %s", offsetType);
			}
			
			returnValue.x += absolutePoint.x;
			returnValue.y += absolutePoint.y;
			return returnValue;
		}
	}
}