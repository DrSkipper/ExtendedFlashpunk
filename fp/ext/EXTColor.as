package fp.ext 
{
	/**
	 * EXTColor
	 * Class which wraps color value handling in a simple interface
	 *    and provides convenience functions.
	 * Created by Fletcher, 10/6/13
	 */
	public class EXTColor extends Object
	{
		// Hex RGB value, i.e. 0xFF0000 is full red
		public var webColor:uint;
		
		// Alpha value, 0 to 1
		public var alpha:Number;
		
		// Specific RGB values, 0 to 1
		public function get red():Number { return (webColor & 0xFF0000) / 255; }
		public function set red(value:Number):void { this.setColor(value, this.green, this.blue, this.alpha); }
		
		public function get green():Number { return (webColor & 0x00FF00) / 255; }
		public function set green(value:Number):void { this.setColor(this.red, value, this.blue, this.alpha); }
		
		public function get blue():Number { return (webColor & 0x0000FF) / 255; }
		public function set blue(value:Number):void { this.setColor(this.red, this.green, value, this.alpha); }
		
		// Set all color values, 0 to 1
		public function setColor(r:Number, g:Number, b:Number, a:Number):void
		{
			var newColor:uint = 0x000000;
			newColor += r * 255;
			newColor << 8;
			newColor += g * 255;
			newColor << 8;
			newColor += b * 255;
			webColor = newColor;
			alpha = a;
		}
	}
}
