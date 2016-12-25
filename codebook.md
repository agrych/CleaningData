---
title: "CODEBOOK.MD"
author: "AG"
date: "December 23, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# CODEBOOK.RMD

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. According to Princeton.edu, a codebook is a technical description of the data that was collected for a particular purpose. It describes how the data are arranged in the computer file or files, what the various numbers and letters mean, and any special instructions on how to use the data properly (Available from http://dss.princeton.edu/online_help/analysis/codebook.htm)  

# Initial Dataset Information
1. Description of the study: Human Activity Recognition Using Smartphones Dataset
   The experiments have been carried out with a group of 30 volunteers within an age
   bracket of 19-48 years. Each person performed six activities (WALKING,
   WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a
   smartphone (Samsung Galaxy S II) on the waist. 
   
   Citation: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
   Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using
   Smartphones. 21th European Symposium on Artificial Neural Networks, Computational
   Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

2. Sampling information: Human Activity Recognition database built from the
   recordings of 30 subjects within an age bracket of 19-48 years performing
   activities of daily living (ADL) while carrying a waist-mounted smartphone with
   embedded inertial sensors. Using its embedded accelerometer
   and gyroscope, we captured 3-axial linear acceleration and 3-axial angular
   velocity at a constant rate of 50Hz. The experiments have been video-recorded to
   label the data manually. 

3. Technical information about the files themselves: 
   Dataset Characteristics: Multivariate, Time-Series
   Number of Instances: 10299
   Number of Attributes: 561
   Missing Values: N/A
   The obtained dataset has been randomly partitioned into two sets, where 70% of
   the volunteers was selected for generating the training data and 30% the test
   data. 
   Attribute Information:  For each record in the dataset it is provided:
       - Triaxial acceleration from the accelerometer (total acceleration) and 
         the estimated body acceleration.
       - Triaxial Angular velocity from the gyroscope.
       - A 561-feature vector with time and frequency domain variables.
       - Its activity label.
       - An identifier of the subject who carried out the experiment. 

# Create a subset of the initial dataset that includes the mean of each variable for each activity and each subject

The following numeric columns will be in the subset dataset:

    The following signals were used to estimate variables of the feature vector for
    each pattern:  
    '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

    tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ,
    tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
    tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag,
    fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag

    The set of variables that were estimated from these signals are: 
    mean(): Mean value
    std(): Standard deviation

    Additional vectors obtained by averaging the signals in a signal window sample.
    These are used on the angle() variable:
    
    gravityMean, ,tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean

## load the libraries
```{r load-libraries}
#install.packages("reshape2")
library(reshape2)
```
## load the data
```{r load-data}
# Subject ids for training group
subject_train <- read.table("subject_train.txt")
# train group descriptive statistics
X_train <- read.table("X_train.txt")
# train group activity number: 1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS,
# 4 SITTING, 5 STANDING, 6 LAYING
y_train <- read.table("y_train.txt")
# Subject ids for test group
subject_test <- read.table("subject_test.txt")
# test group descriptive statistics
X_test <- read.table("X_test.txt")
# train group activity number: 1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS,
# 4 SITTING, 5 STANDING, 6 LAYING
y_test <- read.table("y_test.txt")
# column names for x_train and x_test datasets
featureNames <- read.table("features.txt")
```
### APPROPRIATELY LABELS THE DATASET WITH DESCRIPTIVE VARIABLE NAMES
```{r assign-columns}
# rename columns so can identify mean and standard deviation columns 
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(y_train) <- "activity"
names(y_test) <- "activity"
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
```
### MERGE THE TRAINING AND THE TEST SETS TO CREATE ONE DATASET
```{r merge-data}
# Subsetting and sorting video
#join two data frames horizontally without specifying a common key
#each object has to have the same number of rows and be sorted in the same order
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

#join two data frames vertically
#don't have to be in the same order but must have the same variables
thejoining <- rbind(train, test)
```
### EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
```{r filter-columns}
# identify the desired columns and return a logical vector
# Using grepl() for filtering
mean_std <- grepl("subjectID", colnames(thejoining)) | grepl("activity", colnames(thejoining)) | grepl("mean\\(\\)", colnames(thejoining)) | grepl("std\\(\\)", colnames(thejoining))
```

```{r select-columns}
# select all rows and extract identified columns in mean_std as a data frame named thetall
thetall <- thejoining[, mean_std]
```
### USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATASET
```{r add-names}
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# created a factor variable called combined$activity based upon the numeric order of the data
# the first label, Walking, will correspond to combined$activity=0 and the second label, Walking Upstairs, will
# correspond to combined$activity=1, etc. (the order of the labels will follow the numeric order of the data)
thetall$activity <- factor(thetall$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
```
### CREATE A SECOND, INDEPENDENT TIDY DATASET WITH THE MEAN OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
```{r create-tidydata}
# Reshaping data video
thewide <- melt(thetall, id=c("subjectID","activity"))
#data frame output of the transposition from long to wide
#want to see mean for each variable by subjectID by activity (in that order) 
tidydata <- dcast(thewide, subjectID+activity ~ variable, mean)
```
### WRITE THE TIDY DATASET TO A FILE
```{r write-tidydata}
write.table(tidydata, "tidydata.txt", row.names=FALSE)
```
##variables created
```{r}
colnames(tidydata)
```