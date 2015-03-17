package maoz.bullets99.game {
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import maoz.bullets99.Settings;
	import maoz.bullets99.SoundEffects;
	
	public class Ship extends MovieClip {
		static public var instance:Ship;
		static private var cursorsRegistered:Boolean;
		
		private var turnInt:int;
		private var bounds:Rectangle;
		private var _stat:uint = 1;
		private var _inBounds:Boolean;
		
		
		public function Ship() {
			instance = this;
			if (!cursorsRegistered) registerCursors();
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		static private function registerCursors():void {
			var p:Point = new Point(16, 16);
			var c:MouseCursorData;
			
			c = new MouseCursorData();
			c.data = Vector.<BitmapData>([new ship_black_0()]);
			c.hotSpot = p;
			Mouse.registerCursor('ship_black', c);
			
			c = new MouseCursorData();
			c.data = Vector.<BitmapData>([new ship_white_0()]);
			c.hotSpot = p;
			Mouse.registerCursor('ship_white', c);
			
			c = new MouseCursorData();
			c.data = Vector.<BitmapData>([new ship_black_1(), new ship_black_2(), new ship_white_2(), new ship_white_1()]);
			c.frameRate = 40;
			c.hotSpot = p;
			Mouse.registerCursor('ship_black_turn', c);
			
			c = new MouseCursorData();
			c.data = Vector.<BitmapData>([new ship_white_1(), new ship_white_2(), new ship_black_2(), new ship_black_1()]);
			c.frameRate = 40;
			c.hotSpot = p;
			Mouse.registerCursor('ship_white_turn', c);
			
			cursorsRegistered = true;
		}
		
		private function init(e:Event):void {
			bounds = Game.bounds.clone();
			bounds.inflate( -16, -16);
			
			stat = 1;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, turn);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mousemove);
			setCursor('ship_white');
			startDrag(true, bounds);
		}
		private function removed(e:Event = null):void {
			instance = null;
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, turn);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mousemove);
			setCursor();
			stopDrag();
			inBounds = false;
		}
		
		private function mousemove(e:MouseEvent):void {
			inBounds = bounds.contains(e.stageX, e.stageY);
		}
		
		
		private function turn(e:*= null):void {
			SoundEffects.play('turn');
			switch(stat) {
				case 0:
					setCursor('ship_black_turn');
					turnInt = setTimeout(setCursor, 100, 'ship_white');
					break;
				case 1:
					setCursor('ship_white_turn');
					turnInt = setTimeout(setCursor, 100, 'ship_black');
					break;
			}
			stat = 1 - stat;
		}
		
		public function freeze():void {
			SoundEffects.play(['die_1', 'die_2'][stat]);
			removed();
		}
		
		private function restart(e:MouseEvent):void {
			dispatchEvent(new Event('game_restart', true));
		}
		
		public function get inBounds():Boolean {
			return _inBounds;
		}
		
		public function set inBounds(value:Boolean):void {
			_inBounds = value;
			visible = !value;
			if (value) {
				switch(stat) {
					case 0:
						setCursor('ship_black');
						break;
					case 1:
						setCursor('ship_white');
						break;
				}
			}else {
				setCursor();
			}
		}
		
		private function setCursor(n:String = MouseCursor.AUTO):void {
			clearTimeout(turnInt);
			Mouse.cursor = n;
		}
		
		public function get stat():uint {
			return _stat;
		}
		
		public function set stat(value:uint):void {
			_stat = value;
			gotoAndStop(value+1);
		}
		
	}
	
}