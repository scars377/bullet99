package maoz.bullets99{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class SoundControlLayer extends Sprite {
		private var m:MovieClip;
		private var s:MovieClip;
		private var so:SharedObject;
		
		public function SoundControlLayer() {
			m = getChildByName('music_') as MovieClip;
			s = getChildByName('sound_') as MovieClip;
			
			m.buttonMode = m.useHandCursor = true;
			s.buttonMode = m.useHandCursor = true;
			
			m.addEventListener(MouseEvent.CLICK, toggleMusic);
			s.addEventListener(MouseEvent.CLICK, toggleSound);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			so = SharedObject.getLocal('sound');
			muteMusic = so.data.muteMusic;
			muteSound = so.data.muteSound;
		}
		
		
		
		private function init(e:Event):void {
			x = 10;
			y = stage.stageHeight;
		}
		
		
		private function toggleMusic(e:MouseEvent):void {
			muteMusic = !muteMusic;
			
		}
		private function toggleSound(e:MouseEvent):void {
			muteSound = !muteSound;
		}
		
		
		
		public function get muteMusic():Boolean {
			return m.currentFrame == 2;
		}
		
		public function set muteMusic(value:Boolean):void {
			m.gotoAndStop(value?2:1);
			SoundEffects.musicEnabled = !value;
			so.data.muteMusic = value;
			so.flush();
		}
		
		public function get muteSound():Boolean {
			return s.currentFrame == 2;
		}
		
		public function set muteSound(value:Boolean):void {
			s.gotoAndStop(value?2:1);
			SoundEffects.soundEnabled = !value;
			so.data.muteSound = value;
			so.flush();
		}
		
	}
	
}