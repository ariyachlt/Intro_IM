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


