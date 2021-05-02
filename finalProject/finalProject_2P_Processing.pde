/*
Final Project: Two-Player *Car/Boat* Racing Game (Processing Code)
 Intro to IM
 Due: Thursday April 29
 Written by Ariya Chaloemtoem
 */

import processing.serial.*; // import serial library
Serial myPort;  // create object from serial class

// screen-related variable
int screen = 0;  // tells us which screen we are in (0 = main menu, 1 = instructions, 2 = game, 3 = score)

// Boolean variables to tell processing the player should be acceleration
int player1Acc, player2Acc;

// Variables to store the position, speed, velocity and acceleration of each player
// Unique to Player 1
float xPos1, yPos1;  // position of dart
float yVU1 = 0;  // velocity upwards
float yVD1 = 0;  // velocity downwards
//Unique to Player 2
float xPos2, yPos2;  // position of dart
float yVU2 = 0;  // velocity upwards
float yVD2 = 0;  // velocity downwards
// Shared by both
float yAccU = 1.8;  // upwards acceleration
float yAccD = 1.8;  // downwards acceleration

// Score-related variables
int player1Score;  // score of player 1
int player2Score;  // score of player 2

// Declaring PImage class for the dartBoard in the main home-screen
PImage dartBoard;

// Declaring variable to store time information
int gameTime = 0;  // how much game time has passed
int framesPassed = frameCount;  // how many frames have passed

// Sound-related variables
import processing.sound.*;  // importing sound library
SoundFile buttonSound, winSound, bgMusic;

/* -------------------------------------- SETUP AND DRAW FUNCTIONS -------------------------------------- */

void setup() {
  size(600, 724);

  dartBoard = loadImage("dartsPic.png");  // loading dart board image

  buttonSound = new SoundFile(this, "buttonSound.mp3");  // load sound file for when button is clicked
  winSound = new SoundFile(this, "winSound.mp3");  // load sound file for when game ends
  bgMusic = new SoundFile(this, "bgMusic.mp3");  // load sound file for background music

  // setting initial position of player 1's dart
  xPos1 = width/4;
  yPos1 = height - 64;

  // setting initial position of player 2's dart
  xPos2 = 3*width/4;
  yPos2 = height - 64;

  printArray(Serial.list());  // list all the available serial ports
  String portname=Serial.list()[7];  // select the serial port
  println(portname);
  myPort = new Serial(this, portname, 9600); // open the port at the same rate as Arduino
  myPort.clear();
  myPort.bufferUntil('\n');  // receive signal to start communications from Arduino
}

void draw() {
  background(255);  // background is white

  // Conditions for what to display based on the screen variable
  // screen = main menu
  if (screen == 0) {
    mainMenu();  // calling function to display the main menu

    // screen = intructions
  } else if (screen == 1) {
    instructions();  // calling function to display the instructions

    //screen = the game
  } else if (screen == 2) {
    drawBoard();  // calling function to draw the baord
    drawGame();  // calling function to draw the darts
    keepScore();  // calling function to compute and display the score
    displayTime();  // calling function to display the time

    // screen = game over
  } else if (screen == 3) {
    bgMusic.stop();  // stop the music that is currently playing
    drawBoard();  // calling function to redraw the 'box', score/round, and top score
    displayScore();  // display the score still

    // to delay the winner box being display by a little bit
    if (frameCount - framesPassed < 20) {
      displayTime();  // still display the time for a bit
    } else {
      displayWinner();  // calling function to display the winner result
    }
  }

  setCursor();  // calling function to change the cursor to a hand when hovering over clickable areas
}

/* -------------------------------------- SERIAL PORT COMMUNICATION -------------------------------------- */

// function to receive serial input from Arduino when data is available
void serialEvent(Serial myPort) {
  String s = myPort.readStringUntil('\n');  // read the whole string
  s = trim(s);  // remove unwanted characters

  // statement to obtain the values
  if (s != null) {
    int values[] = int(split(s, ','));  // split the string by ','
    if (values.length == 2) {
      player1Acc = (int)values[0];  // grab value to tell how player 1 should accelerate
      player2Acc = (int)values[1];  // grab value to tell how player 2 should accelerate
    }
  }

  myPort.write("\n");  // signal back to Arduino
}

/* ------------------------------- GAME MECHANICS/INTERACTIVITY FUNCTIONS ------------------------------- */

