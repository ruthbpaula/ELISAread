setwd("C:/path")
######### APPROACH 1 - MAKE CODE FROM SCRATCH #########

rm(list=ls())

# Reading all CSV files in the same folder
fileNames = list.files(pattern="*.csv") 
final_file <- data.frame(matrix(ncol = 0, nrow = 0))

for (fName in fileNames){
  # Open fName
  plate_raw <- read.csv(fName, header = FALSE)
  plate <- as.data.frame(plate_raw)
  
  #supposing column 12 contains the "blanks"
  mean_blanks <- mean(plate$V12)
  
  #subtracting the blank mean for each cell and generating a new table
  new_plate <- as.matrix(plate - mean_blanks)
  
  dimnames(new_plate) <- list(NULL, NULL)  #Remove colnames
  new_plate_ok = as.vector(new_plate)
  
  numOfColumnsToConsider = ncol(new_plate) - 1; # To exclude blanks
  numOfSamplesInColumn = nrow(new_plate)
  res = c()
  for (i in seq(1, numOfSamplesInColumn * numOfColumnsToConsider, by=3)) {
    # Calculate average of i, i+1 and i+2
    averageVal = (new_plate_ok[i] + new_plate_ok[i+1] + new_plate_ok[i+2]) / 3
    # Insert into result vector
    res = c(res,averageVal)
  }
  final_file <- rbind(final_file, res)
  final_file <- rbind(final_file, fName)
  final_file <- rbind(final_file, "-")
}

#save the output file
write.table(final_file, file = "results.txt", sep = "\t", row.names = FALSE, col.names = FALSE)
