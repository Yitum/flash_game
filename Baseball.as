package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Baseball extends MovieClip{
		
		public var lastTime:Number;
		public var passedTime:Number;
		public var speedX:Number;
		public var speedY:Number;
		
		public function Baseball(positionX:Number,positionY:Number,speedx:Number,speedy:Number){
			// constructor code
			speedX = speedx;
			speedY = speedy;
			this.x = positionX;
			this.y = positionY;
			this.addEventListener(Event.ENTER_FRAME,ballMovement);
		}
		/**control the ball movement**/
		public function ballMovement(event:Event):void{
			this.x += speedX/50;
			this.y -= speedY/50;
			if(this.y<0 || this.x <0 || this.x > 800){
				deleteBall();
			}
			
		}
		/**remove the baseball from stage and array, stop listener**/
		public function deleteBall():void{
			trace("begain to delet ball");
			MovieClip(parent).removeBall(this);
			//MovieClip(parent).addBallnumber();
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,ballMovement);
			//moveBall();
			delete(this);
			
		}
		
		public function moveBall():void{
			this.x = -100;
			this.y = -100;
		}
		

	}
	
}
