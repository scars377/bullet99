package maoz.bullets99.game {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author scars
	 */
	public class Canvas extends Sprite {
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		
		private var back:Sprite;
		public var bg:Sprite;
		
		public function Canvas() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		public function freeze():void {
			removed();
		}
		
		private function removed(e:Event = null):void {
			removeEventListener(Event.ENTER_FRAME, move);
		}
		
		private function init(e:Event):void {
			var r:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			x = (r.left + r.right) / 2;
			y = (r.top + r.bottom) / 2;
			
			back = new Sprite();
			addChild(back);
			drawDots(back, 0, 0, r.width, r.height);
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function drawDots(b:Sprite, px:Number, py:Number, w:Number, h:Number):void {
			px -= w / 2;
			py -= h / 2;
			w *= 2;
			h *= 2;
			var s:Shape;
			for (var i:int = 0; i < 50; i++) {
				s = new Shape();
				s.graphics.beginFill(0x999999, 1);
				s.graphics.drawRect(0, 0, 2, 2);
				s.x = px + (i / 99) * w;
				s.y = py + Math.random() * h;
				s.z = Math.random() * 3000;
				b.addChild(s);
			}
			
		}
		
		private function move(e:Event):void {
			posX += (mouseX * 0.4 - posX) * 0.005;
			posY += (mouseY * 0.4 - posY) * 0.005;
		}
		
		
		public function get posX():Number {
			return _posX;
		}
		
		public function set posX(value:Number):void {
			_posX = value;
			back.x = -value;
		}
		
		public function get posY():Number {
			return _posY;
		}
		
		public function set posY(value:Number):void {
			_posY = value;
			back.y = -value;
		}
		
	}

}