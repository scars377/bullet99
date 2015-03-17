package maoz.bullets99.game.huds {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import maoz.bullets99.game.Ship;
	/**
	 * ...
	 * @author scars
	 */
	public class Score extends Sprite {
		private var _score:uint = 0;
		private var _scoreUpdater:uint = 0;
		
		public var t:TextField;
		
		public function Score() {
			var tf:TextFormat = new TextFormat();
			tf.letterSpacing = 5;
			t.defaultTextFormat = tf;
		}
		
		public function addScore(n:uint) {
			score+= n;
			addChild(new ScoreFloat(n));
			
		}
		
		public function clear():void {
			score = scoreUpdater = 0;
		}
		
		public function get score():uint {
			return _score;
		}
		
		public function set score(value:uint):void {
			_score = value;
			TweenLite.to(this, 0.2, { scoreUpdater:value } );
		}
			
		public function get scoreUpdater():uint {
			return _scoreUpdater;
		}
		
		public function set scoreUpdater(value:uint):void {
			_scoreUpdater = value;
			t.text = value.toString();
		}
		
	}

}