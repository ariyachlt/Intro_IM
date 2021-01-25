/*
Assignment 1: Self-Portrait
 Intro to IM
 Due: Tuesday January 26
 Written by Ariya Chaloemtoem
 */

// Setting the portrait size
size(480, 560);  // setting width to 480 and height to 560

// Setting the default of shapes to have no stroke
// This is a stylistic preference as it allows for me to overlap shapes without outlines (to create more complex ones)
noStroke();

// Setting the background colour
// I chose to make the background blue so it looks like the sky
// I want to create a sky with clouds in the background (I guess because I daydream a lot)
background(160, 200, 245);

// Drawing clouds using overlapping circles
// Declaring position variables to plot the clouds
int[] xCloud = {50, 330, 20, 350, 20};  // position x of left most circle in each "cloud"
int[] yCloud = {90, 140, 310, 380, 530};  // position y of left most circle in each "cloud"
// Using a loop to plot 5 clouds using 6 overlapping circles with positions relative to each other
for (int i = 0; i < 5; i = i+1) {
  circle(xCloud[i], yCloud[i], 70);
  circle(xCloud[i] + 30, yCloud[i] - 25, 75); 
  circle(xCloud[i] + 35, yCloud[i] + 10, 80);
  circle(xCloud[i] + 75, yCloud[i] - 20, 75); 
  circle(xCloud[i] + 75, yCloud[i] + 5, 80);
  circle(xCloud[i] + 105, yCloud[i] - 5, 65);
}

// Hair
// Constructing the shape of my hair using circles, rectangles and triangles
fill(#543312);  // setting fill colour to brown
circle(width/2 + 10, height/2 - 105, 380);
rect(width/2 - 180, height/2 - 105, 380, 290);
triangle(width/2 - 220, height/2 + 185, width/2 - 180, height/2 + 185, width/2 - 180, height/2 + 90);  // left ends
triangle(width/2 + 230, height/2 + 185, width/2 + 200, height/2 + 185, width/2 + 200, height/2 + 70);  // right ends

// Neck and body
// This part is drawn before the face so that the face can boverlap on top of it
fill(#F1C27D);  // setting fill colour to dark beige
rect(195, 360, 150, 120);  // neck
rect(40, 480, 400, 80);  // body
triangle(40, 480, 195, 480, 195, 450);  // left shoulder
triangle(40, 480, 40, 560, 0, 560);  // left arm
triangle(345, 480, 440, 480, 345, 450);  // right shoulder
triangle(440, 480, 440, 560, 480, 560);  // left arm
fill(#D3A05A);  // setting fill colour to darker beige
triangle(275, 410, 345, 450, 345, 365);  // neck shadow

// Face shape
// Constructing the shape of my face using trianges and rectangles
// I decided to hard code most of it as the math of doing it relative gets complicated especially with triangles
fill(#F4CD9A);  // setting fill colour to light beige
// Setting middle rectangle width and height to use as reference points
int recW = 80;  // width of middle rectangle
int recH = 280;  // height of middle rectable
// Drawing the shapes
rect(195, 130, recW, recH);  // middle rectangle (all other shapes constructed around this one)
rect(195 - recW, 130, recW, recH - 100);  // left rectangle
rect(195 + recW, 170, recW + 40, recH - 120);  // right rectangle
triangle(115, 310, 195, 410, 195, 310);  // bottom left cheek
triangle(275, 410, 395, 330, 275, 330);  // bottom right cheek
triangle(275, 70, 275, 170, 395, 170);  // top right forehead
triangle(115, 130, 275, 130, 275, 70);  // top left forehead

// Ear (only drawing the right one to make it go with the hair)
ellipse(390, 235, 60, 90);

// Hair shadow
fill(#F1C27D);  // setting fill colour to dark beige (same color as the nose and eyelids)
triangle(275, 70, 395, 170, 395, 190);  // shadow is in the right side of the face right under the hairline

// Nose
fill(#F1C27D);  // setting fill colour to dark beige
triangle(270, 180, 270, 310, 210, 310);  // triangle as nose

// Eyes
// Drawing eyelids as circles
circle(170, 220, 80);  // left eyelid
circle(310, 220, 80);  // right eyelid
// Drawing eyes using semi circles
fill(#111111);  // setting fill colour to (almost)black
arc(170, 220, 80, 80, PI/8, PI - (PI/8), OPEN);  // left eye
arc(310, 220, 80, 80, PI/8, PI - (PI/8), OPEN);  // right eye
// Drawing lashes
triangle(135, 240, 145, 240, 125, 225);  // left lash
triangle(335, 240, 345, 240, 355, 225);  // right lash

// Eyebrows
fill(#543312);  // setting fill colour to brown
rect(145, 165, 65, 15);  // left brow rectangle
triangle(145, 165, 145, 180, 130, 180);  // left brow triangle
rect(270, 165, 65, 15);  // right brow rectangle
triangle(335, 165, 335, 180, 350, 180);  // right brow triangle

// Cheek highlights
fill(#F0BAA8);  // setting fill colour to pink
square(145, 260, 50);  // left cheek highlight
square(285, 260, 50);  // right cheek highlight

// Mouth
fill(#E17F7A);  // setting fill colour to a dark pink
triangle(195, 350, 210, 330, 210, 370);  // left corner
rect(210, 330, 60, 40);  // middle part
triangle(270, 330, 270, 370, 310, 330);  // right corner

// Shirt
fill(#FFE87A);  // setting fill colour to yellow (no real reason, just think the colour contrasts the sky well)
rect(90, 520, 315, 42);  // main part of the shirt (middle part)
rect(90, 470, 50, 50);  // left strap rectangle
triangle(90, 470, 140, 470, 140, 461);  // left strap triangle
rect(355, 470, 50, 50);  // right strap rectangle
triangle(355, 470, 405, 470, 355, 453);  // right strap triangle
