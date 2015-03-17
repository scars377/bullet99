package maoz.bullets99.results {
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import maoz.bullets99.game.Game;
	/**
	 * ...
	 * @author scars
	 */
	public class ShareLayout extends Sprite {
		private var bmpData:BitmapData;
		public var t0:TextField;
		public var t1:TextField;
		public var t2:TextField;
		public var t3:TextField;
		
		public function ShareLayout() {
			t0.text = moneyFormat(Game.stat.score);
			t1.text = Game.stat.bullets.toString();
			t2.text = Game.stat.time.toString();
			t3.text = Game.stat.chain.toString();
			
			bmpData = new BitmapData(500, 275, false, 0);
			bmpData.draw(this);
			bmpData.draw(Game.stat.snap, new Matrix(0.5, 0, 0, 0.5));
		}
		
		private function snap():ByteArray {
			return PNGEncoder.encode(bmpData);
		}
		
		static public function getPNG():ByteArray {
			return (new ShareLayout()).snap();
		}
		
	}

}