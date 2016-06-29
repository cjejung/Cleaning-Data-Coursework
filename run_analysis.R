
## 0. Download and prepare the data 

# create the download directory
if (!file.exists("./data")) { dir.create("./data") }

# set the download url & destination
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "./data/dataset.zip"

# download the file if it wasn't downloaded already
if(!file.exists(filename)) {download.file(fileurl, destfile = filename)}

# unzip the data if not done so already
if (!file.exists("./data/UCI HAR Dataset")) {unzip(filename, exdir = "./data")}


## 1. merge the training and test sets to create one dataset

# read the training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# read the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# merge the data
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)


## 2. keep only the measurements on the mean and standard deviation

# read the features and activities labels
features <- read.table("./data/UCI HAR Dataset/features.txt",
                       stringsAsFactors = FALSE)[,2]

# keep only the wanted measurements
index2keep <- grep("mean\\(\\)|std\\(\\)", features)
x_all <- x_all[,index2keep]


# 3. assign descriptive activity names to name the activities in the data set

# read activities labels
activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",
                             stringsAsFactors = FALSE)
# assign descriptive names
y_all$V1 <- factor(y_all$V1, 
                   levels = activitylabels[,1],
                   labels = activitylabels[,2])


## 4. label the data set with descriptive variable names

# get the feature labels
featurelabels <- features[index2keep]

# format the feature labels
featurelabels <- gsub("\\(\\)", "", featurelabels) # remove ()
featurelabels <- gsub("mean", "Mean", featurelabels) # capitalize mean
featurelabels <- gsub("std", "Std", featurelabels) # capitalize std
featurelabels <- gsub("-", "_", featurelabels) # replace - with _

# assign the formated names
names(x_all) <- featurelabels
names(y_all) <- "activity"
names(subject_all) <- "subject"

# combine all data
dataset <- cbind(subject_all, y_all, x_all)

## 5. create a tidy data set with the average of each variable 
##    for each activity and each subject.

# load packages
library(dplyr)

# calculate the mean of each variable for each activity & subject
tidyset <- dataset %>% group_by(subject, activity) %>% summarise_each(funs(mean))

# write the table to export
write.table(tidyset, file ="tidyset.txt")
