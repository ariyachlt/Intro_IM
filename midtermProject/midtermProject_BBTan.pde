/*
Midterm Project: BBTan (Knockoff)
 Intro to IM
 Due: March 4, 2021
 Written by Ariya Chaloemtoem
 */


/* ------------------------------------- GLOBAL VARIABLES DECLARED -------------------------------------- */

// Screen-related variables
int screen = 0;  // tells us which screen we are in (0 = main menu, 1 = instructions, 2 = game, 3 = game over)
int offset = 30;  // offset on the sides and bottom
int offsetTop = offset*3;  // offset from the top

// Ball-related variables
int ballRadius = 15;  // radius of the ball
float mouseAngle;  // angle of the mouse (used to defined wthe direction of the ball)
float shooterAngle;  // angle of the shooter (used to define shooter rotations)
int round = 1;  // the round we are in (and the number of balls in the ArrayList)

// Checkpoint variables
boolean canShoot = true;  // variable indicating whether shooting is possible
boolean shooting =  false;  // variable indicating whether
boolean gameOver = false;

// Score-related variables
BufferedReader highscoreReader;  // declaring a BufferedReader class
int highscore;  // highscore variable
int topScore;  // top score variable (used to check if we should override highscore)
PrintWriter newHighscore;  // declaring a PrintWriter class

// Declaring PImage class
PImage BBTan;

// Sound related variables
import processing.sound.*;  // importing sound library
SoundFile buttonSound, hitSound, gameOverSound;  // variable for 3 sound files

// Declaring interaction system variable
InteractionSystem System;


/* -------------------------------------- SETUP AND DRAW FUNCTIONS -------------------------------------- */

