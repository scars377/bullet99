package maoz.bullets99 {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author scars
	 */
	public class SoundItem extends EventDispatcher{
		private var snd:Sound;
		private var ch:SoundChannel;
		
		public function SoundItem(src:String) {
			snd = new Sound();
			snd.addEventListener(Event.COMPLETE, soundLoaded);
			snd.load(new URLRequest('snd/' + src));
		}
		
		/* DELEGATE flash.media.Sound */
		public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):SoundChannel {
			ch = snd.play(startTime, loops, sndTransform);
			return ch;
		}
		
		/* DELEGATE flash.media.SoundChannel */
		public function stop():void {
			if (ch) ch.stop();
		}
		
		private function soundLoaded(e:Event):void {
			dispatchEvent(e);
		}
		
		
	}

}