// Function to change the cursor when hovering over clickable areas
void setCursor() {
  // In the main menu 
  if (screen == 0) {
    if (mouseX > 119.5 && mouseX < 272.5 && mouseY > 599.5 && mouseY < 674.5) {  // mouse is on the left button (to go to instructions page)
      cursor(HAND);
    } else if (mouseX > 327.5 && mouseX < 482.5 && mouseY > 599.5 && mouseY < 674.5) {  // mouse if on the right button (to start the game)
      cursor(HAND);
    } else {
      cursor(ARROW);
    }

    // In the instructions page
  } else if (screen == 1 && dist(mouseX, mouseY, 541, 40) < 12) {  // mouse is on the red close window circle with an "X"
    cursor(HAND);

    // In the game page
  } else if (screen == 2) {  // don't show the cursor
    noCursor();

    // Over the winner result box
  } else if (screen == 3) {
    if (mouseX > 190 && mouseX < 270 && mouseY > 432 && mouseY < 482) {  // yes button
      cursor(HAND);
    } else if (mouseX > 330 && mouseX < 410 && mouseY > 432 && mouseY < 482) {  // no button
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
  if (screen == 0) {
    if (mouseX > 119.5 && mouseX < 272.5 && mouseY > 599.5 && mouseY < 674.5) {  // player clicked on the left button (to go to instructions page)
      buttonSound.play();  // play button click sound
      screen = 1;  // switch to the instructions screen
    } else if (mouseX > 327.5 && mouseX < 482.5 && mouseY > 599.5 && mouseY < 674.5) {  // player clicked on the right button (to start the game)
      buttonSound.play();  // play button click sound
      bgMusic.play();  // start playing the game background music
      screen = 2;  // switch to the game screen
    }
    return;

    // In the instructions page
  } else if ( screen == 1 && dist(mouseX, mouseY, 541, 40) < 12) {  // player clicked on the "X" to close the instructions page
    buttonSound.play();  // play button click sound
    screen = 0;  // go back to main menu

    // When the game over box is displayed
  } else if (screen == 3) {
    if (mouseX > 190 && mouseX < 270 && mouseY > 432 && mouseY < 482) {  // player clicked on the yes button
      buttonSound.play();  // play button click sound
      bgMusic.play();  // start playing the game background music again
      restartGame();  // reset all game parameters
      screen = 2;  // go back to game page
      return;
    } else if (mouseX > 330 && mouseX < 410 && mouseY > 432 && mouseY < 482) {  // player clicked on the no button
      buttonSound.play();  // play button click sound
      restartGame();  // reset all game parameters
      screen = 0;  // go back to main menu
      return;
    }
  }
}

// Function to control each player's movement
void drawGame() {
  push();
  stroke(255, 0, 0);  // red stroke
  strokeWeight(3);
  fill(0);  // black fill
  ellipse(xPos1, yPos1, 30, 30);  // drawing player 1's dart
  ellipse(xPos2, yPos2, 30, 30);  // drawing player 2's dart
  pop();

  // statement to control movement of player 1's dart
  if (player1Acc == 1) {  // if value from arduino says to accelerate up
    yVD1 = 0;  // downwards acceleration is 0
    if (yPos1 <= 89) {  // don't move if already at the top of the board
      yPos1 = 89;
      yVU1 = 0;
    } else {
      yVU1 += yAccU;  // otherwise accelerate up
    }
    yPos1 -= yVU1;  // update the position of the dart
  } else if (player1Acc == 0) {  // if value from arduino says to accelerate down
    yVU1 = 0;
    if (yPos1 >= height - 27) {  // don't move if already at the bottom of the board
      yPos1 = height - 27;
      yVD1 = 0;
    } else {
      yVD1 += yAccD;  // otherwise accelerate down
    }
    yPos1 += yVD1;  // update the position of the dart
  }

  // statement to control mvoement of player 1's dart
  if (player2Acc == 1) { // if value from arduino says to accelerate up
    yVD2 = 0;  // downwards acceleration is 0
    if (yPos2 <= 89) {  // don't move if already at the top of the board
      yPos2 = 89;
      yVU2 = 0;
    } else {
      yVU2 += yAccU;  // otherwise accelerate up
    }
    yPos2 -= yVU2;  // update the position of the dart
  } else if (player2Acc == 0) {  // if value from arduino says to accelerate down
    yVU2 = 0;
    if (yPos2 >= height - 27) {  // don't move if already at the bottom of the board
      yPos2 = height - 27;
      yVD2 = 0;
    } else {
      yVD2 += yAccD;  // otherwise accelerate down
    }
    yPos2 += yVD2;  // update the position of the dart
  }
}

// Function to determine the score
void scoringSystem() {
  // In order of the if else statements:
  // 25 points if in the bullseye layer
  // 10 points if in the outer bullseye layer
  // 3 points if in the beige and black layer outside of that
  // 5 points if in the first green and red layer
  // 2 points if in the next beige and black layer
  // 1 points if in the outer most green and red layer

  // For player 1
  if (yPos1 > height/2 - 12 && yPos1 < height/2 + 12) {
    player1Score = player1Score + 25;
  } else if ((yPos1 > height/2 - 50 && yPos1 < height/2 - 12) || (yPos1 > height/2 + 12 && yPos1 < height/2 + 50)) {
    player1Score = player1Score + 10;
  } else if ((yPos1 > height/2 - 134 && yPos1 < height/2 - 50) || (yPos1 > height/2 + 50 && yPos1 < height/2 + 134)) {
    player1Score = player1Score + 3;
  } else if ((yPos1 > height/2 - 172 && yPos1 < height/2 - 134) || (yPos1 > height/2 + 134 && yPos1 < height/2 + 172)) {
    player1Score = player1Score + 5;
  } else if ((yPos1 > height/2 - 256 && yPos1 < height/2 - 172) || (yPos1 > height/2 + 172 && yPos1 < height/2 + 256)) {
    player1Score = player1Score + 2;
  } else if ((yPos1 > height/2 - 294 && yPos1 < height/2 - 256) || (yPos1 > height/2 + 256 && yPos1 < height/2 + 294)) {
    player1Score = player1Score + 1;
  }

  // For player 2
  if (yPos2 > height/2 - 12 && yPos2 < height/2 + 12) {
    player2Score = player2Score + 25;
  } else if ((yPos2 > height/2 - 50 && yPos2 <= height/2 - 12) || (yPos2 >= height/2 + 12 && yPos2 < height/2 + 50)) {
    player2Score = player2Score + 10;
  } else if ((yPos2 > height/2 - 134 && yPos2 <= height/2 - 50) || (yPos2 >= height/2 + 50 && yPos2 < height/2 + 134)) {
    player2Score = player2Score + 3;
  } else if ((yPos2 > height/2 - 172 && yPos2 <= height/2 - 134) || (yPos2 >= height/2 + 134 && yPos2 < height/2 + 172)) {
    player2Score = player2Score + 5;
  } else if ((yPos2 > height/2 - 256 && yPos2 <= height/2 - 172) || (yPos2 >= height/2 + 172 && yPos2 < height/2 + 256)) {
    player2Score = player2Score + 2;
  } else if ((yPos2 > height/2 - 294 && yPos2 <= height/2 - 256) || (yPos2 >= height/2 + 256 && yPos2 < height/2 + 294)) {
    player2Score = player2Score + 1;
  }
}

// Function to keep score of each player
void keepScore() {

  // score is kept only while game is running
  // statement to keep track of the game running
  if (frameCount % 60 == 0 && gameTime < 20) {
    gameTime++;  // continue running and counting if 20 seconds hasn't passed
  } else if (gameTime == 20) {  // once 20 seconds has passed
    framesPassed = frameCount;  // store the frameCount
    winSound.play();  // play the winner sound effect
    screen = 3;  // display winner box
  }

  // add score every half a second
  if (frameCount % 30 == 0 && gameTime < 20) {
    scoringSystem();  // calling function to determine the score
  }

  displayScore();  // calling function to display the score on the screen
}

// Function to reset parameters when restarting the game
void restartGame() {
  gameTime = 0;  // set game time back to 0

  // reset scores
  player1Score = 0;
  player2Score = 0;

  // reset dart positions
  yPos1 = height - 64;
  yPos2 = height - 64;
}

/* ------------------- FUNCTIONS USED TO DEFINE/DRAW EACH SCREEN (DISPLAY AESTHETICS) ------------------- */

// Function to draw the main menu
void mainMenu() {
  background(#141414);
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(32);
  text("---------------------", width/2, height/2 - 335);  // top dotted line
  textSize(148);
  text("Darts", width/2, height/2 - 270);  // Darts title
  textSize(32);
  text("Deconstructed---------", width/2, height/2 - 175);  // bottom text with the dotted line
  imageMode(CENTER);
  image(dartBoard, width/2, height/2 + 35, 290, 290);  // displaying the loaded image of my drawing

  // drawing the buttons
  push();
  translate(width/2, height/2);
  rectMode(CENTER);
  stroke(255);
  strokeWeight(3);
  fill(#141414);
  rect(-105, 275, 155, 75);  // rectangle button on the left
  rect(105, 275, 155, 75);  // rectangle button on the right
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(48);
  text("?", -105, 270);  // text in left rectangle button (takes you to the instructions screen)
  text("PLAY", 105, 270);  // text in right rectangle button (takes you to the game screen)
  pop();
}

// Function to display the instruction screen
void instructions() {
  background(#141414);
  push();
  translate(width/2, height/2);
  rectMode(CENTER);
  fill(#141414);
  stroke(255);
  strokeWeight(3);
  rect(0, 0, 480, 640); // rectangle the instructions is in
  fill(#E3292E);
  stroke(235, 30, 50);
  ellipse(240, -320, 24, 24);  // button to close the instruction screen
  textAlign(CENTER, CENTER);
  textSize(28);
  fill(20);
  text("x", 241, -326);
  pop();

  // titles of the instruction screen
  push();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(22);
  text("This is a two-player game.", width/2, 80);
  fill(#309F6A);
  textSize(36);
  text("CONTROLS", width/2, 150);
  text("INTRUCTIONS", width/2, 350);

  // desription of controls and instructions
  fill(255);
  textSize(22);
  textAlign(LEFT, TOP);
  text("1. Each player controls one switch", 80, 190);
  text("2. Hold switch to accelerate up", 80, 230);
  text("3. Let go to fall down", 80, 270);
  text("• Score as many points as possible in 20 seconds.", 80, 390, 440, 60);
  text("• Your position on the board every half a second determines the number of points you will get.", 80, 460, 440, 100);
  text("• From the center layer outwards, 25, 10, 3, 5, 2, and 1 point(s) will be added to your score.", 80, 565, 440, 100);
  pop();
}

// function to draw the game board
void drawBoard() {
  push();
  translate(0, 10);
  // red in the middle
  noStroke();
  fill(#E3292E);  // red
  rect(0, height/2 - 12, width, 24);

  // surrounding layer of greens
  fill(#309F6A);  // green
  rect(0, height/2 - 50, width, 34);
  rect(0, height/2 + 16, width, 34);

  // beige and black layer 1
  fill(#141414);  // black
  rect(0, height/2 - 134, width, 80);
  rect(0, height/2 + 54, width, 80);
  for (int i = 0; i < 7; i++) {
    stroke(255);
    strokeWeight(4);
    fill(#F9DFBC);  // beige
    rect((2*i + 1)*40, height/2 - 136, 40, 84);
    rect((2*i + 1)*40, height/2 + 52, 40, 84);
  }

  // green and red layer 1
  noStroke();
  fill(#E3292E);  // red
  rect(0, height/2 - 172, width, 34);
  rect(0, height/2 + 138, width, 34);
  for (int i = 0; i < 7; i++) {
    stroke(255);
    strokeWeight(4);
    fill(#309F6A);  //green
    rect((2*i + 1)*40, height/2 - 174, 40, 38);
    rect((2*i + 1)*40, height/2 + 136, 40, 38);
  }

  // beige and black layer 2
  noStroke();
  fill(#141414);  // black
  rect(0, height/2 - 256, width, 80);
  rect(0, height/2 + 176, width, 80);
  for (int i = 0; i < 7; i++) {
    stroke(255);
    strokeWeight(4);
    fill(#F9DFBC);  // beige
    rect((2*i + 1)*40, height/2 - 258, 40, 84);
    rect((2*i + 1)*40, height/2 + 174, 40, 84);
  }

  // green and red layer 2
  noStroke();
  fill(#E3292E);  // red
  rect(0, height/2 - 294, width, 34);
  rect(0, height/2 + 260, width, 34);
  for (int i = 0; i < 7; i++) {
    stroke(255);
    strokeWeight(4);
    fill(#309F6A);  //green
    rect((2*i + 1)*40, height/2 - 296, 40, 38);
    rect((2*i + 1)*40, height/2 + 258, 40, 38);
  }

  // Outer black rectangles
  noStroke();
  fill(#141414);  // black
  rect(0, height/2 - 372, width, 74);
  rect(0, height/2 + 298, width, 54);

  pop();
}

// Function to display the score
void displayScore() {
  push();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(24);
  text("Score: ", width/4 + 5, height/2 - 345);
  text("Score: ", 3*width/4 + 5, height/2 - 345);
  textSize(28);
  text(player1Score, width/4, height/2 - 315);
  text(player2Score, 3*width/4, height/2 - 315);
  pop();
}

// Function to display the time
void displayTime() {
  push();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(50);
  text(20 - gameTime, width/2, height/2 - 330);
  pop();
}

// Function to display the winner condition
void displayWinner() {
  fill(#141414);
  rect(width/2 - 175, height/2 - 100, 350, 225);
  fill(255);
  noStroke();
  rect(width/2 - 168, height/2 - 93, 336, 160);
  textAlign(CENTER, CENTER);
  fill(235, 30, 50); 
  textSize(50);
  if (player1Score > player2Score) {
    text("Player 1 Wins!", width/2, height/2 - 50);
  } else if (player1Score < player2Score) {
    text("Player 2 Wins!", width/2, height/2 - 50);
  } else if (player1Score == player2Score) {
    text("Draw!", width/2, height/2 - 50);
  }
  fill(20);
  textSize(30);
  text("play again?", width/2, height/2 + 20);

  // displaying the buttons to select yes or no
  push();
  fill(255);
  stroke(#141414);
  translate(width/2, height/2);
  rectMode(CENTER);
  rect(-70, 95, 80, 50);  // button for yes
  rect(70, 95, 80, 50);  // button for no
  fill(#141414);
  text("yes", -70, 90);
  text("no", 70, 90);
  pop();
}
