/*
Assignment 2: For/While Loop Artwork
 Intro to IM
 Due: Tuesday February 2
 Written by Ariya Chaloemtoem
 */

// declaring variables
int tileCount = 10;  // variable used to create 64*64 squares in 10*10 grid
//int tileCount = 20;  // <uncomment this line and comment above line for a grid of smaller rectangles>
int posX, posY;  // position variable of the rectangles
float translateX, translateY;  // variable to translate the X and Y position of the rectangles
float randSize;  // position to add random variations to the rectangle size
float randMap;  // variable to map random variations to the rectangle size
color c;  // variable to set the color of each rectangle

void setup() {
  size(640, 640);  // setting the width and height to 640
  frameRate(5);  // reducing the frameRate to draw image slower
}

void draw() {
  background(255);  // setting the background to white
  randMap = map(mouseX, 0, width, 0, width/tileCount);  // mapping mouse position to a different range
  
  createGrid();  // calling funciion to create the grid of rectangles
}

// function to create the grid of rectangles
void createGrid() {
  for (int gridX = 0; gridX < tileCount; gridX++) {  // loop through each X position
    for (int gridY = 0; gridY < tileCount; gridY++) {  // loop through each Y position

      // to determine the position of each rectangle
      posX = width/tileCount*gridX;  // set X position
      posY = height/tileCount*gridY;  // set Y position

      c = color(random(0, 200));  // randomly generate a dark grey color for each rectangle
      noStroke();  // remove the outline of each rectangle
      fill(c, 150);  // setting the fill color and reducing the opacity to see overlap

      // randomizing variation to the size of the rectangle
      randSize = random(0, randMap);  // range of random() depends on mouse position

      rectMode(CENTER);  // changing the rectangle mode to center
      translateX = width/tileCount/2;  // translate X position by approximately half the rectangle width 
      translateY = width/tileCount/2;  // translate Y position by approximately half the rectangle height
      rect(posX + translateX, posY + translateY, (width/tileCount) + randSize, (height/tileCount) + randSize);
    }
  }
}
