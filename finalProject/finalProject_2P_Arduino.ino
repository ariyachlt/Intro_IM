/*
Final Project: Two-Player *Car/Boat* Racing Game (Arduino Code)
 Intro to IM
 Due: Thursday April 29
 Written by Ariya Chaloemtoem
 */

// Player 1 switches
const int player1AccPIN = A4; // player 1 acceleration pin

// Player 2 switches
const int player2AccPIN = A1; // player 2 acceleration pin

// Variables to store value from the switches for each player
int player1AccValue, player2AccValue;

// Variables to tell processing if the player should be accelerating (0 = no, 1 = yes)
int player1Acc = 0;
int player2Acc = 0;

void setup() {
  // setting all the switch PINs as inputs
  pinMode(player1AccPIN, INPUT);
  pinMode(player2AccPIN, INPUT);
 
 
  // begin serial read and initialize communication with processing
  Serial.begin(9600);
  Serial.println("0");
}

void loop() {
  // get number of bytes (characters from the serial port if it is available
  while (Serial.available()) {
    // read incoming serial data and check if it is "\n" (new line, signal processing is ready to receive)
    if (Serial.read() == '\n') {
      
      // Player 1 movement checking
      player1AccValue = digitalRead(player1AccPIN); // read the pin value

      // acceleration is up if switch is pressed, down if not pressed
      if (player1AccValue == HIGH) {
        player1Acc = 1;
      } else {
        player1Acc = 0;
      }
    
      // Player 2 movement checking
      player2AccValue = digitalRead(player2AccPIN); // read the pin value

      // acceleration is up if switch is pressed, down if not pressed
      if (player2AccValue == HIGH) {
        player2Acc = 1;
      } else {
        player2Acc = 0;
      }
 
      // print to serial port
      Serial.print(player1Acc);
      Serial.print(',');
      Serial.println(player2Acc);
    }
  }
}
