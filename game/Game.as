package maoz.bullets99.game {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import maoz.bullets99.game.Encount;
	import maoz.bullets99.game.huds.HUD;
	import maoz.bullets99.Settings;
	import maoz.bullets99.SoundEffects;
	/**
	 * ...
	 * @author scars
	 */
	public class Game extends Sprite {
		static public var slowEffectTime:Number = 5;
		static public var slowEffectRate:Number = 0.3;
		static public var gaugeMax:uint = 50;
		static public var bulletNumber:int = 50;
		static public var chainTime:Number;
		static public var judgeDist:int = 8;
		
		static public var bounds:Rectangle;
		static public var speedRate:Number = 1;
		
		static public var stat:Object;
		
		private var hud:HUD;
		private var ship:Ship;
		private var encount:Encount;
		private var canvas:Canvas;
		
		private var startTime:int;
		
		public function Game() {
			bounds = new Rectangle(100, 30, 580, 550);
			speedRate = 1;
			
			ship = new Ship();
			addChild(ship);
			
			encount = new Encount();
			addChild(encount);
			
			hud = new HUD();
			addChild(hud);
			
			addEventListener('failed', failed);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function init(e:Event):void {
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			bulletNumber = int(Settings.getValue('bulletNumber'));
			SoundEffects.loop('bg');
			startTime = getTimer();
		}
		
		static public function getParams(){
			gaugeMax = int(Settings.getValue('gaugeMax'));
			chainTime = int(Settings.getValue('chainTime'));
			judgeDist = int(Settings.getValue('judgeDist'));
			slowEffectTime = Number(Settings.getValue('slowEffectTime'));
			slowEffectRate = Number(Settings.getValue('slowEffectRate'));
		}
		
		private function failed(e:Event):void {
			hud.freeze();
			ship.freeze();
			encount.freeze();
			stat = {
				bullets:hud.numAte,
				time:getTime(),
				chain:hud.getMaxChain(),
				score:hud.getScore(),
				snap:takeSnap()
			};
			
			buttonMode = useHandCursor = true;
			
			removed();
			
			//addEventListener(MouseEvent.CLICK, showResult);
			showResult();
		}
		
		private function takeSnap():BitmapData {
			var bmp:BitmapData = new BitmapData(bounds.width, bounds.height, false, 0);
			hud.visible = false;
			bmp.draw(stage, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			hud.visible = true;
			
			return bmp;
		}
		
		private function showResult(e:MouseEvent = null):void {
			removeEventListener(MouseEvent.CLICK, showResult);
			dispatchEvent(new Event('show_result'));
		}
		
		private function getTime():String {
			return ((getTimer() - startTime) * 0.001).toFixed(1);
		}
		
		
		private function removed(e:Event = null):void {
			SoundEffects.stopLoop();
		}
		
		
	}

}