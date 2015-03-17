package maoz.bullets99  {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class SoundEffects {
		private static var lib:Object;
		
		private static var soundCh:SoundChannel;
		private static var musicCh:SoundChannel;
		
		private static var soundTransform:SoundTransform;
		private static var musicTransform:SoundTransform;
		
		private static var _musicEnabled:Boolean = true;
		private static var _soundEnabled:Boolean = true;
		
		static private var numToLoad:uint;
		static private var callback:Function;
		
		public function SoundEffects() {
			
		}
		
		public static function init(callback:Function):void {
			SoundEffects.callback = callback;
			lib = { };
			var list:XMLList = Settings.xml.sound;
			numToLoad = list.length();
			for each(var m:XML in list) {
				var n:String = m.@id;
				var s:SoundItem = new SoundItem(m);
				s.addEventListener('complete', soundLoaded);
				lib[n] = new SoundItem(m);
			}
			
			soundTransform = new SoundTransform();
			musicTransform = new SoundTransform();
		}
		
		static private function soundLoaded(e:Event):void {
			if (--numToLoad <= 0) callback();
		}
		
		
		public static function play(id:String):void {
			soundCh = lib[id].play();
			soundCh.soundTransform = soundTransform;
		}
		
		public static function loop(id:String):void {
			stopLoop();
			musicCh = lib[id].play(40, int.MAX_VALUE);
			musicCh.soundTransform = musicTransform;
		}
		
		static public function stop(id:String):void {
			lib[id].stop();
		}
		
		public static function stopLoop():void {
			if (musicCh) musicCh.stop();
		}
		
		
		static public function get soundEnabled():Boolean { return _soundEnabled; }
		static public function set soundEnabled(value:Boolean):void {
			_soundEnabled = value;
			soundTransform.volume = value?1:0;
			if(soundCh)	soundCh.soundTransform = soundTransform;
		}
		
		
		static public function get musicEnabled():Boolean { return _musicEnabled; }
		static public function set musicEnabled(value:Boolean):void {
			_musicEnabled = value;
			musicTransform.volume = value?1:0;
			if(musicCh)	musicCh.soundTransform = musicTransform;
		}
		
	}
	
}