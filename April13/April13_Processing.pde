/*
Assignment 8: Arduino-Processing Communication (Processing Code)
 Intro to IM
 Due: Tuesday April 13
 Written by Ariya Chaloemtoem
 */

import processing.serial.*; // import serial library
Serial myPort;  // create object from serial class

// declaring variables
float r;  // radius of the mold and moving circle
float xMold, yMold;  // x and y position of the mold
int xPos, yPos;  // x and y position of the moving circle
float distance;  // distance between the moving circle and the mold
int time = 60;  // time to countdown game
int score = 0;  // score
int restart = 0;  // variable to signal game restarting

void setup() {
  size(520, 520);
  
  setParameters();  // calling function to set the default parameters

  printArray(Serial.list());  // list all the available serial ports
  String portname=Serial.list()[7];  // select the serial port
  println(portname);
  myPort = new Serial(this, portname, 9600); // open the port at the same rate as Arduino
  myPort.clear();
  myPort.bufferUntil('\n');  // receive signal to start communications from Arduino
}

void draw() {
  background(0);
  textAlign(CENTER, CENTER);
  
  // condition to monitor the course of the game
  // allows for photoresistor calibration  in the first 5 seconds before game starts
  // allows the user to restart the game once time is over and reset parameters
  if (time != 0) {
    if (frameCount < 60*4) {
      fill(220,220,0);
      textSize(18);
      text("Place your finger on the photoresistor to calibrate", width/2, height/2 - 20);
    } else {
       drawGame();  // function to draw the game
       if (frameCount > 60*4 && frameCount%60 == 0) {
         time = time - 1;  // countdown every 1 second
       }
    }
  } else if (time <= 0) {
    fill(255);
    textSize(36);
    text("Score: " + score, width/2, height/2 - 50);
    textSize(20);
    text("Press both buttons to resart the game", width/2, height/2);
    if (restart == 1) {  // if restart signal is received from arduino
      setParameters();  // reset parameters
      time = 60;  // reset timer
      score = 0;  // reset score
      restart = 0;  // set restart back to 0
    }
  }
}

// function to receive serial input from Arduino when data is available
void serialEvent(Serial myPort){
  String s = myPort.readStringUntil('\n');  // read the whole string
  s = trim(s);  // remoe unwanted characters
  
  // statement to obtain the values
  if (s != null){
    println(s);
    int values[] = int(split(s,','));  // split the string by ','
    if (values.length == 3){
      xPos = (int)values[1];  // grab the horizontal movement value from Arduino
      yPos = (int)values[0];  // grab the vertical movement value from Arduino
      restart = values[2];  // obtain restart value from Arduino
    }
  }
  myPort.write("\n");  // signal back to Arduino
}

// function to set default parameters
void setParameters () {
  xPos = width/2;
  yPos = height/2;

  r = random(20, 60);
  xMold = random(r + 10, width - r - 10);
  yMold = random(r + 0, height - r - 10);
}

// function to draw the game screen
void drawGame() {
  // Mold circle
  stroke(255);
  strokeWeight(3);
  noFill();
  circle(xMold, yMold, r);

  // Moving circle
  stroke(220, 50, 50);
  fill(220, 50, 50);
  circle(xPos + (int)random(-4,4), yPos, r - 6);

  // Detect 'collision' (when the circle fits the mold)
  distance = dist(xPos, yPos, xMold, yMold);
  if (distance < 2.5) {
    score = score + 1;
    setParameters();
  }
  
  // Display the time
  fill(255);
  textSize(28);
  text(time, width/2, 20);
}
