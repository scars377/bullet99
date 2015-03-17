package maoz.bullets99.game.huds {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import maoz.bullets99.game.Ship;
	/**
	 * ...
	 * @author scars
	 */
	public class ScoreFloat extends Sprite {
		public var t1:TextField;
		
		public function ScoreFloat(n:uint) {
			t1.text = n.toString();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			var p:Point = new Point(0, 0);
			p = Ship.instance.localToGlobal(p);
			p = parent.globalToLocal(p);
			x = int(p.x);
			y = int(p.y - 24);
			TweenLite.delayedCall(0.5, parent.removeChild, [this]);
		}
		
	}

}