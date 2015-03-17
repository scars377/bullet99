package maoz.bullets99.game.huds {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import maoz.bullets99.game.Game;
	import maoz.bullets99.SoundEffects;
	/**
	 * @author scars
	 * ...
	 */
	public class Chain extends MovieClip {
		private var _chains:uint = 0
		private var _state:int = 0;
		private var speedInt:int;
		private var _frame:uint;
		private var freezed:Boolean;
		
		public var balls:MovieClip;
		public var maxChain:uint = 0;
		
		public function Chain() {
			frame = 101;
		}
		
		public function clear():void {
			chains = 0;
			state = 0;
		}
		
		public function addChain(i:int):void {
			if (i == 0) i = -1;
			
			if (state * i < 0) {
				state = i;
				chainBreak();
			}else {
				state += i;
				if (state == -3 || state == 3) {
					SoundEffects.play('chain');
					
					_state = 0;
					chains += 1;
					frame = 101;
					if (maxChain < chains) maxChain = chains;
					
					if (freezed) return;
					
					//TweenLite.delayedCall(1, setState);
					TweenLite.killTweensOf(this);
				}else {
					frame = 1;
					TweenLite.to(this, Game.chainTime, { frame:101, onComplete:chainBreak, ease:Linear.easeNone } );
				}
				
			}
			
		}
		
		public function freeze():void {
			freezed = true;
			TweenLite.killTweensOf(this);
		}
		
		private function chainBreak():void {
			frame = 101;
			chains = 0;
			SoundEffects.play('chainBreak');
			TweenLite.killTweensOf(this);
		}
		
		private function setState():void {
			balls.gotoAndStop(state+4);
		}
		
		public function get chains():uint {
			return _chains;
		}
		
		public function set chains(value:uint):void {
			_chains = value;
			tt.text = value.toString();
			
			if(value>0){
				TweenLite.killTweensOf(tt, true);
				TweenLite.from(tt, 0.3, { scaleX:2, scaleY:2, x: -98, y: -63 } );
			}
		}
		
		public function get state():int {
			return _state;
		}
		
		public function set state(value:int):void {
			_state = value;
			setState();
		}
		
		public function get frame():uint {
			return currentFrame;
		}
		
		public function set frame(value:uint):void {
			gotoAndStop(value);
		}
		
	}

}