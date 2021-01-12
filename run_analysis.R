# Checklist: download and read the files ----------------------------------

# Download the data
library(tidyverse)
if(!dir.exists("./UCI HAR Dataset")){
        temp <- tempfile()
        URLdata <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(URLdata, temp, mode = "wb")
        unzip(temp, exdir = ".")
        unlink(temp)
}
rm(list = ls())

# read the txt files. read_table2 read it without specifying the delim.
features <- read_delim("./UCI HAR Dataset/features.txt", 
                       delim = " ", col_names = c("n", "variables"))
# the following data frames will be merged, thus the variables will be named
# appropriately to make it easier.
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

# Merge the training and test sets -------------------------------

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

# average of each variable for each activity and each subject. ------------
Avg_Feautures <- tt.br %>%
        group_by(Subject, Activity) %>%
        summarise_all(mean)

write.table(Avg_Feautures, "Avg_Features.txt", row.names = FALSE )