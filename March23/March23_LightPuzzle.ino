/*
Assignment 5: Momentary Switch Light Puzzle
 Intro to IM
 Due: Tuesday March 23
 Written by Ariya Chaloemtoem
 */

// declaring the variables
const int greenLED1 = 3;  // the first green LED
const int greenLED2 = 5;  // the second green LED
const int greenLED3 = 7;  // the third green LED
const int redSwitch = A0;  // the red switch
const int blueSwitch = A2;  // the blue switch
const int yellowSwitch = A4;  // the yellow switch

// the setup function runs once when reset is pressed or the board is powered
void setup() {
  pinMode(13, OUTPUT);  // making the arduino LED an output as an easy check that the arduino is connected and program is working

  // setting all the LEDs as outputs
  pinMode(greenLED1, OUTPUT);
  pinMode(greenLED2, OUTPUT);
  pinMode(greenLED3, OUTPUT);

  // setting all the switched as inputs
  pinMode(redSwitch, INPUT);
  pinMode(blueSwitch, INPUT);
  pinMode(yellowSwitch, INPUT);
}

// the loop function runs over and over again
void loop() {
  digitalWrite(13, HIGH); // the arduino LED is set to always on

  // reading the value from the pin specified by each switch
  int switch1Position = digitalRead(yellowSwitch);
  int switch2Position = digitalRead(blueSwitch);
  int switch3Position = digitalRead(redSwitch);

  // setting puzzle parameters based on the value of the switch
  // since there are 3 switches with two states (on or off), there are a total of 8 combinations of the states
  if (switch1Position == HIGH && switch2Position == LOW && switch3Position == LOW) {
    // first LED is off, second and third blinks slowly
    digitalWrite(greenLED1, LOW);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(400);
    digitalWrite(greenLED2, LOW);
    digitalWrite(greenLED3, LOW);
    delay(400);
  } else if (switch1Position == HIGH && switch2Position == LOW && switch3Position == HIGH) {
    // first LED is off, third LED is on, second blinks a bit faster
    digitalWrite(greenLED1, LOW);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(100);
    digitalWrite(greenLED2, LOW);
    delay(100);
  } else if (switch1Position == HIGH && switch2Position == HIGH && switch3Position == LOW) {
    // first LED is off, second LED is on, third blinks as fast as last condition
    digitalWrite(greenLED1, LOW);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(100);
    digitalWrite(greenLED3, LOW);
    delay(100);
  } else if (switch1Position == HIGH && switch2Position == HIGH && switch3Position == HIGH) {
    // first LED blinks very fast, second and third is completely on
    digitalWrite(greenLED1, HIGH);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(50);
    digitalWrite(greenLED1, LOW);
    delay(50);
  } else if (switch1Position == LOW && switch2Position == LOW && switch3Position == HIGH) {
    // first and third LED is on, second blinks quite fast
    digitalWrite(greenLED1, HIGH);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(100);
    digitalWrite(greenLED2, LOW);
    delay(100);
  } else if (switch1Position == LOW && switch2Position == HIGH && switch3Position == LOW) {
    // first and second LED is on, third blinks as fast as last the condition
    digitalWrite(greenLED1, HIGH);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
    delay(100);
    digitalWrite(greenLED3, LOW);
    delay(100);
  } else if (switch1Position == LOW && switch2Position == HIGH && switch3Position == HIGH) {
    // all LEDs are on (puzzle solved)
    digitalWrite(greenLED1, HIGH);
    digitalWrite(greenLED2, HIGH);
    digitalWrite(greenLED3, HIGH);
  } else {
    // all LEDs are off because no switches are pressed
    digitalWrite(greenLED1, LOW);
    digitalWrite(greenLED2, LOW);
    digitalWrite(greenLED3, LOW);
  }
}
