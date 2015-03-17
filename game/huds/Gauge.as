package maoz.bullets99.game.huds {
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import maoz.bullets99.game.Game;
	import maoz.bullets99.Settings;
	import maoz.bullets99.SoundEffects;
	/**
	 * ...
	 * @author ...
	 */
	public class Gauge extends MovieClip {
		private var _numAte:int = 0;
		private var _numAteUpdater:Number = 0;
		
		public var t1:TextField;
		public var space:Sprite;
		
		public function Gauge() {
			numAte = 0;
		}
		
		public function ate():void {
			numAte+= 1;
		}
		
		public function clear():void {
			numAte = 0;
			space.visible = false;
		}
		
		public function freeze():void {
			TweenLite.killTweensOf(this);
		}
		
		public function get numAte():int {
			return _numAte;
		}
		
		public function set numAte(value:int):void {
			if (value >= Game.gaugeMax) {
				if (space.visible) return;
				_numAte = Game.gaugeMax;
				
				SoundEffects.play('musouReady');
				SoundEffects.loop('bgMusou');
				TweenLite.to(this, 0.2, { numAteUpdater:_numAte } );
				space.visible = true;
				
			}else {
				_numAte = value;
				TweenLite.to(this, 0.2, { numAteUpdater:_numAte } );
			}
			
			_numAte = Math.min(value, Game.gaugeMax);
		}
		
		public function get numAteUpdater():Number {
			return _numAteUpdater;
		}
		
		public function set numAteUpdater(value:Number):void {
			_numAteUpdater = value;
			
			var p:Number = value / Game.gaugeMax;
			gotoAndStop(201 - int(200 * p));
			
			t1.text = (p * 100).toFixed(0);
		}
		
		public function get full():Boolean {
			return numAte == Game.gaugeMax;
		}
		
		
	}

}