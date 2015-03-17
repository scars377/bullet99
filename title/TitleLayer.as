package maoz.bullets99.title {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import maoz.bullets99.SoundEffects;
	/**
	 * ...
	 * @author scars
	 */
	public class TitleLayer extends Sprite {
		
		public function TitleLayer() {
			addChildAt(new TitleEncount(), 0);
			b1.addEventListener(MouseEvent.CLICK, startGame);
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		
		private function init(e:Event):void {
			SoundEffects.loop('opening');
		}
		private function removed(e:Event):void {
			//SoundEffects.stopLoop();
		}
		
		private function startGame(e:MouseEvent):void {
			dispatchEvent(new Event('start_game'));
		}
		
	}

}