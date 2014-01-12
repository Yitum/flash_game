package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.net.URLRequest; 
	import flash.media.SoundChannel;
	
	public class CompusCrimeTerminator extends MovieClip{
		
		public var Baseballs:Array = new Array();
		public var ballLimitation:uint = 3;
		public var ballNumber:uint = 0;
		public var Students:Array = new Array();
		public var studentSpeed:int = 5;
		public var Badguys:Array = new Array();
		public var badguySpeed:int = 5;
		public var Bosses:Array = new Array();
		public var bossSpeed:int = 6;
		public var powerTimes:Number = 1;
		public var livesNumber:uint = 3;
		public var score:int = 0;
		//public static const BALLLIMITATION = 3;
		public static const STAGEWIDTH = 800;
		public static const STAGEHEIGHT = 600;
		public static const LIVE:uint = 3;
		public var judgeTimer:Timer = new Timer(500);
		public var studentTimer:Timer = new Timer(10000);
		public var badguyTimer:Timer = new Timer(4000);
		public var bossTimer:Timer = new Timer(8000);
		public var clickCount:uint = 0;
		public var newRolestatus:uint = 0;
		public var bossCharacter:uint = 0;
		
		public var talkingSound:Sound = new Sound();
		public var shootSound:Sound = new Sound();
		public var backgroundmusic:Sound = new Sound();
		public var BGMchannel:SoundChannel = new SoundChannel();
		public var Talkingchannel:SoundChannel = new SoundChannel();
		
		public var angle:Number;
		public var firepower:Number;
		public static const MAXPOWER = 2000;

		public function CompusCrimeTerminator() {
			// constructor code
			stop();
			tf_start.addEventListener(MouseEvent.CLICK,startHandler);
		}
		
		public function startHandler(event:MouseEvent):void{
			gotoAndStop(2);
			talking();
			//Sign.visible = false;
			//startGame();
		}
		
		public function talking():void{
			
			board_student.next.addEventListener(MouseEvent.CLICK,talkingHandler1);
			stage.addEventListener(Event.ENTER_FRAME,talkingHandler2);
			bg_student1.gotoAndStop(1);
			bg_student2.gotoAndStop(2);
			talkingSound.load(new URLRequest("Talking.mp3"));
			Talkingchannel = talkingSound.play();
			
		}
		
		public function talkingHandler1(event:MouseEvent):void{
			clickCount++;
			trace("clickCount:"+clickCount);
		}
		
		public function talkingHandler2(event:Event):void{
			switch(clickCount){
				case 0:
				board_student.tf.text = "Recently, there are some bad guys who want to destory our campus.";
				break;
				case 1:
				board_student.tf.text = "However, students unable to protect the campus because of the high pressure of their studies.";
				break;
				case 2:
				board_student.tf.text = "We are seeking a HERO to save our campus and students!!!";
				break;
				case 3:
				board_student.tf.text = "You can use baseball shooter to beat those bad guys, but shoot them carefully to avoid  accidental injury.";
				break;
				case 4:
				board_student.tf.text = "When you shoot a specific amount of bad guys, some special boss who is a tough guy will enter the scene.";
				break;
				case 5:
				board_student.tf.text = "But don't worry, you just need to shoot them two times. When you shoot all of them, you will win! Remember don't let them pass you!";
				break;
				case 6:
				board_student.tf.text = "Are you ready to accpte the challenge? We need a real hero right now!";
				break;
				case 7:
				gotoAndStop(3);
				startGame();
				stage.removeEventListener(Event.ENTER_FRAME,talkingHandler2);
				Talkingchannel.stop();
				break;
			}
		}
		
		/** Start Game **/
		public function startGame():void{
			trace("Game Starts");
			Sign.visible = false;
			tf_restart.visible = false;
			board_level.stop();
			Lives.gotoAndStop(4);
			mouseController();
			//public var req:URLRequest = new URLRequest("shoot.WAV"); 
			shootSound.load(new URLRequest("Shooting.mp3"));
			backgroundmusic.load(new URLRequest("BGM.mp3"))
			//backgroundmusic.play();
			BGMchannel = backgroundmusic.play();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,generateBall);
			studentGenerator();
			badguyGenerator();
			//bossGenerator();
			gameJugement();
			tf_restart.addEventListener(MouseEvent.CLICK,Gamerestart);
		}
		/*****************************Student***********************************/
		/** according to timer span, create a new student**/
		public function studentGenerator():void{
			studentTimer.addEventListener(TimerEvent.TIMER,studentHandler);
			studentTimer.start();
		}
		
		public function studentHandler(event:TimerEvent):void{
			generateStudent();
		}
		/**generate a single student**/
		public function generateStudent():void{
			var studentX,studentY:Number;
			//studentX = Math.random()*STAGEWIDTH;
			//studentY = 50;
			studentX = Math.random()*300;
			if(studentX > 150){
				studentX += 500;
			}
			studentY = 150;
			var myStudent:Student = new Student(studentX,studentY,studentSpeed);
			addChild(myStudent);
			Students.push(myStudent);
		}
		/**remove the student from array**/
		public function removeStudent(student:MovieClip):void{
			var i :uint;
			for(i=0;i<Students.length;i++){
				if(Students[i] == student){
					Students.splice(i,1);
					trace("this student has been removed");
					break;
				}
			}
		}
		/**remove all student from array**/
		public function removeAllstudent():void{
			var studentsLength:uint = Students.length;
			var i:uint;
			for(i=0;i<Students.length;i++){
				if(contains(Students[i])){
					//removeChild(Students[i]);
					Students[i].deleteStudent2();
				}
			}
			Students.splice(0,studentsLength);
			trace("remove all students");
		}
		/*****************************BOSS***********************************/
		/** according to timer span, create a new boss**/
		public function bossGenerator():void{
			bossTimer.addEventListener(TimerEvent.TIMER,bossHandler);
			bossTimer.start();
		}
		public function bossHandler(event:TimerEvent):void{
			generateBoss();
		}
		/**generate a single boss**/
		public function generateBoss():void{
			var bossX,bossY:Number;
			//var character:int = Math.random()*bossCharacter;
			//bossX = Math.random()*STAGEWIDTH;
			//bossY = 50;
			bossX = Math.random()*300;
			if(bossX > 150){
				bossX += 500;
			}
			bossY = 150;
			var myboss:Boss = new Boss(bossX,bossY,bossSpeed,bossCharacter);
			addChild(myboss);
			Bosses.push(myboss);
		}
		/**remove the boss from array**/
		public function removeBoss(boss:MovieClip):void{
			var i :uint;
			for(i=0;i<Bosses.length;i++){
				if(Bosses[i] == boss){
					Bosses.splice(i,1);
					trace("this boss has been removed");
					break;
				}
			}
		}
		/**remove all bosses from array**/
		public function removeAllboss():void{
			var bossesLength:uint = Bosses.length;
			var i:uint;
			for(i=0;i<Bosses.length;i++){
				if(contains(Bosses[i])){
					Bosses[i].deleteBoss2();
				}
			}
			Bosses.splice(0,bossesLength);
			trace("remove all bosses");
		}
		/*****************************BadGuy***********************************/
		/** according to timer span, create a new bad guy**/
		public function badguyGenerator():void{
			badguyTimer.addEventListener(TimerEvent.TIMER,badguyHandler);
			badguyTimer.start();
		}
		
		public function badguyHandler(event:TimerEvent):void{
			generateBadguy();
		}
		/**generate a single bad guy**/
		public function generateBadguy():void{
			var badguyX,badguyY:Number;
			badguyX = Math.random()*300;
			if(badguyX > 150){
				badguyX += 500;
			}
			badguyY = 150;
			var myBadguy:BadGuy = new BadGuy(badguyX,badguyY,badguySpeed);
			addChild(myBadguy);
			Badguys.push(myBadguy);
		}
		/**remove the bad guy from array**/
		public function removeBadguy(badguy:MovieClip):void{
			var i :uint;
			for(i=0;i<Badguys.length;i++){
				if(Badguys[i] == badguy){
					Badguys.splice(i,1);
					trace("this badguy has been removed");
					//badguyEscape();
					break;
				}
			}
		}
		/**remove all bad guy from array**/
		public function removeAllbadguy():void{
			var badguyssLength:uint = Badguys.length;
			var i:uint;
			for(i=0;i<Badguys.length;i++){
				if(contains(Badguys[i])){
					//removeChild(Badguys[i]);
					Badguys[i].deleteBadguy2();
				}
			}
			Badguys.splice(0,badguyssLength);
			trace("remove all badguys");
		}
		/*****************************BALL***********************************/
		/**generate a single ball**/
		public function generateBall(event:MouseEvent):void{
			var ballX,ballY:Number;
			var speedX,speedY:Number;
			//ballX = Gun.x;
			//ballY = (Gun.y - 50);
			shootSound.play();
			ballX = baseball_shooter.x + 160*Math.cos(angle*(Math.PI/180));
			ballY = baseball_shooter.y - 160*Math.sin(angle*(Math.PI/180));
			speedX = Math.cos(angle*Math.PI/180)*firepower;
			speedY = Math.sin(angle*Math.PI/180)*firepower;
			
			if(ballNumber<ballLimitation){
				var myBall:Baseball = new Baseball(ballX,ballY,speedX,speedY);
				ballNumber++;
				addChild(myBall);
				Baseballs.push(myBall);
			}
		}
		/**remove the ball**/
		public function removeBall(ball:MovieClip):void{
			var i:uint;
			for(i=0;i<Baseballs.length;i++){
				if(Baseballs[i] == ball){
					Baseballs.splice(i,1);
					trace("this ball has been removed");
					ballNumber--;
					break;
				}
			}
		}
		
		public function addBallnumber():void{
			ballNumber--;
		}
		
		
		
		/*****************************Detection***********************************/
		/**detect collision among balls, students, and bad guy**/
		public function collisionDetection():void{
			var i,j,k,l:uint;
			//for(i=0;i<Baseballs.length;i++){
				//for(j=0;j<Badguys.length;j++){
			for(i=(Baseballs.length-1);i>=0;i--){
				var checksum:uint = 0;
				for(j=(Badguys.length-1);j>=0;j--){
					trace("hit a badguy");
					if(contains(Badguys[j])){
						if(Baseballs[i].hitTestObject(Badguys[j])){
							scoreRecord();
							Badguys[j].badguyHit();
							if(contains(Baseballs[i])){
								Baseballs[i].deleteBall();
								checksum = 1;
							}
							break;
						}
					}
					
				}
				if(checksum == 0){
					for(k=(Students.length-1);k>=0;k--){
						if(contains(Students[k])){
							if(Baseballs[i].hitTestObject(Students[k])){
								trace("hit a student");
								hitStudent();
								Students[k].studentHit();
								if(contains(Baseballs[i])){
									Baseballs[i].deleteBall();
									checksum = 1;
								}
								break;
							}
						}
					}
				}
				if(checksum == 0){
					for(l=(Bosses.length-1);l>=0;l--){
						if(contains(Bosses[l])){
							if(Baseballs[i].hitTestObject(Bosses[l])){
								trace("hit a boss");
								scoreRecord();
								Bosses[l].bossHit();
								if(contains(Baseballs[i])){
									Baseballs[i].deleteBall();
									checksum = 1;
								}
								break;
							}
						}
					}
				}
			}
			
			/*for(i=(Baseballs.length-1);i>=0;i--){
				for(k=(Students.length-1);k>=0;k--){
					if(contains(Students[k])){
						if(Baseballs[i].hitTestObject(Students[k])){
							trace("k = "+k);
							hitStudent();
							Students[k].studentHit();
							if(contains(Baseballs[i])){
								Baseballs[i].deleteBall();
							}
							break;
						}
					}
				}
			}*/
		}
		
		/**check the collision, update lives and score, using the timer**/
		public function gameJugement(){
			trace("begin to judge game");
			judgeTimer.addEventListener(TimerEvent.TIMER,judgeHandler);
			judgeTimer.start();
		}
		
		public function judgeHandler(event:TimerEvent):void{
			//trace((livesNumber+1));
			//Lives.gotoAndStop((livesNumber+1));
			trace("Student numbers:"+Students.length);
			trace("Bad Guy numbers:"+Badguys.length);
			trace("boss numbers:"+Bosses.length);
			tf_score.text = score.toString();
			collisionDetection();
			if(livesNumber <= 0){
				trace("Game Over");
				Gameover();
			}
			
			switch(livesNumber){
				case 0:
				//trace("0");
				Lives.gotoAndStop(1);
				break;
				case 1:
				//trace("1");
				Lives.gotoAndStop(2);
				break;
				case 2:
				//trace("2");
				Lives.gotoAndStop(3);
				break;
				case 3:
				//trace("3");
				Lives.gotoAndStop(4);
				break;
			}
			
			levelControl();
		}
		
		public function levelControl():void{
			switch(score){
				case 0:
				studentSpeed = 5;
				badguySpeed = 5;
				powerTimes = 1;
				board_level.gotoAndStop(1);
				break;
				
				case 6:
				studentSpeed = 7;
				badguySpeed = 7;
				powerTimes = 1.5;
				board_level.gotoAndStop(2);
				ballLimitation = 4;
				break;
				
				case 15:
				newRole(1);
				studentSpeed = 9;
				badguySpeed = 9;
				powerTimes = 2;
				board_level.gotoAndStop(3);
				break;
				
				case 25:
				newRole(2);
				studentSpeed = 11;
				badguySpeed = 11;
				bossSpeed = 9;
				powerTimes = 2.5;
				board_level.gotoAndStop(4);
				ballLimitation = 5;
				break;
				
				case 35:
				Gamewin();
				break;
			}
		}
		
		public function newRole(character:uint):void{
			trace("character:"+character+" newRolestatus"+newRolestatus);
			if(character == 1 && newRolestatus == 0){
				newRolestatus++;
				trace("begin to generate boss 1");
				bossGenerator();
				bossCharacter = 1;
				
			}
			else if(character == 2 && newRolestatus ==1){
				trace("begin to generate boss 2");
				bossCharacter = 2
			}
		}
		
		
		/**if a bad guy escape from the stage, reduce a live**/
		public function badguyEscape():void{
			trace("a bad guy escaped");
			livesNumber--;
		}
		/**if a student was hitted, reduce a live**/
		public function hitStudent():void{
			trace("you hit a student");
			livesNumber--;
		}
		/**when a bad guy was hitted, using this function**/
		public function scoreRecord():void{
			score++;
		}
		
		public function Gamewin():void{
			removeGenaratorlistener();
			Sign.visible = true;
			Sign.gotoAndStop(2);
			tf_restart.visible = true;
			removemouseController();
			BGMchannel.stop();
		}
		
		public function Gameover():void{
			removeGenaratorlistener();
			Sign.visible = true;
			Sign.gotoAndStop(1);
			tf_restart.visible = true;
			removemouseController();
			BGMchannel.stop();
		}
		
		public function removeGenaratorlistener():void{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,generateBall);
			studentTimer.removeEventListener(TimerEvent.TIMER,studentHandler);
			badguyTimer.removeEventListener(TimerEvent.TIMER,badguyHandler);
			bossTimer.removeEventListener(TimerEvent.TIMER,bossHandler);
		}
		
		public function Gamerestart(event:MouseEvent):void{
			trace("Game Restart");
			removeAllstudent();
			removeAllbadguy();
			removeAllboss();
			mouseController();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,generateBall);
			studentGenerator();
			badguyGenerator()
			Sign.visible = false;
			tf_restart.visible = false;
			livesNumber = 3;
			score = 0;
			newRolestatus = 0;
			ballLimitation = 3;
			BGMchannel = backgroundmusic.play();
		}
		
		/************************aim & baseballshooter*****************************/
		/**set aim & baseballshooter following**/
		public function removemouseController():void{
			Mouse.show();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);
		}
		
		public function mouseController():void{
			Mouse.hide();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseHandler);
		}
		
		public function mouseHandler(event:MouseEvent):void{
			Aim.x = mouseX;
			Aim.y = mouseY;
			//Gun.x = mouseX;
			baseballshooterRotation();
			
		}
		
		public function baseballshooterRotation():void{
			var dvalueX:Number;
			var dvalueY:Number;
			dvalueX = mouseX - baseball_shooter.x;
			dvalueY = ( mouseY - baseball_shooter.y)*-1;
			//trace("dvalueX:"+dvalueX+" dvalueY:"+dvalueY);
			angle = Math.atan(dvalueY/dvalueX)/(Math.PI/180);
			//trace("original angle:"+angle);
			if(dvalueX < 0){
				angle += 180;
			}
			if(dvalueX > 0 && dvalueY < 0){
				angle += 360;
			}
			if(angle > 160){
				angle = 160;
			}
			if(angle <20){
				angle = 20;
			}
			//trace("angle = "+angle);
			firepower = Math.sqrt(dvalueX*dvalueX+dvalueY*dvalueY)*powerTimes;
			if(firepower > MAXPOWER){
				firepower = MAXPOWER;
			}
			baseball_shooter.rotation = angle*-1;
		}
	}
	
}
