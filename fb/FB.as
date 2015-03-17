package maoz.bullets99.fb {
	/**
	 * ...
	 * @author scars
	 */
	public class FB {
		static public var accessToken:String;
		static public var uid:String;
		static public var name:String;
		static public var pic:String;
		static private var permissions:Array = [];
		
		static private var callbacks:Array = [];
		
		
		
		
		public function FB() {
			
		}
		
		
		static public function setData(rs:Object, accessToken:String = null):void {
			FB.accessToken = accessToken;
			
			if (rs == null) {
				uid = name = pic = null;
				
			}else {
				uid = rs.id;
				name = rs.name;
				pic = rs.picture.data.url;
				permissions = rs.permissions.data;
			}
			
			for each(var f:Function in callbacks){
				f();
			}
		}
		
		static public function registerStatusUpdate(func:Function):void {
			for each(var f:Function in callbacks){
				if (f == func) return;
			}
			callbacks.push(func);
		}
		static public function unregisterStatusUpdate(func:Function):void {
			for (var i:int = 0; i < callbacks.length;i++){
				if (callbacks[i] == func) callbacks.splice(i--, 1);
			}
		}
		
		static public function hasPermission(permission:String):Boolean {
			//'publish_actions'
			for (var i:int = 0; i < permissions.length; i++) {
				if (permissions[i].permission == permission && permissions[i].status == 'granted') {
					return true;
				}
			}
			return false;
		}
		
	}

}