---
output:
  pdf_document: default
  html_document: default
---
# CodeBook

## I. Human Activity Recognition Using Smartphones Data Set
A full description is available at the [site][L1] where the data was obtained. The `UCI HAR Dataset` directory with the raw data can be downloaded [here][L2], inside can be found a `README.txt` file with further details about this dataset. The directory is downloaded once the `run_analysis.R` script is runned.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## II. Script Description
The `run_analysis.R` script is an R file that performs the task required in the **Peer-graded Assignment: Getting and Cleaning Data Course Project**. Its final goal is to create a tidy data set, contained in the`Avg_Features.txt` file, using the [Human Activity Recognition Using Smartphones Data Set][L1] as the in input data. The steps followed to generate the tidy data are explained below.

  1. **Download the data:**
  
        ```{r}
        library(tidyverse)
        if(!dir.exists("./UCI HAR Dataset")){
                temp <- tempfile()
                URLdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(URLdata, temp, mode = "wb")
                unzip(temp, exdir = "./")
                unlink(temp)
        }
        ```
  2. **Read the files** corresponding to the training and test sets, as well as
  the labels for the activities names and the id of each subject.
  
        ```{r}
        act.lab <- read_table("./UCI HAR Dataset/activity_labels.txt",
                              col_names = c("lev", "lab"))
        subject.test <- read_table("./UCI HAR Dataset/test/subject_test.txt",
                           col_names = "Subject")
        X.test <- read_table("./UCI HAR Dataset/test/X_test.txt",
                     col_names = features$variables)
        Y.test <- read_table("./UCI HAR Dataset/test/y_test.txt",
                     col_names = "Activity")
        subject.train <- read_table("./UCI HAR Dataset/train/subject_train.txt",
                                    col_names = "Subject")
        X.train <- read_table("./UCI HAR Dataset/train/X_train.txt",
                              col_names = features$variables)
        Y.train <- read_table("./UCI HAR Dataset/train/y_train.txt",
                              col_names = "Activity")
        ```
        
  3. **Merge**  the test and training sets. This is achieved by first 
  joining the data related to each set in the data frames `test.data` and 
  `train.data` to finally merged them in the `tt.br` data frame.
  
        ```{r}
        # Assigning appropriated activity names.
        Y.test$Activity <- factor(Y.test$Activity,
                                  levels = act.lab$lev,
                                  labels = act.lab$lab)
        test.data <- bind_cols(subject.test, Y.test, X.test) %>%
                mutate(Group = rep("test", nrow(Y.test)), .after = Activity)
        
        # Assigning appropriated activity names.
        Y.train$Activity <- factor(Y.train$Activity,
                                   levels = act.lab$lev,
                                   labels = act.lab$lab)
        train.data <- bind_cols(subject.train, Y.train, X.train) %>%
                mutate(Group = rep("train", nrow(Y.train)), .after = Activity)
        
        # merging the data frames
        tt.br <- bind_rows(test.data, train.data)
        ```  
  At this point, the `tt.br` data frame contains the Subject and Activity
  variables with appropriate names and labels for the activities.
  
  4. Extracting only the measurement on the mean and standard deviation for each
  measurement, **the final tidy data set `Avg_Features.txt` is created** with
  the average of each variable for each activity and each subject.
  
        ```{r}
        tt.br <- tt.br %>%
                select(Subject, Activity, contains(match = c("mean", "std"))) %>%
                rename_with( function(namecols){
                        x <- namecols
                        x <- gsub("^t", "Time", x)
                        x <- gsub("Acc", "Accelerometer", x)
                        x <- gsub("Gyro", "Gyroscope", x)
                        x <- gsub("Mag", "Magnitude", x)
                        x <- gsub("^f", "Frequency", x)
                        x <- gsub("^a", "A", x)
                        x <- sub("-", ".", x)
                        x
                })
        # after the pipe process, tt.br is already tidy.
        
        # average of each variable for each activity and each subject. --------
        Avg_Feautures <- tt.br %>%
                group_by(Subject, Activity) %>%
                summarise_all(mean)
        
        write.table(Avg_Feautures, "Avg_Features.txt", row.names = FALSE )  
        ```


[L1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[L2]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip