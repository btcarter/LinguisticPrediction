#load libraries
library(reshape2)

#Set the working environment.
setwd("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/predictability")

#create the directory to hold timing files.
if (file.exists("frequency")){
  setwd("frequency/")
} else {
  dir.create("frequency")
  setwd("frequency")
}

#Read in source csv as matrix
frequency <- read.csv("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/source_csvs/predictionwlengthandfrequency.csv")
colnames(frequency)

#remove unnecessary columns or NA values
frequency = frequency[frequency$Content_Or_Function == "Content",]
frequency <- frequency[,c("RECORDING_SESSION_LABEL","RUN","START_TIME","Frequency")]
frequency = frequency[is.na(frequency$START_TIME) == FALSE, ]
frequency = frequency[is.na(frequency$Frequency) == FALSE, ]
frequency <- frequency[order(frequency$RUN, frequency$START_TIME), ]

#make timing column with log transformed frequency
frequency$logFrequency = log(frequency$Frequency)
frequency$para = paste((frequency$START_TIME/1000), (frequency$logFrequency + abs(min(frequency$logFrequency))+1), sep ="*")

#assemble individual timing files
frequency <- frequency[c(1,2,6)]
frequency <- melt(frequency, id=c("RECORDING_SESSION_LABEL","RUN"))
frequency = frequency[is.na(frequency$RECORDING_SESSION_LABEL) == FALSE, ]

for (i in unique(frequency$RECORDING_SESSION_LABEL)) {
  subj = frequency[frequency$RECORDING_SESSION_LABEL == i, ]
  colnames(frequency)
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

#checkfile = read.delim(file.choose(), header = FALSE)
#summary(frequency$RECORDING_SESSION_LABEL)