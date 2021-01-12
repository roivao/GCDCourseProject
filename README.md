# Getting and Cleaning Data Course Project
This repository contains the files for submission required in the Getting and Cleaning Data Course Project. The goal is to prepare tidy data that can be used later for analysis. The raw data and the instructions, that include how the files work and how are they connected, are explained next.

## Raw Data
The data is a database built from the recording of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors:

[Human Activity Recognition.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

A full description is available at the [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained.

## Instructions
1. Clone or download the repository on your local computer

2. `run_analysis.R` was scripted using R version 4.0.3. Before running the script, **confirm that the `GCDCourseProject` directory is your working directory.**

3. Execute `run_analysis.R`. As a result, `Avg_Features.txt` which contains the final tidy data and the `UCI HAR Dataset` directory with the raw data, will be created.

* `run_analysis.R` script prepares (download and read) the data to perform the following:

        1. Merges the training and the test sets to create one data set.
        
        2. Extracts only the measurement on the mean and standard
        deviation for each measurement.
        
        3. Uses descriptive activity names to name the activities in the
        data set.
        
        4. Appropriately labels the data set with descriptive variable 
        names.
        
        5. From the data set in step 4, creates a second, independent tidy
        data set with the average of each variable for each activity and 
        each subject.

* `codebook.md` describes the variables, the data, and any transformation
or work performed to clean up the data.

* `Avg_Features.txt` contains the final tidy data set with the average of each variable for each activity and each subject. This file is created after executing `run_analysis.R`. 