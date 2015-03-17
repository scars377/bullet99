package maoz.bullets99.fb {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	/**
	 * ...
	 * @author scars
	 */
	public class FacebookIcon extends Sprite {
		static private var imgSize:Number = 20;
		
		private var loader:Loader;
		public var t1:TextField;
		public var b1:SimpleButton
		
		public function FacebookIcon() {
			visible = false;
			
			loader = new Loader();
			loader.x = b1.x;
			loader.y = b1.y;
			loader.scrollRect = new Rectangle(0, 0, imgSize, imgSize);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			addChild(loader);
			
			b1.addEventListener(MouseEvent.CLICK, doLogin);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function removed(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			FB.unregisterStatusUpdate(statusUpdate);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			x = stage.stageWidth-10;
			y = stage.stageHeight; x
			
			FB.registerStatusUpdate(statusUpdate);
			ExternalInterface.call('fbStatus');
			ExternalInterface.addCallback('fbStatus', FB.setData);
		}
		
		private function statusUpdate():void {
			visible = true;
			if (FB.uid == null) {
				setText('Login with Facebook');
				
			}else {
				b1.visible = false;
				setText(FB.name);
				setPicture(FB.pic);
			}
		}
		
		
		private function setPicture(url:String):void {
			loader.load(new URLRequest(url), new LoaderContext(true));
		}
		
		private function setText(s:String):void {
			t1.text = s;
			t1.autoSize = 'right';
			
		}
		
		private function loadComplete(e:Event):void {
			var bmp:Bitmap = loader.content as Bitmap;
			if (!bmp) return;
			
			bmp.smoothing = true;
			bmp.width = imgSize;
			bmp.height = imgSize;
		}
		
		
		
		private function doLogin(e:MouseEvent):void {
			ExternalInterface.call('fbLogin');
		}
		
	}

}