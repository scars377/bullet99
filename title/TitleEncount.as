package maoz.bullets99.title {
	import flash.geom.Rectangle;
	import maoz.bullets99.game.Encount;
	import maoz.bullets99.game.Game;
	/**
	 * ...
	 * @author scars
	 */
	public class TitleEncount extends Encount{
		
		public function TitleEncount() {
			Game.bulletNumber = 30;
			Game.bounds = new Rectangle(0, 0, 780, 610);
			super();
		}
		
	}

}