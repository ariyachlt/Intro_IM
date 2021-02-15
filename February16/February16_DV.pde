/*
Assignment 4: Data Visualization
 Intro to IM
 Due: Tuesday February 16
 Written by Ariya Chaloemtoem
 */
 
/*
Concept: This programs visualizes miRNA sequences using blocks of rectangles of equal lenghths, colored by the base.
Instructions: Click the screen to visualize the next miRNA (it is randomized)
Data source: the mature miRNA fasta file (reference sequences) were obained from http://www.mirbase.org/ftp.shtml (a miRNA database).
*/

String strings[];   // declaring array for strings

// declaring colors for each base
color colA = color(250, 80, 50);  // orange
color colC = color(255, 195, 75);  // yellow
color colG = color(0, 155, 185);  // light blue
color colU = color(10, 45, 90);  // dark blue

// defining functions for drawing a rectangle based on the base
// it takes the current 'column' the base is in and total number of 'columns' (total number of bases)
// for base A, draw an orange rectangle
void drawA(int currColumn, float totalColumns){
  fill(colA);
  stroke(colA);
  float w = width/(totalColumns);
  rect(w*currColumn, 0, w, height);
}

// for base C, draw a yellow rectangle
void drawC(int currColumn, float totalColumns){
  fill(colC);
  stroke(colC);
  float w = width/(totalColumns);
  rect(w*currColumn, 0 , w, height);
}

// for base G, draw a light blue rectangle
void drawG(int currColumn, float totalColumns){
  fill(colG);
  stroke(colG);
  float w = width/(totalColumns);
  rect(w*currColumn, 0, w, height);
}

// for base U, draw a dark blue rectangle
void drawU(int currColumn, float totalColumns){
  fill(colU);
  stroke(colU);
  float w = width/(totalColumns);
  rect(w*currColumn, 0, w, height);
}

void setup() {
  size(640, 480);

  strings = loadStrings("hsa_miRNAs.csv");  // loading the text from the file into an array.
  int csvLength = strings.length;  // storing information on how many lines there are
  println("strings array contains this many lines: " + csvLength);
}

int row = round(random(0, 2656)); // randomly select a miRNA out of the list of 2656 

void draw() {  
  String[] splitString = strings[row].split(",");  // splitting the miRNA name and sequence separated by a comma
  String miRNA = splitString[0];  // getting the miRNA name
  String sequence = splitString[1];  // getting the miRNA sequence 
  
  // printing information on the miRNA (name, length, sequence)
  println("miRNA is: " + miRNA);
  println("miRNA contains this many bases: " + sequence.length());
  println("miRNA sequence is: " + sequence);
 
 // function to draw rectangle based on the sequence of miRNAs
  for(int i = 0; i < splitString[1].length(); i++){
    switch(Character.toUpperCase(splitString[1].charAt(i))){
      case 'A':
        drawA(i, splitString[1].length());
        break;
      case 'C':
        drawC(i , splitString[1].length());
        break;
      case 'G':
        drawG(i , splitString[1].length());
        break;
      case 'U':
        drawU(i , splitString[1].length());
        break;
      default:
        print("ERROR: Couldn't understand input ");
        println(Character.toUpperCase(strings[row].charAt(i)));
    }
  }
  
  println();
  noLoop();  // to stop processive from continuously executing the draw() function
}

// function to resume the draw() function when mouse is clicked
void mouseClicked() {
  row = round(random(0, 2655));  // randomly select a new miRNA to draw
  loop();
}
