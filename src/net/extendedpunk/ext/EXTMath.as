package net.extendedpunk.ext 
{
	/**
	 * ...
	 * @author Jams
	 */
	public class EXTMath 
	{
		public function EXTMath() 
		{
			
		}
		
		public static function sgn(obj:*):int
		{
			if (obj is int || obj is uint || obj is Number)
			{
				if (obj > 0)
					return 1;
				else if (obj < 0)
					return -1;
				else
					return 0;
			}
			else
				throw new Error("Error: Using sgn() with a non-number type");
		}
	}
}