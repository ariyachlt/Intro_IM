# Assignment 4: Data Visualization

<p align="center">
  <img src="miRNA1.png" height="340">
  <img src="miRNA2.png" height="340">
</p>

<p align="center">
  Left: miR-30a-5p, Right: miR-507.
</p>

## Description
For this assignment, I decided to create a simple data visualization of mature human miRNA sequences. These are short sequences of RNA that negatively regulate gene expression. As a biology major currently investigating the role of miRNAs in host susceptibility to malaria for my capstone, I thought it would be interesting to create a visualization for these sequences in a fun and creative way. I wanted my visualization to almost feel like art, while remaining informative for those who understand the biology of it. Therefore, I kept the visuals very simple. Each base (there are a total of 4: A, C, G, and U) is assigned a color (orange, yellow, light blue, and dark blue, respectively), and is displayed in rectangles of equal widths in sequential order. One miRNA is displayed at a time and a mouseclick randomizes the next miRNA to be displayed (out of a total of 2656 miRNAs). The name, sequence length, and sequence of the miRNA is also printed in the processing console (example in the demo below). I chose not to print the names on the actual visual demonstration because it takes away from the more 'artsy' feel that I wanted to create. I believe the data visualization still remains factual and representitive of the miRNA sequence even without the miRNA information (which can be accessed in the console if need be).

## Demo
<p align="center">
  <img src="miRNA_example.gif" width="520">
</p>

## Process
1. I obtained the mature miRNA sequences from [miRBase](http://www.mirbase.org/ftp.shtml) (a miRNA database). The raw data is a fasta (.fa) file which is a file that contains reference sequences. This file contains over 40000 miRNA sequences, and only around 2500 of those are human sequences.
2. I converted the fasta file to csv and filtered out non-human miRNAs using a script which I also uploaded to github (fasta2csv_filtering.csv).
3. The csv file was loaded into processing in an array and the selected 'row' is randomized.
4. The string was split to separate the miRNA name and sequence.
5. The index containing the sequence was used to calculate the sequence length (which varies but averages around 20 nucleotides) and divide the width of the screen into equal parts.
6. I then parsed through the sequence to check the base of each nucleotide and draw a rectangle colored based on the letter (A, C, G or U) in that position.
7. The noLoop() funtion was used to prevent the draw() function from continuously executing. A loop() function was included in the mouseClicked() function to randomly select a new miRNA to draw.

## Challenges
Since my original data was a fasta file, I had to spend quite a good amount of time

## Discoveries

## Moving Forward

