#!/bin/bash

library(reshape2)

# 1
# Merges the training and the test sets to create one
# data set.

TrainData<-read.table("UCI HAR Dataset/train/X_train.txt")
TrainSubjects<-read.table("UCI HAR Dataset/train/subject_train.txt")
TrainLabels<-read.table("UCI HAR Dataset/train/y_train.txt")
Train<-cbind(TrainSubjects,TrainLabels,TrainData)

TestData<-read.table("UCI HAR Dataset/test/X_test.txt")
TestSubjects<-read.table("UCI HAR Dataset/test/subject_test.txt")
TestLabels<-read.table("UCI HAR Dataset/test/y_test.txt")
Test<-cbind(TestSubjects,TestLabels,TestData)

DataSet<-rbind(Train,Test)

# 2
# Extracts only the measurements on the mean and
# standard deviation for each measurement.

Features<-read.table("UCI HAR Dataset/features.txt")
Features[,2]<-as.character(Features[,2])
FeaturesGrep<-grep(".*mean.*|.*std.*", Features[,2])
FG1<-FeaturesGrep+2
DS1<-DataSet[,c(1:2,FG1)]

# 3
# Uses descriptive activity names to name the
# activities in the data set

Activities<-read.table("UCI HAR Dataset/activity_labels.txt")
Activities[,2]<-as.character(Activities[,2])
DS1$V1.1<-factor(DS1$V1.1,
    levels=Activities[,1],
    labels=Activities[,2])

# 4
# Appropriately label the data set with descriptive
# variable names.

FeaturesGrep.names<-Features[FeaturesGrep,2]
FeaturesGrep.names<-gsub('-mean', 'Mean', FeaturesGrep.names)
FeaturesGrep.names<-gsub('-std', 'Std', FeaturesGrep.names)
FeaturesGrep.names<-gsub('[-()]', '', FeaturesGrep.names)
colnames(DS1)<-c("Subjects","Labels",FeaturesGrep.names)

# 5
# From the data set in step 4, creates a second,
# independent tidy data set with the average of each
# variable for each activity and each subject.

DS1$Subjects<-as.factor(DS1$Subjects)
DS2<-melt(data=DS1,id.vars=c("Subjects","Labels"))
DS3<-dcast(data=DS2,Subjects+Labels~variable,mean)
write.table(DS3,"tidy.txt",quote=F)