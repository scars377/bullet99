package maoz.bullets99.game {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import maoz.bullets99.SoundEffects;
	
	public class Encount extends Sprite {
		private var bullets:Array;
		private var i:int;
		private var bulletType:int;
		private var addBulletInt:int;
		private var shipRect:Rectangle;
		
		public function Encount() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function removed(e:Event = null):void {
			removeEventListener(Event.ENTER_FRAME, update);
			clearTimeout(addBulletInt);
		}
		
		private function init(e:*= null):void {
			Bullet.init();
			
			shipRect = new Rectangle();
			bullets = [];
			bulletType = 0;
			
			addBulletTime();
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function addBulletTime():void {
			if (numChildren < Game.bulletNumber) addBullet();
			addBulletInt = setTimeout(addBulletTime, 100);
		}
		
		private function addBullet():void {
			var b:Bullet = new Bullet(int(bulletType / 3));
			addChild(b);
			bullets.push(b);
			
			if (++bulletType == 6) bulletType = 0;
		}
		
		
		private function update(e:Event):void {
			if (!Ship.instance) {
				shipRect.setTo(stage.stageWidth / 2, stage.stage.height / 2, 0, 0);
			}else if(Ship.instance.inBounds){
				shipRect.setTo(mouseX - Game.judgeDist, mouseY - Game.judgeDist, Game.judgeDist * 2, Game.judgeDist * 2);
			}else {
				shipRect.setTo(Ship.instance.x - Game.judgeDist, Ship.instance.y - Game.judgeDist, Game.judgeDist * 2, Game.judgeDist * 2);
			}
			
			for (i = 0; i < bullets.length; i++) {
				switch(bullets[i].update(shipRect)) {
					case -1:
						removeChild(bullets[i]);
						bullets.splice(i, 1);
						SoundEffects.play('eat');
						break;
					case 1:
						dispatchEvent(new Event('failed', true));
						break;
				}
			}
		}
		
		public function freeze():void {
			removed();
		}
		
		
	}
	
}