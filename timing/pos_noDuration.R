#Set the working environment.
setwd("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/predictability")

#create the directory to hold timing files.
if (file.exists("pos_noDM")){
  setwd("pos_noDM")
} else {
  dir.create("pos_noDM")
  setwd("pos_noDM")
}

#Read in syn_group.csv as table.
group <- read.csv("~/Documents/Research/fMRI_data/Reading/Compute_data/TimingFiles/source_csvs/predictions.csv")
colnames(group)

#remove unneeded columns/values
group = group[group$Content_Or_Function == "Content", ]
group <- group[,c("RECORDING_SESSION_LABEL","RUN","START_TIME","POSMatchModel","IA_FIRST_RUN_DWELL_TIME")]

#remove NA values form group matrix
group = group[is.na(group$START_TIME) == FALSE, ]
group = group[is.na(group$POSMatchModel) == FALSE, ]

#Create a column with times in parametric format ([event1 time]*[orthographic]*[POS]*[DurationModulation] ...  [eventn time]*[orthographic]*[POS]*[DurationModulation]) and perform maths to convert times from milliseconds to seconds.
#group$Parametric_times = paste((group$START_TIME/1000), log10(group$POSMatchModel), sep = "*")
group$Parametric_times = log(group$POSMatchModel)
group$Parametric_times = paste((group$START_TIME/1000), (group$Parametric_times + abs(min(group$Parametric_times))+1), sep ="*")

mdata = group
colnames(mdata)
mdata <- mdata[c(1,2,6)]
library(reshape2)
mdata <- melt(mdata, id=c("RECORDING_SESSION_LABEL","RUN"))
mdata = mdata[is.na(mdata$RECORDING_SESSION_LABEL) == FALSE, ]

#Assemble the individual AM timing files so that each subject has an individual timing file with one row per run
for (i in unique(mdata$RECORDING_SESSION_LABEL)) {
  sub1data = mdata[mdata$RECORDING_SESSION_LABEL == i, ]
  colnames(sub1data)
  if (nrow(sub1data) > 0) {
    sub1data = sub1data[c(2:4)]
    sub1data$variable = 1:nrow(sub1data)
    sub1data[sub1data$RUN == 3, ]$variable = sub1data[sub1data$RUN == 3, ]$variable - max(sub1data[sub1data$RUN == 2, ]$variable)
    sub1data[sub1data$RUN == 2, ]$variable = sub1data[sub1data$RUN == 2, ]$variable - max(sub1data[sub1data$RUN == 1, ]$variable)
    sub1data = dcast(sub1data, RUN ~ variable)
    #max(sub1data[sub1data$RUN == 3, ]$variable)
    sub1data = sub1data[2:ncol(sub1data)]
    write.table(sub1data, paste(i, ".txt", sep = ""), sep = "\t", na = "", col.names = FALSE, row.names = FALSE, quote = FALSE)
    #write.table(sub1data, paste("Luke_Reading_S", i, ".txt", sep = ""), sep = "\t", col.names = FALSE, row.names = FALSE) 
  }
}

summary(mdata$RECORDING_SESSION_LABEL)
