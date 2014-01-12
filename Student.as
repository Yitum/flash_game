package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Student extends MovieClip{
		
		public var studentSpeed:Number;
		public var speedX:Number;
		public var speedY:Number;
		public var number:Number = Math.random();
		public static const MAXSPEED:int = 50;
		public static const TIMES:int = 2;
		public static const GAP:Number = 50;
		public var timer:Timer = new Timer(1000,1);
		
		public function Student(positionX:Number,positionY:Number,speed:Number){
			// constructor code
			this.x = positionX;
			this.y = positionY;
			studentSpeed = speed;
			generateSpeed();
			chooseCharacter();
			this.addEventListener(Event.ENTER_FRAME,studentMovement);
		}
		/**random choose a character**/
		public function chooseCharacter():void{
			if(number < 0.5){
				this.gotoAndPlay(1);
			}
			else this.gotoAndPlay(15);
		}
		/**control the student movement***/
		public function studentMovement(event:Event):void{
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
				deleteStudent();
			}
			if(this.x < (0+GAP) && speedX < 0){
				speedX = -speedX;
			}
			if(this.x > (800-GAP) && speedX >0){
				speedX = -speedX;
			}
		}
		
		public function moveStudent():void{
			this.x = -200;
			this.y = -100;
		}
		/**delete a student from stage and array**/
		public function deleteStudent():void{
			trace("begin to delete student");
			MovieClip(parent).removeStudent(this);
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,studentMovement);
			//moveStudent();
			delete(this);
		}
		public function deleteStudent2():void{
			parent.removeChild(this);
			this.removeEventListener(Event.ENTER_FRAME,studentMovement);
			delete(this);
		}
		
		/**generate a random speed**/
		public function generateSpeed():void{
			var tempX:Number = (Math.random()*(studentSpeed/TIMES));
			speedY = (Math.random()*studentSpeed);
			if(tempX > ((studentSpeed/TIMES)/2)){
				speedX = tempX;
			}
			else speedX = -tempX;
		}
		/**response the hit event**/
		public function studentHit():void{
			if(number < 0.5){
				this.gotoAndPlay(30);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				//deleteStudent();
				//moveStudent();
			}
			else{
				this.gotoAndPlay(40);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				//deleteStudent();
			}
		}
		/**create a time span using timer, then delete a student**/
		public function timerHandler(event:TimerEvent):void{
			deleteStudent();
		}
		
		

	}
	
}
