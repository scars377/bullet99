package maoz.bullets99 {
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import maoz.bullets99.fb.FacebookIcon;
	import maoz.bullets99.game.Canvas;
	import maoz.bullets99.game.Game;
	import maoz.bullets99.results.Results;
	import maoz.bullets99.title.TitleLayer;
	
	public class BulletsMain extends Sprite {
		static public var local:Boolean;
		private var scene:Sprite;
		
		
		public function BulletsMain() {
			local = loaderInfo.loaderURL.match(/^file/) != null;
			Settings.load(initSound);
		}
		
		private function initSound():void {
			SoundEffects.init(init);
		}
		
		private function init():void {
			Game.getParams();
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest('bg.png'));
			addChildAt(loader, 0);
			
			addChild(new Canvas());
			addChild(new SoundControlLayer());
			addChild(new FacebookIcon());
			
			addTitle();
			
			stage.quality = StageQuality.MEDIUM;
			
			//createFPSText();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyJump);
		}
		
		
		private function createFPSText():void {
			var time:int = getTimer();
			var t:TextField = new TextField();
			t.y = stage.stageHeight - t.height;
			t.autoSize = 'left';
			t.mouseEnabled = false;
			t.textColor = 0xffffff;
			addChild(t);
			t.addEventListener(Event.ENTER_FRAME, function(e:Event) {
				e.currentTarget.text = (1000/(getTimer()-time)).toFixed(0);
				time = getTimer();
			});
			
		}
		
		private function removeScene(e:Event = null):void {
			if (scene && contains(scene)) {
				TweenLite.to(scene, 0.3, { alpha:0, onComplete:removeChild, onCompleteParams:[scene] } );
			}
			System.gc();
			System.gc();
		}
		
		private function addTitle(e:Event = null):void {
			removeScene();
			scene = new TitleLayer();
			scene.addEventListener('start_game', addGame);
			addScene();
		}
		
		private function addGame(e:Event = null):void {
			removeScene();
			scene = new Game();
			scene.addEventListener('show_result', addResults);
			addScene();
		}
		
		private function addResults(e:Event):void {
			removeScene();
			scene = new Results();
			scene.addEventListener('retry', addGame);
			scene.addEventListener('title', addTitle);
			addScene();
		}
		
		private function addScene():void {
			addChildAt(scene, numChildren - 2);
		}
		
		
		private function keyJump(e:KeyboardEvent):void {
			if (Settings.getValue('cheat') != 'true') return;
			
			switch(e.keyCode) {
				case Keyboard.R:
					addGame();
					break;
			}
		}
		
	}
	
}
