## Coursera Getting and Cleaning Data
## Course Project
## 2014-10-26

##The data sets can be downlaoded from the URL below
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

##=====================================================================================

##Check working directory
getwd()

##if wrong working directory, then set directory

##Create a folder in working directory to add tidy data
if(!file.exists("data")){
  dir.create("data")
}


##==========================================================================================
##1. Read data into R, assign descriptive variable names and merge data sets
##==========================================================================================
##Bring in features.txt
Features <- read.table("features.txt", header = FALSE)

##Bring in activity_table.txt
ActivityLabels <- read.table("activity_labels.txt", header=FALSE)

##Bring in subject_train.txt
SubjectTrain <- read.table("subject_train.txt", header=FALSE)

##Bring in x_train.txt
xTrain <- read.table("x_train.txt", header=FALSE)

##Bring in y_train.txt
yTrain <- read.table("y_train.txt", header=FALSE)

##Assign column names to the Training data set

##change v1 to ActivityID and v2 to ActivityType
colnames(ActivityLabels) <- c("ActivityID", "ActivityType")

##Change v1 to SubjectID
colnames(SubjectTrain) <- "SubjectID"

##replace column name with Features names listed in v2
colnames(xTrain) <- Features$V2

##Replace V1 with ActivityID
colnames(yTrain) <- "ActivityID"

##Read in test data

##Read in subject_test.txt
SubjectTest <- read.table("subject_test.txt", header=FALSE)
##Check dimensions

##Read in x_test.txt
xTest <- read.table("x_test.txt", header=FALSE)

##Read in x_test.txt
yTest <- read.table("y_test.txt", header=FALSE)
##Check dimensions

##Assign column names to the Test data set

##Change V1 to SubjectID
colnames(SubjectTest) <- "SubjectID"

##Change V2 to Features
colnames(xTest) <- Features$V2

##Change V1 to ActivityID
colnames(yTest) <- "ActivityID"

##Merge training data by columns
TrainMerged <- cbind(SubjectTrain, yTrain, xTrain)

##Merge test data by columns
TestMerged <- cbind(SubjectTest, yTest, xTest)

##Merge training and test data to one data set
AllData <- rbind(TrainMerged, TestMerged)

##====================================================================================
##2. Extract only the measurments on the mean and standard deviation for each measurement
##====================================================================================
##Create a character vector to include the column names of All Data for selection of desired variables
columnNames <- colnames(AllData)

##Create a logical vecto that will be used to select the mean and stand dev columns
MeanStdVector <- (grepl("Activity..", columnNames) | grepl("Subject..", columnNames) | grepl("std..", columnNames) | grepl("mean..", columnNames) & !grepl("-meanFreq", columnNames))

##Create final table with only Subject, activity, mean and standard dev data
MeanStdMeasures <- AllData[MeanStdVector == TRUE]

##========================================================================================
##3. Assign activity names to each activityID
##========================================================================================
##Merge the ActivityLabels and MeanStdMeasures tables together by the ActivityID column
MeanStdMeasures_2 <- merge(MeanStdMeasures, ActivityLabels, by = "ActivityID", all.x = TRUE)

##Rearrange columns so that Subject ID is first
MeanStdMeasures_2 <- MeanStdMeasures_2[, c(2,1,3, 4:69)]

##Add MeanStdMeasures_2 as a .txt file to directory
write.table(MeanStdMeasures_2, "./Data/MeanStdMeasures_2.txt", row.names=FALSE)

##Verify added file
list.files("./data")

##==============================================================================================
##4. Clean up the variable names.
##==============================================================================================
##Update the columnNames vector
columnNames <- colnames(MeanStdMeasures_2)

##tidy names
columnNames <- gsub("-std", "Std", columnNames)
columnNames <- gsub("-mean", "Mean", columnNames)
columnNames <- gsub("\\(\\)","", columnNames)
columnNames <- gsub("-", "", columnNames)
columnNames <- gsub("BodyBody", "Body", columnNames)

##Add the tidied column names to MeanStdMeasures_2
colnames(MeanStdMeasures_2) <- columnNames

##Make new tidied table
FinalData <- MeanStdMeasures_2

##Add FinalData as a .txt file to directory
write.table(FinalData, "./Data/FinalData.txt", row.names=FALSE)

##Verify added file
list.files("./data")

##===================================================================================================================
##5.  Create a second, independent tidy data set with the average of each variable for each activity and each subject
##===================================================================================================================
TidyData <- aggregate(FinalData, by=list(FinalData$ActivityID, FinalData$SubjectID), FUN = mean)

##Remove Activity Type 
TidyData[, "ActivityType"] = NULL

##Removes column that is identical to ActivityID
TidyData[,"Group.1"] = NULL

##Removes column taht is identical to SubjectID
TidyData[,"Group.2"] = NULL

##Reintroduce ActivityType into the TidyData
TidyData <- merge(TidyData, ActivityLabels, by = "ActivityID", all.x = TRUE)

##Rearrange columns
TidyData <- TidyData[, c(2,1,69, 3:68)]

##Sort table by SubjectID, then Activity ID
TidyData <- TidyData[order(TidyData$SubjectID, TidyData$ActivityID),]

##Clean up ActivityType variables
TidyData$ActivityType <- gsub("_", " ", TidyData$ActivityType)

##Write table to data folder
write.table(TidyData, "./data/TidyData.txt", row.names=FALSE)

##Verify file save
list.files("./data")