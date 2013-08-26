package fp.ext
{
	import net.flashpunk.World;
	
	public class EXTWorld extends World
	{
		public var worldCamera:EXTCamera;
		
		public function EXTWorld()
		{
			super();
			this.worldCamera = new EXTCamera();
		}
		
		override public function update():void
		{
			worldCamera.update();
			super.update();
			worldCamera.prepareWorldForRender(this);
		}
	}
}
