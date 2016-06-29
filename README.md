# Cleaning-Data-Coursework

## About this repository
This repository contains the R code, output data and codebook for the coursework project for the Coursera course entitled 'Getting and Cleaning Data'.

The data upon which the analisis was based on can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description of the dataset can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Aim of the code
The aim of the code is to collect and clean the provided data set to create a tidy data that can be used for later analysis. The data represent measurements collected from the accelerometers from the Samsung Galaxy S smartphone.

All code has been stored in `run_analysis.R`. Below is a description of the scripts, how they work and how they are connected.

## The script

The code starts by setting environment creating the download directory, if it doesn't exist already.
```
if (!file.exists("./data")) { dir.create("./data") }
```

Next the code sets downloads the data and unzips the zip file. If the data has already been downloaded or unziped the steps are skipped.

```
# set the download url & destination
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "./data/dataset.zip"

# download the file if it wasn't downloaded already
if(!file.exists(filename)) {download.file(fileurl, destfile = filename)}

# unzip the data if not done so already
if (!file.exists("./data/UCI HAR Dataset")) {unzip(filename, exdir = "./data")}
```

### Step 1: Merge the data
The data tables are then read into data frames, both for the training and test sets:
```
# read the training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# read the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
```

The individual each set type (x: the measurement data, y: the activity label and subject: the subject id that performed the activity) is merged using the `merge` function:
```
# merge the data
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)
```

### Step 2: Keep only the mean and standard deviations

All measurement names are read into a vector called `features`:
```
# read the features and activities labels
features <- read.table("./data/UCI HAR Dataset/features.txt",
                       stringsAsFactors = FALSE)[,2]
```
The `stringAsFactors = FALSE` ensures that we get a character vector rather than factors. The `[,2]` makes sure we only load the names, which are stored in the second column of the loaded data frame.

Next, we identify which columns to keep. We do this by seaching for "mean()" or "std()" in the feature names. All features containing either character string are indexed in a variable called `index2keep`, which is used to select only the relevant variables from our data set:
```
# keep only the wanted measurements
index2keep <- grep("mean\\(\\)|std\\(\\)", features)
x_all <- x_all[,index2keep]
```

### Step 3: Assign descriptive activity names

Activity names are stored in a different table, which is loaded into a data frame called `activitylabels`:
```
# read activities labels
activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",
                             stringsAsFactors = FALSE)
```

A factor is applied to the activities stores in the activites tables. The factor labels are set to be the names stored in the `activitylabels` table:
# assign descriptive names
```
y_all$V1 <- factor(y_all$V1, 
                   levels = activitylabels[,1],
                   labels = activitylabels[,2])
```

### Step 4: Label the dataset with descriptive variable names

First the variable names are extracted and formated:
```
# get the feature labels
featurelabels <- features[index2keep]

# format the feature labels
featurelabels <- gsub("\\(\\)", "", featurelabels) # remove ()
featurelabels <- gsub("mean", "Mean", featurelabels) # capitalize mean
featurelabels <- gsub("std", "Std", featurelabels) # capitalize std
featurelabels <- gsub("-", "_", featurelabels) # replace - with _
```

All variables are being assigned their names:
```
# assign the formated names
names(x_all) <- featurelabels
names(y_all) <- "activity"
names(subject_all) <- "subject"
```

To create the final dataset, the three tables are combined using `cbind`:
```
# combine all data
dataset <- cbind(subject_all, y_all, x_all)
```

### Step 5: Create a tiday data set

The data set will be aggregated using the dplyr package, so all the package needs to be loaded:
```
# load packages
library(dplyr)
```

The mean for each variable for each activity and subject is calcuated using the `summarise_each` function, which applies a function to all columns in a dataset. we specify this function to be the mean through `funs(mean)`. By grouping the data set by subject and activity we make sure the data is summarised at this level.
```
# calculate the mean of each variable for each activity & subject
tidyset <- dataset %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```

The resulting data set `tidyset` is tidy data and can be exported.
```
# write the table to export
write.table(tidyset, file ="tidyset.txt")
```


