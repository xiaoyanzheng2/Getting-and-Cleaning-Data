## 1. Merge the training and the test sets to create one data set.

## step 1: download data
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData.zip")

## step 2: unzip data
listZip <- unzip("./data/projectData.zip", exdir = "./data")

## step 3: load data
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
## step 4: merge train and test data
train <- cbind(train.subject, train.y, train.x)
test <- cbind(test.subject, test.y, test.x)
full <- rbind(train, test)


## 2. Extract only the measurements on the mean and standard deviation for each measurement. 

## step 1: load feature name
featurename <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

## step 2:  extract mean and standard deviation of each measurements
featureindex <- grep(("mean()|std()"), featurename)
wearable <- full[, c(1, 2, featureindex+2)]
colnames(wearable) <- c("subject", "activity", featurename[featureindex])

## 3. Uses descriptive activity names to name the activities in the data set

## step 1: load activity data
activityname <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## step 2: replace 1 to 6 with activity names
wearable$activity <- factor(wearable$activity, levels = activityname[,1], labels = activityname[,2])

## 4. Appropriately labels the data set with descriptive variable names.

names(wearable) <- gsub("\\()", "", names(wearable))
names(wearable) <- gsub("^t", "time", names(wearable))
names(wearable) <- gsub("^f", "frequence", names(wearable))
names(wearable) <- gsub("-mean", "Mean", names(wearable))
names(wearable) <- gsub("-std", "Std", names(wearable))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
groupwearable <- wearable %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(groupwearable, "~/Desktop/Data Scientist/R Data/groupdata.txt", row.names = FALSE)

