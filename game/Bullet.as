package maoz.bullets99.game {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import maoz.bullets99.Settings;
	
	public class Bullet extends Shape { 
		static private var velocities:Array;
		static private var sizes:Array;
		static private var bounds:Array;
		static private var genBounds:Array;
		
		public var type:int;
		
		private var inBounds:Boolean = false;
		
		private var _phi:Number;
		private var _vel:Number;
		private var _ex:Number;
		private var _ey:Number;
		
		private var vi:Number;
		private var vj:Number;
		private var b:Rectangle;
		private var hit:Boolean;
		private var radius:Number;
		
		
		public function Bullet(type:int) {
			this.type = type;
			
			if (type == 0) {
				drawCircle(0x000000, 0x770000)
			}else {
				drawCircle(0xFFFFFF, 0xAAAAFF)
			}
			
			b = bounds[type];
			addEventListener(Event.ADDED_TO_STAGE, init);
			cacheAsBitmap = true;
		}
		
		private function init(e:Event) {
			var g:Rectangle = genBounds[type];
			var p:int = int(Math.random() * (g.width + g.height));
			var q:int = int(Math.random() * 2);
			
			if (p < g.width) {
				ex = p;
				ey = q * g.height;
			}else {
				ex = q * g.width;
				ey = p - g.width;
			}
			ex += g.x;
			ey += g.y;
			
			var dx:Number;
			var dy:Number;
			if (Ship.instance) {
				if(Ship.instance.inBounds){
					dx = parent.mouseX - ex;
					dy = parent.mouseX - ey;
				}else {
					dx = Ship.instance.x - ex;
					dy = Ship.instance.y - ey;
				}
			}else {
				dx = (g.left + g.right) / 2 +((Math.random() - 0.5) * 100) - ex;
				dy = (g.top + g.bottom) / 2 +((Math.random() - 0.5) * 100) - ey;
			}
			phi = Math.atan2(dy, dx);
			vel = velocities[type];
		}
		
		private function drawCircle(fill:uint, line:uint):void {
			radius = sizes[type] * 0.5;
			graphics.beginFill(fill);
			graphics.lineStyle(1, line);
			graphics.drawCircle(radius, radius, radius);
		}
		
		
		public function update(r:Rectangle):int {
			ex += vi * Game.speedRate;
			ey += vj * Game.speedRate;
			
			if (!inBounds) {
				inBounds = b.contains(ex, ey);
				
			}else {
				if (ex < b.left || ex > b.right) phi = (phi < 0? -1:1) * Math.PI - phi;
				if (ey < b.top || ey > b.bottom) phi = -phi;
				
				if (r.contains(x + radius, y + radius)) {
					if (type != Ship.instance.stat) {
						return 1;
					}else {
						dispatchEvent(new Event('ate', true));
						return -1;
					}
				}
			}
			return 0;
		}
		
		
		static public function init():void {
			var v0:Number = Number(Settings.getValue('bulletVelocityBlack'));
			var v1:Number = Number(Settings.getValue('bulletVelocityWhite'));
			velocities = [v0, v1];
			
			var s0:uint = uint(Settings.getValue('bulletSizeBlack'));
			var s1:uint = uint(Settings.getValue('bulletSizeWhite'));
			sizes = [s0, s1];
			
			var r0:Rectangle = Game.bounds.clone();
			r0.right -= s0;
			r0.bottom -= s0;
			var r1:Rectangle = Game.bounds.clone();
			r1.right -= s1;
			r1.bottom -= s1;
			bounds = [r0, r1];
			
			var g0:Rectangle = r0.clone();
			g0.inflate(30, 30);
			var g1:Rectangle = r1.clone();
			g1.inflate(30, 30);
			genBounds = [g0, g1];
		}
		
		public function get ex():Number {
			return _ex;
		}
		
		public function set ex(value:Number):void {
			_ex = value;
			x = (value);
		}
		
		public function get ey():Number {
			return _ey;
		}
		
		public function set ey(value:Number):void {
			_ey = value;
			y = (value);
		}
		
		public function get phi():Number {
			return _phi;
		}
		
		public function set phi(value:Number):void {
			_phi = value;
			setVij();
		}
		
		public function get vel():Number {
			return _vel;
		}
		
		public function set vel(value:Number):void {
			_vel = value;
			setVij();
		}
		
		private function setVij():void {
			vi = Math.cos(phi) * vel;
			vj = Math.sin(phi) * vel;
		}
		
		
		
	}
	
}