void setup() {
  size(480, 720);
  
  BBTan = loadImage("BBTanDrawing.png");  // loadign BBTan image
  
  buttonSound = new SoundFile(this, "buttonSound.mp3");  // load sound file for when button is clicked
  hitSound = new SoundFile(this, "hitSound.mp3");  // load sound file for when ball collides with block
  gameOverSound = new SoundFile(this, "gameOverSound.mp3");  // load sound file for when game is over
  
  highscoreReader = createReader("highscore.txt");  // creates reader to read file
  
  // reading the line (one line, highscore), catching any IOException errors
  String line;
  try {
    line = highscoreReader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  
  highscore = Integer.parseInt(line);  // casting the line read to integer
  topScore = highscore;  // defining the topScore as the highscore
}

void draw() {
  frameRate(90);  // increasing the framRate to make everything move faster
  background(20);  // setting the background to an almost black color
  
  // Conditions for what to display based on the screen variable
  // screen = main menu
  if(screen == 0){
    mainMenu();  // calling function to display the main menu
  
  // screen = intructions
  } else if (screen == 1){
    instructions();  // calling function to display the instructions
    
  //screen = the game
  } else if(screen == 2){
    drawGameScreen();  // calling function to display the 'box', score/round, and top score
    
    // checking if the balls should be shooting
    if (shooting){
      System.shootBalls();
    }
    
    System.display();  // displaying the interaction system (balls and blocks)
    drawShooter();  // drawing the shooter
    
  // screen = game over
  } else if (screen == 3){  
    drawGameScreen();  // calling function to redraw the 'box', score/round, and top score
    System.display();  // still draw the next block locations (to we see the blocks reach the ground)
    displayGameOver();  // calling function to display the game over box
  }

  setCursor();  // calling function to change the cursor to a hand when hovering over clickable areas
}


/* ---------------------------------------------- CLASSES ----------------------------------------------- */

// Ball class
class Ball {
  float x, y;  // x and y positions of the ball
  float r = ballRadius;  // radius of the ball
  float xSpeed = 6;  // speed of the ball in the x direction
  float ySpeed = 6;  // speed of the ball in the y direction
  float a;  // angle of the ball

  // Ball constructor
  Ball(float angle) {
    x = width/2;  // setting initial x position to current x position of the ball
    y = height - offset - r/2;  // setting initial y position to bottom of rectangle
    a = angle;  // balls will received angle attributes
  }
  
  // Function to get the current row (in the 'grid') the ball is in based on its y position
  int currentRow(){
    return (round(y-offsetTop)/60);
  }
  
  // Function to get the current column (in the 'grid') the ball is in based on its x position
  int currentColumn(){
    return (round(x-offset)/60);
  }
  
  // Function to get the next row (in the 'grid') the ball will be in based on its y position
  int nextRow(){
    return (round(y-offsetTop+ySpeed*sin(a))/60);
  }
  
  // Function to get the next column (in the 'grid') the ball will be in based on its x position
  int nextColumn(){
    return (round(x-offset+xSpeed*cos(a))/60);
  }

  // Function to reflect balls upon collision with blocks
  void blockCollision() {
    // in the y direction
    if(currentRow() != nextRow()){
      ySpeed = ySpeed*-1;
    }
    // in the x direction
    if(currentColumn() != nextColumn()){
      xSpeed = xSpeed*-1;
    }
  }
  
  // Function to return Boolean on whether or not the ball should be deleted (true if collides with ground, false otherwise)
  boolean checkWallCollision() {
    
    // Checking side collisions
    if (x - r/2 < offset || x + r/2 > width-offset){
      xSpeed = xSpeed*-1;
    }
    
    // Checking top collision
    if (y - r/2 < offsetTop){
      ySpeed = ySpeed*-1;
    }
    
    // Checking bottom collision
    if (y + r/2 > height-offset){
      return true;
    }
    
    return false;
  }
  
  // Function to move the balls by increment the x and y position based on the angle
  void move(){
    x+=xSpeed*cos(a);
    y+=ySpeed*sin(a);
  }
  
  // Function to display the ball
  void display(){
    push();
    stroke(255);
    fill(255);
    ellipse(x, y, r, r);
    pop();
  }
}


// Block class (constructed as a grid)
class BlockGrid {
  int blocks[][];  // creating 2D array variable
  int s = 60;  // size of each side of the grid/block
  
  // Block constructor
  BlockGrid(){
    blocks = new int[10][7];  // 10 rows and 7 columns
  }
  
  // Function to set the number inside the block
  void setBlock(int row, int col, int num) { 
    blocks[row][col] = num;
  }
  
  // Function to get the number inside the block
  int getBlock(int row, int col){
    return blocks[row][col];
  }
  
  // Function to subtract the number inside the block by 1 (called when a ball collides with it)
  void blockHit(int row, int col){
    blocks[row][col] = blocks[row][col] - 1;
  }
  
  // Function to display the blocks
  void display() {
    for(int i = 0; i < 10; i++){  // loop through each row
      for(int j = 0; j < 7; j++){  // loop through each column
        if(blocks[i][j] > 0){
          color c = 20;  // initializing with background color
          
          // condition to color blocks based on the number inside relative to the round
          if(blocks[i][j] == 1 || blocks[i][j] < round/8){
            c = color(50, 150, 245);  // blue
          } else if(blocks[i][j] < round/4){
            c = color(40, 180, 40);  // green
          } else if(blocks[i][j] >= round/4 && blocks[i][j] < round/2){
            c = color(230, 180, 25);  // yellow
          } else if(blocks[i][j] >= round/2 && blocks[i][j] < 3*round/4){
            c = color(240, 105, 30);  // orange
          } else if(blocks[i][j] >= 3*round/4 && blocks[i][j] < round){
            c = color(235, 30, 50);  // red
          } else if(blocks[i][j] == round){
            c = color(245, 30, 115);  // pink
          }
          
          // drawing the block with the text inside the block
          push();
          stroke(c);
          strokeWeight(3);
          noFill();
          rectMode(CENTER);
          rect(offset + s*j + s/2, offsetTop + s*i + s/2, s-8, s-8);
          textSize(22);
          textAlign(CENTER, CENTER);
          fill(c);
          text(blocks[i][j], offset + s*j + s/2, offsetTop + s*i + s/2 - 2);
          pop();
        }
      }
    }
  }
} 

// Interaction system class
class InteractionSystem {
  ArrayList<Ball> Balls;  // declaring the ArrayList to store the balls
  BlockGrid grid;  // declaring the grid
  int ballCounter;  // variable to count the number of balls that have been "shot" (added to the ArrayList)
  
  // Interaction system constructor
  InteractionSystem() {
    Balls = new ArrayList<Ball>();    // construct the ball ArrayList
    grid = new BlockGrid();  // construct the grid og blocks
    ballCounter = 0;  // initialized the ball counter at 0 (no balls shot)
  }
  
  // Function to add ball to the ArrayList (when the function to shoot is called)
  void addBall(float angle) {
    Balls.add(new Ball(angle));
  }
  
  // Function to shoot the balls
  void shootBalls(){
    if(ballCounter < round && frameCount % 9 == 0){  // every 9 frameCounts
      addBall(mouseAngle);  // add a ball to the ArrayList (shoot the ball)
      ballCounter++;  // increment the ball counter by 1
    }
  }
  
  // Function to check ball collision with the blocks
  void checkBlockCollision() {
    for(Ball b: Balls){  // loop through each ball
      if(grid.getBlock(b.nextRow(), b.nextColumn()) > 0){  // check if there is a block in the grid direction that the ball is heading 
        grid.blockHit(b.nextRow(), b.nextColumn());  // if yes, the block is declared as hit
        hitSound.play();  // block collision sound is played
        b.blockCollision();  // function to reflect the ball upon collision is called
      }
    }
  }
  
  // Function to add a row of blocks
  void addBlocks() {
    int[] numbers = {0, round};  // array storing a 0 and the rcurrent ound number
    
    for(int i = 0; i < 7; i++){  // loop through each column in the second row from the top
      grid.setBlock(1, i, numbers[(int) random(0, 2)]);  // randomly assign a 0 or the round number to the block
    }
    
    // Calculates sum of the row in the first round and re-runs the function to add a row of blocks if there are no blocks in the first round
    if(round == 1){  //
      int rowSum = 0;  // initiating the row sum to zero
      for(int i = 0; i < 7; i++){  // loop through each column in the second row from the top
        rowSum+=grid.blocks[1][i];  // summing up the values in the block
      } 
      if(rowSum == 0){  // if the sum is 0, there are no blocks (each block in the first round equals 1)
        addBlocks();  // the function to add blocks is called again
      }
    }
  }
  
  // Function to move blocks down one row
  void moveBlocks() {
    for(int i = 9; i > 0; i--){  // loop through each row from the bottom to top
      for(int j = 6; j > -1; j--){  // loop through each column
        grid.blocks[i][j] = grid.blocks[i - 1][j];  // the current block becomes the one above
      }
    }
  }
  
  // Function to check if any blocks hit the ground (game over)
  void checkGameOver() {
    for(int i = 0; i < 7; i++){  // loop through each column
      if(grid.blocks[9][i] != 0){  // check every column in the last (bottommost) row
        gameOver = true;
      }
    }
  }
  
  // Funtion to display the system
  void display() {
    grid.display();  // display the grid of blocks
    checkBlockCollision();  // calling the function to check ball collision with the blocks
    
    for(int i = 0; i < Balls.size(); i++){  // loop through each ball in the ArrayList
      Ball b = Balls.get(i);  // get the ball object
      b.move();  // move the ball
      if (b.checkWallCollision()){  // check each ball for collision with walls (true = hit ground, false = hit sides and top so it reflects)
        Balls.remove(i);  // remove the ball if it hit the ground
        
        if (Balls.size() == 0){  // if there are no balls left in the ArrayList (all the balls have hit the ground)
          ballCounter = 0;  // reset the ball counter to 0
          round++;  // increment the round by 1
          moveBlocks();  // calling function to move blocks down one row
          
          if(topScore < round){  // checking if the top score (previous highscore) if less than the round
            topScore = round;  // set the top score to the round if it is
          }
          
          checkGameOver();  // calling function to check if any blocks hit the ground
          
          // Statement to check if the game is over
          if(gameOver){
            gameOverSound.play();   // game over sound is played
            round--;
            
            // Statement to check if the game highscore (topScore) is higher than the stored highscore and rewrite new highscore to file if it is
            if(topScore >= highscore){
              topScore = round;
              newHighscore = createWriter("highscore.txt");
              newHighscore.println(topScore);
              newHighscore.flush();
              newHighscore.close();
            }
            
            fill(20);
            rect(offset, offsetTop, width-offset*2, height-offset*4);  // redraw box
            grid.display();  // display the grid of blocks
            canShoot = false;
            shooting = false;
            screen = 3;  // switch to the game over screen
            
          } else {
            addBlocks();  // add blocks if the game isn't over
            canShoot = true;
            shooting = false;
          }          
        }
      }
      b.display();  // display the balls
    }
  }
}


/* ------------------------------- GAME MECHANICS/INTERACTIVITY FUNCTIONS ------------------------------- */

// Function to get the angle to shoot the ball based on the mouseX and mouseY positions
void getAngle() {
  float opp = height-offset-mouseY; // variable to store the opposite (Y) length 
  float adj; // variable to store and adjacent (X) length
  
  // limiting the minimum angle the balls can be shot at byt setting a default opposite length if the angle is too small
  if(mouseY < height - offset && mouseY > height - offset - 20){
    opp = height-mouseY;
  }
  
  // Conditions to set the adjacent lengths depending on the X position of the mouse
  if(mouseX > width/2){  // if mouse is on the right side of the screen
    adj = mouseX - width/2;
    mouseAngle = -atan(opp/adj);
  } else if (mouseX < width/2) {  // if mouse is on the left side of the screen
    adj = width/2 - mouseX;
    mouseAngle = -(PI- atan(opp/adj));
  } else if (mouseX == width/2){  // if mouse position is exactly 90 degrees (points diretly up)
    mouseAngle = -PI/2;
  }
}

// Function to restart the game
void restartGame() {
  gameOver = false;  // reset game over to false
  canShoot = true;
  shooting = false;
  round = 1;  // reset round to 1
  
  // reread the highscore text file (incase it got updated)
  highscoreReader = createReader("highscore.txt");
  String line;
  try {
    line = highscoreReader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  highscore = Integer.parseInt(line);  // casting the line read to integer
  topScore = highscore;  // defining the topScore as the highscore
  
  System = new InteractionSystem();  // initiating new interaction system
  System.addBlocks();  // adding new blocks
}

// Function to change the cursor when hovering over clickable areas
void setCursor() {
  // In the main menu 
  if(screen == 0){
    if(mouseX > 67.5 && mouseX < 222.5 && mouseY > 597.5 && mouseY < 672.5){  // mouse is on the left button (to go to instructions page)
      cursor(HAND);
    } else if(mouseX > 257.5 && mouseX < 412.5 && mouseY > 597.5 && mouseY < 672.5){  // mouse if on the right button (to start the game)
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  
  // In the instructions page
  } else if (screen == 1 && dist(mouseX, mouseY, 451, 40) < 12){  // mouse is on the red close window circle with an "X"
    cursor(HAND);
  
  // In the game page
  } else if (screen == 2 && mouseX > offset && mouseX < width - offset && mouseY > offsetTop && mouseY < height - offset) {  // mouse is inside the 'box'
    cursor(HAND);
    
  // Over the game over box
  } else if (screen == 3){
    if(mouseX > 140 && mouseX < 220 && mouseY > 430 && mouseY < 470){  // yes button
      cursor(HAND);
    } else if (mouseX > 270 && mouseX < 350 && mouseY > 430 && mouseY < 470){  // no button
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  } else {
    cursor(ARROW);
  }
}

// Function to perform actions when the mouse is clicked
void mouseClicked() {
  // In the main menu 
  if(screen == 0){
    if(mouseX > 67.5 && mouseX < 222.5 && mouseY > 597.5 && mouseY < 672.5){  //
      buttonSound.play();  // play button click sound
      screen = 1;  // switch to the instructions screen
    } else if(mouseX > 257.5 && mouseX < 412.5 && mouseY > 597.5 && mouseY < 672.5){
      buttonSound.play();  // play button click sound
      System = new InteractionSystem();  // initiating interaction system
      System.addBlocks();  // adding new blocks
      screen = 2;  // switch to the game screen
    }
    return;
  
  // In the instructions page
  } else if ( screen == 1 && dist(mouseX, mouseY, 451, 40) < 12){
      buttonSound.play();  // play button click sound
      screen = 0;  // go back to main menu
      
  // When the game over box is displayed
  } else if(screen == 3) {
    if(mouseX > 140 && mouseX < 220 && mouseY > 430 && mouseY < 470){  // yes button
      buttonSound.play();  // play button click sound
      restartGame();  // calling function to restart the game
      screen = 2;  // go back to game page
      return;
    } else if (mouseX > 270 && mouseX < 350 && mouseY > 430 && mouseY < 470){
      buttonSound.play();  // play button click sound
      restartGame();  // calling function to restart the game
      screen = 0;  // go back to main menu
      return;
    }
  }
  
  // To only shoot when the click happens inside the 'box' in the game screen
  if (canShoot){   
    if(mouseX > offset && mouseX < width - offset && mouseY > offsetTop && mouseY < height - offset){
      getAngle();  // get the angle based on the mouse position 
      canShoot = false;  // can no longer click to initiate shooting again
      shooting = true;  // indicate that balls are currently shooting
    }
  }
}


/* ------------------- FUNCTIONS USED TO DEFINE/DRAW EACH SCREEN (DISPLAY AESTHETICS) ------------------- */

// Function to draw the main menu
void mainMenu() {
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(30);
  text("--------------------", width/2, height/2 - 300);  // top dotted line
  textSize(128);
  text("BBTan", width/2, height/2 - 240);  // BBTan title
  textSize(30);
  text("Knockoff-------------", width/2, height/2 - 160);  // bottom text with the dotted line
  imageMode(CENTER);
  image(BBTan, width/2, height/2 + 40, 390*0.6, 540*0.6);  // displaying the loaded image of my drawing
  ellipse(320, 545, 20, 20);  // drawing the BBTan ball next to the image
  
  // drawing the buttons
  push();
  translate(width/2, height/2);
  rectMode(CENTER);
  stroke(255);
  strokeWeight(3);
  fill(20);
  rect(-95, 275, 155, 75);  // rectangle button on the left
  rect(95, 275, 155, 75);  // rectangle button on the right
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(48);
  text("?", -95, 270);  // text in left rectangle button (takes you to the instructions screen)
  text("PLAY", 95, 270);  // text in right rectangle button (takes you to the game screen)
  pop();
}

// Function to display the instruction screen
void instructions() {
  push();
  translate(width/2, height/2);
  rectMode(CENTER);
  fill(20);
  stroke(255);
  strokeWeight(3);
  rect(0, 0, 420, 640);
  fill(235, 30, 50);
  stroke(235, 30, 50);
  ellipse(210, -320, 24, 24);  // button to close the instruction screen
  textAlign(CENTER, CENTER);
  textSize(28);
  fill(20);
  text("x", 211, -326);
  pop();
  
  // titles of the instruction screen
  push();
  fill(240, 190, 25);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("CONTROLS", width/2, 80);
  text("INTRUCTIONS", width/2, 250);

  // desription of controls and instructions
  fill(255);
  textAlign(LEFT, TOP);
  textSize(28);
  text("1. Move the mouse to aim", 55, 120);
  text("2. Click to shoot", 55, 160);
  textSize(22);
  text("• Hit the blocks to break them", 55, 290, 400, 40);
  text("• Don't let the blocks touch the ground", 55, 335, 400, 60);
  text("• The number inside the block is how many times it has to be hit", 55, 412, 400, 60);
  text("• You have as many balls as the round you are in", 55, 493, 400, 80);
  text("• Your score is the number of rounds you survive", 55, 574, 400, 80);
  pop();
}

// Function to draw the game screen
void drawGameScreen() {
  fill(20);
  stroke(255);
  strokeWeight(3);
  rect(offset, offsetTop, width-offset*2, height-offset*4);  // the box the grid is 'contained' within
  
  textSize(45);
  textAlign(CENTER, CENTER);
  fill(255);
  text(round, width/2, offsetTop/2);  // displays the round number in the top center
  
  push();
  textSize(28);
  textAlign(RIGHT, CENTER);
  text("Top: " + topScore, width - 30, offsetTop/2 - 10);  // displays the top score in the top right corner
  pop();
}

// Function to draw the shooter
void drawShooter() {
  float opp = height-offset-mouseY; // variable to store the opposite (Y) length 
  float adj; // variable to store and adjacent (X) length
  
  push();
  translate(width/2, height - offset - ballRadius/2);  // translate origin to where the center of the ball in the bottom middle of the screen is
  
  // Conditions to set the adjacent lengths depending on the X position of the mouse
  if(mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height - offset - 20){  // if mouse position is within the box
     if(mouseX > width/2){  // if mouse is on the right side of the screen 
     adj = mouseX - width/2;
     shooterAngle = -atan(opp/adj);
   } else if (mouseX < width/2) {  // if mouse is on the left side of the screen
     adj = width/2 - mouseX;
     shooterAngle = -(PI- atan(opp/adj));
   } else if (mouseX == width/2){  // if mouse is at exactly 90 degrees (points directly up)
     shooterAngle = -PI/2;
   }
  }
  
  rotate(shooterAngle + PI/2);  // rotate shooter by the angle + PI/2 (because of the direction the line below is drawn)
  stroke(255);
  strokeWeight(30);
  line(0, ballRadius/2, 0, -20);  // draw (thick) line as shooter
  pop();
  
  stroke(255);
  fill(20);
  ellipse(width/2, height - offset, 50, 50);  // round 'body' of the shooter
}

// Function to display the game over 'screen' (more like box)
void displayGameOver() {
  // displaying 'GAME OVER', the score and 'play again?'
  fill(20);
  rect(width/2 - 165, height/2 - 100, 330, 225);
  fill(255);
  noStroke();
  rect(width/2 - 158, height/2 - 93, 316, 160);
  textAlign(CENTER, CENTER);
  fill(235, 30, 50);
  textSize(50);
  text("GAME OVER", width/2, height/2 - 65);
  fill(20);
  textSize(30);
  text("score: " + round, width/2, height/2 - 15);
  text("play again?", width/2, height/2 + 25);
  
  // displaying the buttons to select yes or no
  push();
  fill(255);
  stroke(20);
  translate(width/2, height/2);
  rectMode(CENTER);
  rect(-70, 95, 80, 50);  // button for yes
  rect(70, 95, 80, 50);  // button for no
  fill(20);
  text("yes", -70, 90);
  text("no", 70, 90);
  pop();
}
