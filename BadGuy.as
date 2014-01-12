package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class BadGuy extends MovieClip{

		public var badguySpeed:Number;
		public var speedX:Number;
		public var speedY:Number;
		public var number:Number = Math.random();
		public static const MAXSPEED:int = 50;
		public static const TIMES:int = 2;
		public static const GAP:Number = 50;
		public var timer:Timer = new Timer(1000,1);
		
		public function BadGuy(positionX:Number,positionY:Number,speed:Number){
			// constructor code
			this.x = positionX;
			this.y = positionY;
			badguySpeed = speed;
			generateSpeed();
			chooseCharacter();
			this.addEventListener(Event.ENTER_FRAME,badguyMovement);
		}
		/**random choose a character**/
		public function chooseCharacter():void{
			if(number < 0.5){
				this.gotoAndPlay(1);
			}
			else this.gotoAndPlay(15);
		}
		/**control the student movement***/
		public function badguyMovement(event:Event):void{
			this.x += speedX;
			this.y += speedY;
			if(speedX > 0 && speedX > MAXSPEED){
				speedX = MAXSPEED;
			}
			if(speedX < 0 && speedX < -MAXSPEED){
				speedX = -MAXSPEED;
			}
			if(speedY > MAXSPEED){
				speedY = MAXSPEED;
			}
			boundaryJudgement();
		}
		/**check whether over the stage boundary**/
		public function boundaryJudgement():void{
			if(this.y > 600){
				MovieClip(parent).badguyEscape();
				deletebadguy();
			}
			if(this.x < (0+GAP) && speedX < 0){
				speedX = -speedX;
			}
			if(this.x > (800-GAP) && speedX >0){
				speedX = -speedX;
			}
		}
		
		public function moveBadguy():void{
			this.x = -300;
			this.y = -100;
		}
		/**delete a bad guy from stage and array**/
		public function deletebadguy():void{
			trace("begin to delete badguy");
			//moveBadguy();
			MovieClip(parent).removeBadguy(this);
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,badguyMovement);
			//moveBadguy();
			delete(this);
		}
		
		public function deleteBadguy2():void{
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,badguyMovement);
			delete(this);
		}
		
		/**generate a random speed**/
		public function generateSpeed():void{
			var tempX:Number = (Math.random()*(badguySpeed/TIMES));
			speedY = (Math.random()*badguySpeed);
			if(tempX > ((badguySpeed/TIMES)/2)){
				speedX = tempX;
			}
			else speedX = -tempX;
		}
		/**response the hit event**/
		public function badguyHit():void{
			if(number < 0.5){
				this.gotoAndPlay(30);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				//deletebadguy();
			}
			else{
				this.gotoAndPlay(40);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				//deletebadguy();
			}
		}
		/**create a time span using timer, then delete a bad guy**/
		public function timerHandler(event:TimerEvent):void{
			deletebadguy();
		}

	}
	
}
