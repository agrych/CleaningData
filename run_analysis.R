## load the libraries
library(reshape2)

## load the data tab-delimited
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
featureNames <- read.table("features.txt")

### APPROPRIATELY LABELS THE DATASET WITH DESCRIPTIVE VARIABLE NAMES
# rename the columns  
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(y_train) <- "activity"
names(y_test) <- "activity"
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

### MERGE THE TRAINING AND THE TEST SETS TO CREATE ONE DATASET
# Subsetting and sorting video
#join two data frames horizontally without specifying a common key
#each object has to have the same number of rows and be sorted in the same order
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

#join two data frames vertically
#don't have to be in the same order but must have the same variables
thejoining <- rbind(train, test)

### EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
# identify the desired columns and return a logical vector
#Using grepl() for filtering
mean_std <- grepl("subjectID", colnames(thejoining)) | grepl("activity", colnames(thejoining)) | grepl("mean\\(\\)", colnames(thejoining)) | grepl("std\\(\\)", colnames(thejoining))

# select all rows and extract identified columns in mean_std as a data frame named thetall
thetall <- thejoining[, mean_std]

### USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATASET
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# created a factor variable called combined$activity based upon the numeric order of the data
# the first label, Walking, will correspond to combined$activity=0 and the second label, Walking Upstairs, will
# correspond to combined$activity=1, etc. (the order of the labels will follow the numeric order of the data)
thetall$activity <- factor(thetall$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

### CREATE A SECOND, INDEPENDENT TIDY DATASET WITH THE MEAN OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
# Reshaping data video
thewide <- melt(thetall, id=c("subjectID","activity"))
#data frame output of the transposition from long to wide
#want to see mean for each variable by subjectID by activity (in that order) 
tidydata <- dcast(thewide, subjectID+activity ~ variable, mean)

### WRITE THE TIDY DATASET TO A FILE 
#suppressing row names
write.table(tidydata, "tidydata.txt", row.names=FALSE)

# Automatically Create an HTML Codebook using R Markdown
library(rmarkdown)
#use the markdown file codebook.rmd to create the HTML document
render("codebook.rmd", html_document())