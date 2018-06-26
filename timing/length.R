#load libraries
library(reshape2)

#Set the working environment.
setwd("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/predictability")

#create the directory to hold timing files.
if (file.exists("length")){
  setwd("length")
} else {
  dir.create("length")
  setwd("length")
}

#Read in source csv as matrix
length <- read.csv("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/source_csvs/predictionwlengthandfrequency.csv")
colnames(length)

#remove unnecessary columns
length = length[length$Content_Or_Function == "Content",]
length <- length[,c("RECORDING_SESSION_LABEL","RUN","START_TIME","Length")]
length = length[is.na(length$START_TIME) == FALSE, ]
length = length[is.na(length$Length) == FALSE, ]
length <- length[order(length$RUN, length$START_TIME), ]

#make timing column with start time and word length
length$para = paste((length$START_TIME/1000),length$Length, sep ="*")

#assemble individual timing files
length <- length[c(1,2,5)]
length <- melt(length, id=c("RECORDING_SESSION_LABEL","RUN"))

for (i in unique(length$RECORDING_SESSION_LABEL)) {
  subj = length[length$RECORDING_SESSION_LABEL == i,]
  if (nrow(subj) > 0) {
    subj = subj[c(2:4)]
    subj$variable = 1:nrow(subj)
    subj[subj$RUN == 3, ]$variable = subj[subj$RUN == 3, ]$variable - max(subj[subj$RUN == 2, ]$variable)
    subj[subj$RUN == 2, ]$variable = subj[subj$RUN == 2, ]$variable - max(subj[subj$RUN == 1, ]$variable)
    subj = dcast(subj, RUN ~ variable)
    subj = subj[2:ncol(subj)]
    write.table(subj, paste(i, ".txt", sep = ""), sep = "\t", na = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
  }
}

summary(length$RECORDING_SESSION_LABEL)
