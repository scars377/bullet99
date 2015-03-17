package maoz.bullets99  {
	import com.adobe.crypto.MD5;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class Settings {
		static public var xml:XML;
		static private var vars:Object;
		static private var callback:Function;
		
		public function Settings() {
			
		}
		
		public static function parse(str:String):void {
		}
		
		public static function getValue(str:String):String {
			return vars[str];
		}
		
		static public function load(init:Function):void {
			callback = init;
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, loadComplete);
			
			if (BulletsMain.local) {
				l.load(new URLRequest('settings.xml'));
			}else {
				l.load(new URLRequest('settings.php'));
			}
			
		}
		
		static private function loadComplete(e:Event):void {
			if (BulletsMain.local) {
				xml = XML(e.target.data);
				trace('is local');
				
			}else{
				var hash = e.target.data.substr(0, 32);
				var data = e.target.data.substr(32);
				if ((MD5.hash(data + 'pikachu') == hash)) {
					xml = XML(Base64.decode(data));
				}else {
					return;
				}
			}
			
			var list:XMLList = xml.child('var');
			vars = { };
			for each(var x:XML in list) {
				vars[String(x.@name)] = String(x.@value);
			}
			callback();
			
		}
	}
	
}