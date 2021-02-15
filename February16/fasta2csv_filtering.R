# converting fasta file to csv
# from Tocquin, Pierre. (2012). Re: Converting a fasta file to a tab-delimited file?. Retrieved from: https://www.researchgate.net/post/Converting_a_fasta_file_to_a_tab-delimited_file10/502907d5e4f076464a000011/citation/download. 
input <- readLines("mature_miRNA.fa")
output <- file("mature_miRNA.csv","w")

currentSeq <- 0
newLine <- 0

for(i in 1:length(input)) {
  if(strtrim(input[i], 1) == ">") {
    if(currentSeq == 0) {
      writeLines(paste(input[i],"\t"), output, sep="")
      currentSeq <- currentSeq + 1
    } else {
      writeLines(paste("\n",input[i],"\t", sep =""), output, sep="")
    }
  } else {
    writeLines(paste(input[i]), output, sep="")
  }
}

close(output)

# selecting desired data
all_miRNAs <- read.csv("mature_miRNA.csv", sep = "\t", header = F)  # read csv file with all miRNAs

# splitting the strings in the first column
strings <- strsplit(as.character(all_miRNAs$V1)," ")
newCols <- as.data.frame(strings)
newCols <- as.data.frame(t(newCols))

# creating new data frame
all_miRNAs <- data.frame(genus = newCols$V3, species = newCols$V4, miRNA = newCols$V5, sequence = all_miRNAs$V2)

# selecting only human miRNAs
hsa_only <- subset(all_miRNAs, all_miRNAs$species == "sapiens")

write.csv(hsa_only, "hsa_miRNAs.csv")
