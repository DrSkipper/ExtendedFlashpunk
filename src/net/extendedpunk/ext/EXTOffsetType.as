package net.extendedpunk.ext
{
	import net.extendedpunk.ext.EXTUtility;
	
	// An "Enumeration" which specifies where offsets 
	//   should be measured from.
	// Created by Fletcher, 8/25/13
	public class EXTOffsetType
	{
		public static const CENTER 			:EXTOffsetType = new EXTOffsetType();
		public static const TOP_LEFT 		:EXTOffsetType = new EXTOffsetType();
		public static const TOP_RIGHT 		:EXTOffsetType = new EXTOffsetType();
		public static const BOTTOM_LEFT 	:EXTOffsetType = new EXTOffsetType();
		public static const BOTTOM_RIGHT 	:EXTOffsetType = new EXTOffsetType();
		
		public static const TOP_CENTER 		:EXTOffsetType = new EXTOffsetType();
		public static const BOTTOM_CENTER 	:EXTOffsetType = new EXTOffsetType();
		public static const LEFT_CENTER 	:EXTOffsetType = new EXTOffsetType();
		public static const RIGHT_CENTER 	:EXTOffsetType = new EXTOffsetType();
		
		// Automated Enumeration stuff
		// Credit: http://scottbilas.com/blog/faking-enums-in-as3/
		public var Text :String;
		{EXTUtility.InitEnumConstants(EXTOffsetType);} // static ctor
	}
}
