package maoz.bullets99.game.huds {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import maoz.bullets99.game.Game;
	import maoz.bullets99.SoundEffects;
	/**
	 * ...
	 * @author scars
	 */
	public class HUD extends Sprite {
		private var slowInt:int;
		public var score:Score;
		public var gauge:Gauge;
		public var chain:Chain;
		public var numAte:uint = 0;
		
		public function HUD() {
			mouseEnabled = mouseChildren = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		public function freeze():void {
			SoundEffects.stop('musou');
			chain.freeze();
			gauge.freeze();
			removed();
		}
		
		public function getMaxChain():uint {
			return chain.maxChain;
		}
		
		public function getScore():uint {
			return score.score;
		}
		
		private function removed(e:Event = null):void {
			clearTimeout(slowInt);
			parent.removeEventListener('ate', addAte);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keydown);
		}
		
		private function init(e:Event):void {
			parent.addEventListener('ate', addAte);
			clear();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
		}
		
		private function keydown(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.SPACE:
					slowEffect();
					break;
			}
		}
		
		private function slowEffect():void {
			if (!gauge.full) return;
			gauge.clear();
			
			SoundEffects.play('musou');
			SoundEffects.stopLoop();
			
			Game.speedRate = Game.slowEffectRate;
			clearTimeout(slowInt);
			slowInt = setTimeout(slowEffectComplete, Game.slowEffectTime * 1000);
		}
		
		private function slowEffectComplete():void {
			Game.speedRate = 1;
			SoundEffects.loop('bg');
		}
		
		private function addAte(e:Event):void {
			numAte+= 1;
			Game.bulletNumber += 1;
			
			gauge.ate();
			chain.addChain(e.target.type);
			score.addScore(100 * (chain.chains + 1));
		}
		
		private function clear():void {
			clearTimeout(slowInt);
			score.clear();
			chain.clear();
			gauge.clear();
		}
		
	}

}