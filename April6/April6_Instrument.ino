/*
Assignment 7: Musical Instrument
 Intro to IM
 Due: Tuesday April 6
 Written by Ariya Chaloemtoem
 */

// declaring the input variables
//const int potPIN = A5; // the potentiometer
const int ldrPIN = A5;
const int greenSwitch = A3; // the green switch (default note G)
const int redSwitch = A2;  // the red switch (default note D)
const int blueSwitch = A1;  // the blue switch (default note A)
const int yellowSwitch = A0;  // the yellow switch (default note E)

// Defining note frequencies (took inspiration from notes on the violin)
int NOTE_G4 = 196;
int NOTE_D4 = 294;
int NOTE_A4 = 440;
int NOTE_E5 = 659;

// notes to play, corresponding to the 4 switches:
int notes[] = {
  NOTE_G4, NOTE_D4, NOTE_A4, NOTE_E5
};

void setup() {    
  // setting the photoresistor and all the switches as inputs
  pinMode(ldrPIN, INPUT);
  pinMode(greenSwitch, INPUT);
  pinMode(redSwitch, INPUT);
  pinMode(blueSwitch, INPUT);
  pinMode(yellowSwitch, INPUT);
}

void loop() {
  int ldrValue = analogRead(ldrPIN);  // reading input from the photoresistor
  int toneChange = map(ldrValue, 0, 1023, 400, 0);  // mapping the value
  
  // reading the value from the pin specified by each switch
  int switch1Position = digitalRead(greenSwitch);
  int switch2Position = digitalRead(redSwitch);
  int switch3Position = digitalRead(blueSwitch);
  int switch4Position = digitalRead(yellowSwitch);

  // play note depending on switch
  // changes pitch depending on value mapped from the photoresistor
  if (switch1Position == HIGH){
    tone(2, notes[0] + toneChange);
  } else if (switch2Position == HIGH){
    tone(2, notes[1] + toneChange);
  } else if (switch3Position == HIGH){
    tone(2, notes[2] + toneChange);
  } else if (switch4Position == HIGH){
    tone(2, notes[3] + toneChange);
  } else {
    noTone(2);  // don't play if nothing is pressed
  }
}
