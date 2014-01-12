package  {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Boss extends MovieClip{
	
		public var bossSpeed:Number;
		public var bossRole:uint;
		public var speedX:Number;
		public var speedY:Number
		public var hitTimes:uint = 0;
		public static const MAXSPEED:int = 50;
		public static const TIMES:int = 2;
		public static const GAP:Number = 50;
		public var timer:Timer = new Timer(1000,1);
		
		public function Boss(positionX:Number,positionY:Number,speed:Number,role:uint) {
			// constructor code
			this.x = positionX;
			this.y = positionY;
			bossSpeed = speed;
			bossRole = role;
			
			generateSpeed();
			chooseCharacter();
			this.addEventListener(Event.ENTER_FRAME,bossMovement);
		}
		
		/**generate a random speed**/
		public function generateSpeed():void{
			var tempX:Number = (Math.random()*(bossSpeed/TIMES));
			speedY = (Math.random()*bossSpeed);
			if(tempX > ((bossSpeed/TIMES)/2)){
				speedX = tempX;
			}
			else speedX = -tempX;
		}
		
		/**random choose a character**/
		public function chooseCharacter():void{
			if(bossRole == 1){
				this.gotoAndPlay(1);
			}
			else if(bossRole == 2){
				this.gotoAndPlay(15);
			}
		}
		
		public function bossMovement(event:Event){
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
		
		public function boundaryJudgement():void{
			if(this.y > 600){
				MovieClip(parent).badguyEscape();
				deleteBoss();
			}
			if(this.x < (0+GAP) && speedX < 0){
				speedX = -speedX;
			}
			if(this.x > (800-GAP) && speedX >0){
				speedX = -speedX;
			}
		}
		
		/**delete a bad guy from stage and array**/
		public function deleteBoss():void{
			trace("begin to delete badguy");
			MovieClip(parent).removeBoss(this);
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,bossMovement);
			delete(this);
		}
		
		public function deleteBoss2():void{
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,bossMovement);
			delete(this);
		}
		
		/**response the hit event**/
		public function bossHit():void{
			if(hitTimes == 0){
				if(bossRole == 1){
					this.gotoAndPlay(31);
				}
				else if(bossRole == 2) {
					this.gotoAndPlay(45);
				}
				hitTimes++;
			}
			else if(hitTimes == 1){
				if(bossRole == 1){
					this.gotoAndPlay(61);
					timer.addEventListener(TimerEvent.TIMER,timerHandler);
					timer.start();
				}
				else if(bossRole == 2) {
					this.gotoAndPlay(75);
					timer.addEventListener(TimerEvent.TIMER,timerHandler);
					timer.start();
				}
			}
			
		}
		/**create a time span using timer, then delete a bad guy**/
		public function timerHandler(event:TimerEvent):void{
			deleteBoss();
		}

	}
	
}
