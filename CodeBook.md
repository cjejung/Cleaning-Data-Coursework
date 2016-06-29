# Code Book
## Introduction
This codebook describes the dataset called `tidyset` obtained when running the `run_analysis.R` code.
The code was created as part of the coursework for the Coursera 'Getting & Cleaning Data' course.

## Key facts
The dataset `tidyset` contains 180 rows and 68 columns.

## Description of the variables

**subject** - identifies the subject who performed the activities. Its range is from 1 to 30.

**activity** - identifies the activity performed by the subject for which the measurements have been taken. activity can be one of: WALKING, WALKING-UPSTAIRS, WALKING-DOWNSTAIRS, SITTING, STANDING or LAYING

The remaining 66 variables contain the average of the mean and standard deviation of each of the measurements taken during the experiments.

For more information about the variables and the experiments, please refer to the following website: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]

## Data transformations

The original dataset, which consisted of a training and test set, has been merged and labelled with the lookup tables provided. Only the mean and standard deviations of the measurement variables have been kept. All variables have been aggregated to represent the average across all subjects and activities. 

## Experimental study design & more information about the data

For more information about the experimental design and the data, please refer to the following website:
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]
