package maoz.bullets99.results {
	import com.adobe.crypto.MD5;
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import maoz.bullets99.fb.FB;
	import maoz.bullets99.game.Game;
	import maoz.bullets99.UploadPostHelper;
	/**
	 * ...
	 * @author scars
	 */
	public class Results extends Sprite {
		private var t1:TextField;
		private var t2:TextField;
		private var ts:TextField;
		
		private var b1:SimpleButton;
		private var b2:SimpleButton;
		private var b3:SimpleButton;
		private var b4:SimpleButton;
		private var png:ByteArray;
		
		public var warning:Sprite;
		
		public function Results() {
			t1 = frame.getChildByName('t1') as TextField;
			t2 = frame.getChildByName('t2') as TextField;
			ts = frame.getChildByName('ts') as TextField;
			ts.mouseEnabled = false;
			
			b1 = frame.getChildByName('b1') as SimpleButton;
			b2 = frame.getChildByName('b2') as SimpleButton;
			b3 = frame.getChildByName('b3') as SimpleButton;
			b4 = frame.getChildByName('b4') as SimpleButton;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		
		
		private function init(e:Event):void {
			var s:String = '';
			s += Game.stat.bullets + '\n';
			s += Game.stat.time + '\n';
			s += Game.stat.chain;
			
			t1.text = s;
			t2.text = Game.stat.score.toString();
			
			b1.addEventListener(MouseEvent.CLICK, retry);
			b2.addEventListener(MouseEvent.CLICK, title);
			b3.addEventListener(MouseEvent.CLICK, saveImage);
			b4.addEventListener(MouseEvent.CLICK, shareImage);
			
			var bmp:Bitmap = new Bitmap(Game.stat.snap, 'auto', false);
			bmp.x = 100;
			bmp.y = 30;
			addChildAt(bmp, 0);
			
			bmp = new Bitmap(Game.stat.snap, 'auto', true);
			bmp.x = 232;
			bmp.y = 320;
			bmp.width = 116;
			bmp.height = 110;
			frame.addChildAt(bmp, 0);
			
			if (FB.uid == null) {
				frame.visible = true;
				frame.alpha = 1;
				FB.registerStatusUpdate(statusUpdate);
			}else {
				frame.visible = false;
				frame.alpha = 0;
				submit();
			}
		}
		
		private function saveImage(e:*= null):void {
			if (!png) png = PNGEncoder.encode(Game.stat.snap);
			
			var f:FileReference = new FileReference();
			f.save(getPNG() , 't999_' + Game.stat.score+'.png');
		}
		
		private function shareImage(e:*= null):void {
			if (FB.hasPermission('publish_actions')) {
				b4.visible = false;
				ts.text = 'Uploading...';
				shareImageUsingToken(FB.accessToken);
				
			}else {
				b4.visible = true;
				ts.text = 'Share';
				ExternalInterface.call('fbLoginExtended');
			}
			
		}
		
		private function shareImageUsingToken(token:String):void {
			var r:URLRequest = new URLRequest();
			r.url = 'https://graph.facebook.com/me/photos';
			r.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			r.method = 'post';
			r.data = UploadPostHelper.getPostData("photo.png", ShareLayout.getPNG(), { message:shareMassge(Game.stat.score), access_token:token } );
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, shareImageComplete);
			l.load(r);
			
		}
		
		
		private function shareMassge(score:int):String {
			var s:String = '我在[特訓鳩鳩]';
			var a:Array = ['只打到', '打到了', '衝上了'];
			var b:Array = ['分...', '分', '分!!'];
			
			var i:int;
			if (score < 100000) i = 0;
			else if (score < 500000) i = 1;
			else i = 2;
			
			s += a[i] + score+b[i];
			
			if (score == 0) s += '\n0分也要分享...';
			
			s+='\nhttp://maoz.tw/t999/';
			
			return s;
		}
		
		private function shareImageComplete(e:Event):void {
			var rs:Object = JSON.parse(e.target.data);
			if(rs.id!=null){
				ts.text = 'Shared';
			}else {
				b4.visible = true;
				ts.text = 'Share';
			}
		}
		
		
		private function getPNG():ByteArray {
			if (!png) png = PNGEncoder.encode(Game.stat.snap);
			return png;
		}
		
		
		private function removed(e:Event):void {
			FB.unregisterStatusUpdate(statusUpdate);
		}
		
		private function statusUpdate():void {
			if (FB.uid == null) return;
			submit();
		}
		
		private function submit():void {
			setText('Uploading score...');
			
			var obj:Object = {
				uid:FB.uid,
				name:FB.name,
				pic:FB.pic,
				
				score:Game.stat.score,
				score_bullets:Game.stat.bullets,
				score_chains:Game.stat.chain,
				score_time:Game.stat.time
			};
			
			var data:String = Base64.encode(JSON.stringify(obj));
			var hash:String = MD5.hash(data + 'miku');
			
			var v:URLVariables = new URLVariables();
			v['d'] = hash + data;
			
			
			var r:URLRequest = new URLRequest();
			r.url = 'submit.php';
			r.method = 'POST';
			r.data = v;
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, submitComplete);
			l.load(r);
		}
		
		private function setText(s:String):void {
			t3.text = s;
			t3.autoSize = 'right';
			t3.x = 660 - t3.width;
			t3.y = 560 - t3.height;
			
		}
		
		private function submitComplete(e:Event):void {
			setText(e.target.data);
			frame.visible = true;
			TweenLite.to(frame, 0.2, { alpha:1 } );
			
			if (e.target.data != '') {
				ExternalInterface.call('refreshRanking');
			}
		}
		
		
		
		
		private function retry(e:MouseEvent):void {
			dispatchEvent(new Event('retry'));
		}
		
		private function title(e:MouseEvent):void {
			dispatchEvent(new Event('title'));
			
		}
		
	}

}