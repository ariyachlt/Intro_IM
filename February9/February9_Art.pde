/*
Assignment 3: OOP Artwork (Windows screensaver vibes)
 Intro to IM
 Due: Tuesday February 9
 Written by Ariya Chaloemtoem
 */

particleSystem PS;  // declaring particle system variable

void setup() {
  size(800, 600);  // setting the width and height of the screen
  background(0);  // setting the background here instead of in draw to not refresh at each frame
  
  PS = new particleSystem();  // construct array list from the particleSystem class

  // adding objects (particles) to the array list
  for(int i = 0; i < 40; i++){
    PS.addParticle();
  }
}

void draw() {
  PS.joinParticles();  // drawing the "particles" and lines that join them
}

// Particle class
// Describes the properties of each single particle
class Particle {
  float x, y;  // x and y positions of the particle
  float r;  // radius of the particle
  float xSpeed;  // speed of the particle in the x direction
  float ySpeed;  // speed of the particle in the y direction
  int c;  // color of the particle
  
  // Constructor
  Particle() {
    x = random(0, width);  // setting initial x position to random location on the canvas
    y = random(0, height);  // setting initial y position to random location on the canvas
    r = 0;  // setting the radius of the particle to 0 (so we dont see the dots at all)
    c = color(random(150, 250), random(0, 100), random(50, 150));  // setting the color of the particle to 
    //c = color(random(0, 255), random(0, 255), random(0, 255));  // uncomment this line and comment above line for rainbow colors
    xSpeed = random(-2,2);  // randomizing x speed (and initial direction)
    ySpeed = random(-2,2);  // randomizing y speed (and initial direction)
  }
  
  // Function to move particles and confine then within certain dimensions
  void update() {
    // check if x position of the particle is less than -20 or greater than the screen width + 20
    if(x < -20 || x > width + 20) {
      xSpeed *= -1;  // reflect
    }
    // check if y position of the particle is less than -20 or greater than the screen height + 20
    if(y < -20 || y > height + 20) {
      ySpeed *= -1;  // reflect
    }
    
    x += xSpeed;  // increment x position of the particle by its x speed
    y += ySpeed;  // increment y position of the particle by its y speed
  }
}

// Particle system class
// Describes the properties of the particle system
class particleSystem {
  ArrayList<Particle> myParticles;  // declaring the array list
  float d;  // the distance limit between two particles
  
  // Contructor
  particleSystem() {
    myParticles = new ArrayList<Particle>();  // construct array list with intention of filling with particles
    d = random(80, 200);  // setting the distance limit to randomize between 100 and 200
  }
  
  // Function to add particle
  void addParticle() {
    myParticles.add(new Particle());  // adds a new particle object to the array list
  }
  
  // Function to join the particles
  // Iterates over an array list with a nested foor loop to check the distance between each particle
  void joinParticles() {
    for (Particle p1: myParticles) {  // loop through each particle
      for (Particle p2: myParticles) {  // loop through each particle
        if (p1 != p2){  // condition to ensure we are not checking each particle with itself
          float dist = dist(p1.x, p1.y, p2.x, p2.y);  // finding the distance between two particles
          
          // checking if the distance is over the limit
          if (dist < d) {
            stroke(p1.c, 150);  // setting the stroke color to the "color" of the "particle"
            line(p1.x, p1.y, p2.x, p2.y);  // draw line between particles
          }
        }
      }
      p1.update();  // for each particle, call on function to update its position
    }
  }
}

// Refresh the screen when mouse is pressed
void mousePressed(){
  background(0);  // resets the background
  
  // reset the particle system
  PS = new particleSystem();
  for(int i = 0; i < 40; i++){
    PS.addParticle();
  }
}
