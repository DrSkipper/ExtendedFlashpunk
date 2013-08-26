package fp.ui
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;

	//TODO - fcole - THIS CLASS IS NO WHERE NEAR COMPLETE
//	http://active.tutsplus.com/tutorials/games/an-introduction-to-flashpunk-the-basics/
	public class UIButton extends Entity
	{
		protected var _map:Spritemap;
		protected var _over:Boolean;
		protected var _clicked:Boolean;
		protected var _callback:Function;
		protected var _argument:*;
		protected var _label:Text = null;
		
		public function UIButton(callback:Function, argument:*, x:Number = 0, y:Number = 0)
		{
			super(x, y);
			this.centerOrigin();
			
			_callback = callback;
			_argument = argument;
		}
		
		
		public function setSpritemap(asset:*, frameW:uint, frameH:uint, text:String = null):void
		{
			this._map = new Spritemap(asset, frameW, frameH);
			
			this._map.add("Up",   [2]);
			this._map.add("Over", [1]);
			this._map.add("Down", [0]);
			
//			graphic = _map;
			this._map.centerOO();
			this.addGraphic(_map);
			this.setHitbox(frameW, frameH);
			this.layer = -2;
			
			if (text != null)
			{
				this._label = new Text(text, 0, 0);
				this._label.centerOO();
				this.addGraphic(this._label);
			}
		}
		
		override public function update():void
		{
			if (!world)
			{
				return;
			}
			
			if (this._label != null)
				this._label.update();
			
			_over = false;
			_clicked = false;
			
			if (collidePoint(x - world.camera.x, y - world.camera.y, Input.mouseX, Input.mouseY))
			{
				if (Input.mouseReleased)
				{
					clicked();
				}
				else if (Input.mouseDown)
				{
					mouseDown();
				}
				else
				{
					mouseOver();
				}
			}
		}
		
		protected function clicked():void
		{
			if (!_argument)
			{
				_callback();
			}
			else
			{
				_callback(_argument);
			}
		}
		
		protected function mouseOver():void
		{
			_over = true;
		}
		
		protected function mouseDown():void
		{
			_clicked = true;
		}
		
		override public function render():void
		{
			if (_clicked)
			{
				_map.play("Down");
			}
			else if (_over)
			{
				_map.play("Over");
			}
			else
			{
				_map.play("Up");
			}
			
			super.render();
		}
		
	}
	
}
