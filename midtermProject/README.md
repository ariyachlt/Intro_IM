# Midterm Project (Remake of BBTan)

<p align="center">
  <img src="images/finalMainMenu.png" height="350">
  <img src="images/finalInstructions.png" height="350">
  <img src="images/finalGame.png" height="350">
  <img src="images/finalGameOver.png" height="350">
</p>

<p align="center">
  <b>Left to Right:</b> Main menu, Instructions screen, Game screen, Game over display.
</p>

## Description
For my midterm project, I decided to re-create a game I used to play in high school on the school bus almost every single day. The game that I am trying to recreate is called BBTan (by 111%).

**What is BBTan?** \
BBTan is a ball shooting game that destroys blocks when they are hit. However, there is a twist. These ‘blocks’ come in two shapes: squares and triangles with a number inside them which indicates how many times it has to be hit to be destroyed. The player first starts by aiming the ball at some angle. Each time a block is hit, the number is reduced by one, and the block is considered destroyed when the number reaches zero. After each round of shooting, the surviving blocks move down one grid row, and a new row of blocks is created. The number inside each new row of blocks depends on the round, and the player score is the number of rounds the player survives before the bottom-most blocks reach the bottom of the screen. The original game also has a bunch of power-ups that the player can hit with current balls to increase the number of balls thrown in each round, scatter the balls in random directions, or slash entire rows or columns.

**What does my version of it look like?** \
My version of the game is a little more simplified, with most of the key elements intact. My experience playing this game allowed me to make an informed decision of what to keep and what to modify so that the game retains the key components and remains playable.  \
\
Things that stayed the same:
- The number of balls inside the block is the number of hits required to break it
- The first row of blocks begins in the 'second' row
- The blocks move down one row after each round
- The number of rounds determines the score
- The game is over when the block touches the ground
- The color scheme/aesthetics (white balls, colorful blocks on a dark background)
- The positioning of the round/current score and highscore ('Top')

Things I modified:
- Removed the triangular blocks
- Removed power ups (ex. increase balls, strike entire rows/columns)
- Defined the number of balls as the current round instead
- Balls only shoot from the center of the ground instead of where the first ball in each round falls

Most modifications are due to extra challenges in defining conditions or calculations. They add too many layers of complexity on top of a program that is already quite time consuming to recreate.

## Instructions
1. Move the mouse to aim
2. Click to shoot
3. Don't let the blocks touch the ground
4. Beat your own/others' highscore!

## Demo
<p align="center">
  <img src="images/gameDemo.gif" width="420">
</p>

Click [here](https://youtu.be/lcrsGA2HkJk) to watch it with sound.

## Process
1. I first created a 420 by 600 'box' inside the 480 by 720 canvas where the game will be contained in. This box region was then be split into 10 rows and 7 columns where 60 by 60 blocks will fit.
2. I defined a ball class which will take one argument (modified from previously two: angle and initial x position), the angle, and wrote functions to move the ball by the given angle, and reflect off walls (the 'box').
3. 
4.  
The process is describe in full detail [here](https://github.com/ariyachlt/Intro_IM/blob/main/midtermProject/journal.md).

## Challenges


## Discoveries


## Moving Forward


