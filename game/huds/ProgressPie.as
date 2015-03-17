package maoz.bullets99.game.huds {
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import maoz.bullets99.game.Game;
	/**
	 * ...
	 * @author scars
	 */
	public class ProgressPie extends MovieClip{
		private var total:uint;
		private var _current:uint;
		private var _frame:uint;
		
		public function ProgressPie() {
			stop();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function clear():void {
			gotoAndStop(1);
			total = Game.numBullets;
			current = 0;
		}
		
		public function ate():void {
			current += 1;
			if (current == total) dispatchEvent(new Event('success', true));
		}
		
		public function get current():uint {
			return _current;
		}
		
		public function set current(value:uint):void {
			_current = value;
			tt.text = (total - value).toString();
			TweenLite.to(this, 0.2, { frame:int(totalFrames * value / total) + 1 } );
		}
		
		public function get frame():uint {
			return currentFrame;
		}
		
		public function set frame(value:uint):void {
			gotoAndStop(value);
		}
		
	}

}