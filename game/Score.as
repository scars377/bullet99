package maoz.bullets99.game {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	public class Score extends Sprite {
		public var stat_t:TextField;
		public var time_t:TextField;
		public var gauge:Gauge;
		
		private var _numAte:uint = 0;
		private var startTime:int;
		
		public function Score() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function removed(e:Event = null):void {
			removeEventListener(Event.ENTER_FRAME, updateTimer);
			parent.removeEventListener('ate', addAte);
		}
		private function init(e:Event):void {
			y = stage.stageHeight;
			
			numAte = 0;
			
			startTime = getTimer();
			addEventListener(Event.ENTER_FRAME, updateTimer);
			parent.addEventListener('ate', addAte);
		}
		
		public function freeze():void {
			removed();
		}
		
		
		private function addAte(e:Event):void {
			e.stopPropagation();
			numAte+= 1;
			gauge.add(e.target.type);
		}
		
		private function updateTimer(e:Event):void {
			var t:Number = (getTimer() - startTime) * 0.001;
			time_t.text = t.toFixed(2);
		}
		
		public function get numAte():uint {
			return _numAte;
		}
		
		public function set numAte(value:uint):void {
			_numAte = value;
			stat_t.text = value+'/' + Game.numBullets;
		}
		
	}
	
}