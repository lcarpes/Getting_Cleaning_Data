# This script is related to the data cleaning of an experiment that was performed with 30 volunteers, 
# in the range of 19 to 48 years.
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# using a smartphone (Samsung Galaxy S II) at the waist.
#
# It does the following activities:
#
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)

#Download file .zip and decompressing
if(!file.exists("UCI HAR Dataset")){

  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipArq<-"getdata_projectfiles_UCI HAR Dataset.zip"
  download.file(fileUrl, zipArq)
  unzip(zipArq)
}

#Reading training and test data
SubjectTrain<-read.table("UCI HAR Dataset/train/subject_train.txt")
XTrain<-read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<-read.table("UCI HAR Dataset/train/y_train.txt")

SubjectTest<-read.table("UCI HAR Dataset/test/subject_test.txt")
XTest<-read.table("UCI HAR Dataset/test/X_test.txt")
YTest<-read.table("UCI HAR Dataset/test/y_test.txt")

#Reading additional data
Features<-read.table("UCI HAR Dataset/features.txt")
Activity<-read.table("UCI HAR Dataset/activity_labels.txt")

#Putting together data from Training with Test
TotalTrain<-cbind(SubjectTrain, YTrain, XTrain)
TotalTest<-cbind(SubjectTest, YTest, XTest)
TotalDados<-rbind(TotalTrain, TotalTest)

#Changing column names 
Features$V2<-gsub("std", "StandardDeviation", Features$V2)
Features$V2<-gsub("^t", "Time", Features$V2)
Features$V2<-gsub("^f", "Frequency", Features$V2)
Features$V2<-gsub("mean", "Mean", Features$V2)
Features$V2<-gsub("Gyro", "Gyroscope", Features$V2)
Features$V2<-gsub("Acc", "Acceleration", Features$V2)
Features$V2<-gsub("Mag", "Magnitude", Features$V2)

#Naming the Data Columns
colnames(TotalDados)<- c("Subject", "Activity_Id", Features$V2)
colnames(Activity)<-c("Activity_Id", "Activity")

#Selecting only the columns with mean a std
ColunasMean<-grep("Subject|Activity|Mean|StandardDeviation", names(TotalDados))
TotalDados<-(TotalDados[,ColunasMean])

#Accomplishing the description of the activity
TotalDados<-merge(TotalDados, Activity, by.x="Activity_Id", by.y="Activity_Id")
TotalDados<-select(TotalDados, -Activity_Id)

#Creation of the Second Data Group
Saida<-group_by(TotalDados, Subject, Activity )
write.table(summarize_all(Saida, list((mean))), "TidyData", row.names = FALSE)
  


