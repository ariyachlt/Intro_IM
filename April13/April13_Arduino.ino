/*
Assignment 8: Arduino-Processing Communication (Arduino Code)
 Intro to IM
 Due: Tuesday April 13
 Written by Ariya Chaloemtoem
 */

// declaring the input variables
const int ldrPin = A5;
const int yellowSwitch = A1;
const int greenSwitch = A0;

// parameters for ldr range calibration (credits to Chinonyerem)
int ldrValue;
int ldrHigh = 0;
int ldrLow = 1023;

// variables for vall position in processing
int vertical;
int horizontal = 260;

// variable to indicate whether or not the game should restart
int restart = 0;

void setup() {
  // setting the photoresistor and switches as inputs
  pinMode(ldrPin, INPUT);
  pinMode(yellowSwitch, INPUT);
  pinMode(greenSwitch, INPUT);

  // begin serial read and initialize communication with processing
  Serial.begin(9600);
  Serial.println("0");

  // photoresistor calibration (credits to Chinonyerem)
  while (millis() < 4000) {
    ldrValue = analogRead(ldrPin); // read photoresistor value
    if (ldrValue > ldrHigh) { // calibrate upper range
      ldrHigh = ldrValue;
    }
    if (ldrValue < ldrLow) { // calibrate lower range
      ldrLow = ldrValue;
    }
  }
}

void loop() { 
  // get number of bytes (characters from the serial port if it is available
  while (Serial.available()) {
    // read incoming serial data and check if it is "\n" (new line, signal processing is ready to receive)
    if (Serial.read() == '\n') {
      ldrValue = analogRead(ldrPin);  // read photoresistor value
      if (abs(ldrHigh - ldrLow) < 350){
        vertical = map(ldrValue, 300, 650, 520, 0);
      } else {
        vertical = map(ldrValue, ldrLow, ldrHigh, 520, 0);  // map as vertical position
      }

      // make sure the vertical position isn't out of range
      if (vertical > 520) {
        vertical = 520;
      } else if (vertical < 0) {
        vertical = 0;
      }

      int yellowSwitchPos = digitalRead(yellowSwitch);  // read yellow switch value
      int greenSwitchPos = digitalRead(greenSwitch);  // read green switch value

      // condition to perform tasks based on switch position
      // if both are pressed (used in processing when the game is over)
      if (yellowSwitchPos == HIGH & greenSwitchPos == HIGH) {
        restart = 1;  // restart game
      // if yellow switch is pressed
      } else if (yellowSwitchPos == HIGH & greenSwitchPos == LOW & horizontal > 0){
        horizontal = horizontal - 2;  // move left
      // if green switch is pressed
      } else if (greenSwitchPos == HIGH & yellowSwitchPos == LOW & horizontal < 520) {
        horizontal = horizontal + 2;  // move right
      } else {  // otherwise default is to not move or signal to restart game
        horizontal = horizontal;
        restart = 0;
      }

      // print to serial port
      Serial.print(vertical);
      Serial.print(',');
      Serial.print(horizontal);
      Serial.print(',');
      Serial.println(restart);
    }
  }
}
