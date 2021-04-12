# Assignment 8: Simple Arduino-Processing Game

<p align="center">
  <img src="gameScreenImage.png" height="300">
  <img src="gameBoardImage.jpg" height="300">
</p>

## Description
This production assignment for this week was to make a simple game that involves some kind of communication between Arduino and Processing. I didn't know what I was going to make at first, I jut knew that I wanted to build something that takes inputs from arduino to control what happens on the processing display window. I decided to create a simple game that takes inputs from switches and a photoresistor to control the position of a circle on the processing screen. The goal of the the game is also simple: using the photoresistor and switches, move the red circle into the white circle as many times as possible in one minute.

## Instructions
1. Calibrate the photoresistor when the game starts (credits to Chinonyerem) by placing your fingers on and off the photoresistor. The user has up to 5 seconds to do so. If calibration failed, a defualt mapping range is set.
<p align="center">
  <img src="demoImages/Image1.png" height="270">
</p>

2. Use the photoresistor to control the vertical position. The more light the photoresistor senses, the higher up in the screen the position of the circle.
<p align="center">
  <img src="demoImages/Image2.png" height="270">
  <img src="demoImages/Image3.png" height="270">
  <img src="demoImages/updownDemo.gif" height="270">
</p>

4. Use the yellow and green buttons to control the horizontal position. Green moves the circle right and yellow moves the circle left.
<p align="center">
  <img src="demoImages/sideDemo.gif" height="270">
</p>

5. Using the photoresistor and switches, move the red circle into the white circle. Once succeeded, new red and white circles will be generated in a new position. Try to move as many red circles into white circles as possible in 1 minute.

6. At the end of the game, the score is displayed. Press both switches to restart the game.
<p align="center">
  <img src="demoImages/Image5.png" height="270">
</p>

## Demo
<p align="center">
  <img src="demoImages/april13Demo.gif" width="600">
</p>

Click [here](https://youtu.be/-rTePLhQ21w) for a video demo.

## Process
1. I first built the circuit (schematic below), placing the switches and photoresistor on to the breadboard while taking into account how I want to wire and interact with them.
2. I then wrote the Arduino code. Since I am only taking inputs from Arduino, it wasn't difficult to write code to obtain the values I need that I want to send to processing.
3. Next, I began writing the processing code by first making sure my inputs from Arduino are moving one circle around the screen the way I am expecting it to.
4. Once I am sure everything is functioning the way it should, I wrote the functions and conditions for the game to operate (ex. detecting circle overlap, scoring, counting down the time, displaying text, restarting the game etc.)

## Schematic
<p align="center">
  <img src="gameSchematic.jpg" width="500">
</p>

## Challenges

## Discoveries
