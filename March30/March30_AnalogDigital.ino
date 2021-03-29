
// variables
const int sensorPin = A0; // the analog input pin the photoresistor is attached to
const int switchPin = A1; // the digital input pin the switch is attached to
const int greenLED1 = 1; // the pin the first green LED is attached to (will be digital output)
const int greenLED2 = 3; // the pin the second green LED is attached to (will be digital output)
const int greenLED3 = 5; // the pin the third green LED is attached to (will be digital output)
const int greenLED4 = 7; // the pin the fourth green LED is attached to (will be digital output)
const int redLED = 9; // the PWM pin the red LED is attached to (will be analog output)

int brightness = 0; // how bright the LED is
int fadeAmount = 1; // default LED fade amount

void setup() {
  pinMode(sensorPin, INPUT);  // declare sensor pin as input
  pinMode(switchPin, INPUT);  // declare switch pin as input
  pinMode(greenLED1, OUTPUT); // declare green LED pin 1 as output
  pinMode(greenLED2, OUTPUT); // declare green LED pin 2 as output
  pinMode(greenLED3, OUTPUT); // declare green LED pin 3 as output
  pinMode(greenLED4, OUTPUT); // declare green LED pin 4 as output
  pinMode(redLED, OUTPUT); // declare red LED pin as output
}

void loop() {
  int sensorValue = analogRead(sensorPin); // reading analog input specified by the photoresistor (has a range of 0 - 1023)
  int fadeMultiplier = map(sensorValue, 200, 900, 20, 0.5); // map sensor input (from small range based on serial monitor to determine fade amount)

  analogWrite(redLED, brightness);  // set the brightness of the red LED

  // change the brightness for next time through the loop
  brightness = brightness + fadeAmount*fadeMultiplier;

  // catch when LEDs are below 0 or above 200 and reverse the direction of the fading at the ends of the fade
  if (brightness < 0) {
    brightness = 0;
    fadeAmount = -fadeAmount;
  } else if (brightness >= 200) {
    brightness = 200;
    fadeAmount = -fadeAmount;
  }

  int switchPosition = digitalRead(switchPin);  // reading digital value specified by the switch

  // turn on and off the four green LEDs in order depending on switch position
  switch(brightness/40) {
    case 0: // when brightness == 0
      digitalWrite(greenLED1, LOW);
      digitalWrite(greenLED2, LOW);
      digitalWrite(greenLED3, LOW);
      digitalWrite(greenLED4, LOW);
      break;
    case 1: // when brightness == 40
      digitalWrite(greenLED1, HIGH);
      digitalWrite(greenLED2, LOW);
      digitalWrite(greenLED3, LOW);
      digitalWrite(greenLED4, LOW);
      break;
    case 2: // when brightness == 80
      digitalWrite(greenLED1, LOW);
      digitalWrite(greenLED4, LOW);
      
      if (switchPosition == LOW) {
        digitalWrite(greenLED2, HIGH);
        digitalWrite(greenLED3, LOW);
      } else if (switchPosition == HIGH) {
        digitalWrite(greenLED2, LOW);
        digitalWrite(greenLED3, HIGH);
      }
      break;
    case 3: // when brightness == 120
      digitalWrite(greenLED1, LOW);
      digitalWrite(greenLED4, LOW);

      if (switchPosition == LOW) {
        digitalWrite(greenLED2, LOW);
        digitalWrite(greenLED3, HIGH);
      } else if (switchPosition == HIGH) {
        digitalWrite(greenLED2, HIGH);
        digitalWrite(greenLED3, LOW);
      }
      break;
    case 4: // when brightness == 160
      digitalWrite(greenLED1, LOW);
      digitalWrite(greenLED2, LOW);
      digitalWrite(greenLED3, LOW);
      digitalWrite(greenLED4, HIGH);
      break;
    default:  // default (including when brightness == 200)
      digitalWrite(greenLED1, LOW);
      digitalWrite(greenLED2, LOW);
      digitalWrite(greenLED3, LOW);
      digitalWrite(greenLED4, HIGH);
      break;
    }

  // wait for 50 milliseconds to see the dimming effect of the red LED and turn on/off green LEDs
  delay(50);
}
