# Final Project Journal

## Preliminary Concept and Description (2-player car racing game)
For my final project, I want to create a two-player game involving some form of communication between Processing and Arduino. After some brainstorming, I settled on creating a two-player car racing game. Considering the type of game I created for my midterm project, I wanted to switch gears a little and create something that takes a little less brain power to play but still remains highly interactive. The competition between two players will probably make it more engaging as well.

**Game logistics** \
The setup and goal of the game will be simple: try to get to the finish line before the other player. The cars will be side-by-side, with the finish line at the top of the screen (sketch below). I still haven't fully decided how I want to declare a winning condition but I am considering either doing a "best out of X rounds" or "first to reach X wins". This ensures that the game won't go on forever.

<p align="center">
  <img src="images/prelimCarSketch.jpeg" height="330">
</p>

**Interactions** \
The movement of the two cars will be controlled by buttons (switches). Each car will be controlled by two switches such that the car only moves forward if the two switches associated with the car are pressed alternately. This means that I will require four switches total. Information about the status of each switch will be sent to processing to tell the cars to move. Since switches will have to be pressed alternately, I will also need to store information on which switch was previously pressed for each car to ensure that the car does not move if one button is pressed twice. To ensure that the interaction is comfortable for the players, I will also need to tkae into consideration the placement ofthe switches. The tentative placement plan is shown below:

<p align="center">
  <img src="images/breadboardSketch.jpeg" height="330">
</p>

## Progress
**Friday April 16 - Sunday April 18, 2021** \
These past few days, I actually took to pen an paper to plan my code. My main priority is to figure out the car movement conditions based on alternately pressing buttons because it is the main component of my game. I knew I had to store information on previous buttons pressed and use that information to condition the movement, however, it wasn't clear in my mind how I would actually implement it in code. Something that I find really useful when I don't have clarity on how to acually code is to just write out the steps of whats needs to happen. Attached below is an image on a snippet from my notebook scribbles.

<p align="center">
  <img src="images/movementPlan.png" height="450">
</p>

I first idea, I though about checking if the current switch pressed is the same as the prevous switch pressed but the amount of things that needed to be checked and reassigning new values to variables got me quite confused. I also thought about detecting releases instead of presses to ensure the cars doesn't keep moving if the player keep the switch pressed down. I then realised that if I reassign the value of the last switch pressed (as I tried to do in my first plan) it shouldn't matter if the switch is held down. However, I figured there must be an easier and more code-efficient way to check that the switches are alternating. I realised that if I check which switch was last pressed, I should be able to check the current switch pressed right away by checking if the current switch pressed is ```HIGH``` while the previous one is ```LOW```. This automatically ensures that the car only moves if one of the two switches is pressed and if they current switch pressed is not the same as the previous switch pressed. I haven't tried to implement it yet so my next step is to make sure that this idea actually works.

**Monday April 19, 2021** \
Today, I actually wrote the code in Arduino so that I can check if it actually works. Below is a snippet of the code for one of the player's switches.
```Processing
int player1LeftState, player1RightState; // Variables to store value from the switches for each player
int player1PrevSwitch = floor(random(0,2)); // Variables to store the previous states of the switch (0 = left, 1 = right)
int player1Move = 0; // Variables to tell processing whether the player should be moving (o = no, 1 = yes)

// Player 1 movement checking
   player1LeftState = digitalRead(player1LeftPIN);
   player1RightState = digitalRead(player1RightPIN);

   if (player1PrevSwitch == 0) {  // check if left switch was previously pressed
     if (player1LeftState == LOW & player1RightState == HIGH){  // check if right switch is pressed while left switch is not, move if true
       player1Move = 1;
       player1PrevSwitch = 1;
     } else {
       player1Move = 0;
     }
   } else if (player1PrevSwitch == 1) {  // check is right switch was previously pressed
     if (player1LeftState == HIGH & player1RightState == LOW){  // check if left switch is pressed while right switch is not, move if true
       player1Move = 1;
       player1PrevSwitch = 0;
     } else {
       player1Move = 0;
     }
   }
```
However, before I can check that this even works, I need to first set up the circuit on my breadboard and 
