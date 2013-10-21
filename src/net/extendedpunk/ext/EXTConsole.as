package fp.ext
{
CONFIG::debug
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
}
	
	/**
	 * ExtendedConsole
	 * Static class which handles different types of logging, 
	 *   and displaying of debug console
	 * Created by Fletcher, 4/23/13
	 */
	public class EXTConsole
	{
CONFIG::debug
{
		public static const CONSOLE_KEY:int = EXTKey.BACKSLASH;
}
		/**
		 * Logging function for when a serious error occurs, often to be logged on 
		 *   a release build when a debug build should crash.  Also forces console
		 *   to display if on a debug build.
		 * @param	filename		Filename of location of log statement
		 * @param	functionName	Function name of location of log statement
		 * @param	...data			Formatted string to log
		 */
		public static function error(filename:String, functionName:String, ...data):void
		{
			var errorStringPrefix:String = "ERROR: " + "[" + filename + "." + functionName + "]";
			CONFIG::debug
				{
					FP.console.visible = true;
					FP.console.log(errorStringPrefix, data);
				}
			trace(errorStringPrefix, data);
		}
		
		/**
		 * Logging function to be used when there might be something wrong,
		 *   should be used sparingly as it will be traced on both debug 
		 *   and release builds
		 * @param	filename		Filename of location of log statement
		 * @param	functionName	Function name of location of log statement
		 * @param	...data			Formatted string to log
		 */
		public static function warn(filename:String, functionName:String, ...data):void
		{
			var infoStringPrefix:String = "WARN: " + "[" + filename + "." + functionName + "]";
			CONFIG::debug
				{
					FP.console.log(infoStringPrefix, data);
				}
			trace(infoStringPrefix, data);
		}
		
		/**
		 * Logging function which provides information, should be used sparingly as 
		 *   it will be traced on both debug and release builds
		 * @param	filename		Filename of location of log statement
		 * @param	functionName	Function name of location of log statement
		 * @param	...data			Formatted string to log
		 */
		public static function info(filename:String, functionName:String, ...data):void
		{
			var infoStringPrefix:String = "INFO: " + "[" + filename + "." + functionName + "]";
			CONFIG::debug
				{
					FP.console.log(infoStringPrefix, data);
				}
			trace(infoStringPrefix, data);
		}
		
		/**
		 * Logging function which can be used anywhere we wish to provide additional
		 *   info which will help debug during development; won't be traced on release.
		 * @param	filename		Filename of location of log statement
		 * @param	functionName	Function name of location of log statement
		 * @param	...data			Formatted string to log
		 */
		public static function debug(filename:String, functionName:String, ...data):void
		{
			CONFIG::debug
				{
					var debugStringPrefix:String = "DEBUG: " + "[" + filename + "." + functionName + "]";
					FP.console.log(debugStringPrefix, data);
					trace(debugStringPrefix, data);
				}
		}
		
		/**
		 * Call at start of program to initialize the console
		 */
		public static function initializeConsole():void
		{
			CONFIG::debug
				{
					FP.console.enable();
					EXTConsole.debug("EXTConsole", "initializeConsole()", "EXTConsole Initialized");
				}
		}
		
CONFIG::debug
{
		/**
		 * Call in your update loop on debug builds to allow toggling of console visualizer
		 */
		public static function update():void
		{
			if (Input.pressed(CONSOLE_KEY))
			{
				FP.console.visible = !FP.console.visible;
			}
		}
}
	}
}
