library(data.table)
library(tidyverse)

setwd("./runAnalysis/")

#########################################################################
## Loading all the relevant text files: data and labels with fread()
## simultaneaously combine test and train data sets with bind_rows()
## NOTE: Assumes data file is already downloaded and unzipped in ./runAnalysis/
#########################################################################
rundata <- bind_rows(fread("./test/X_test.txt"), fread("./train/X_train.txt"))
labels <- bind_rows(fread("./test/y_test.txt"), fread("./train/y_train.txt"))
subject <- bind_rows(fread("./test/subject_test.txt"), fread("./train/subject_train.txt"))
features <- fread("features.txt")
activities <- fread("activity_labels.txt")

#########################################################################
## Apply labels to data set
#########################################################################
labels <- labels %>% left_join(activities)    #join the label names to the label code
rundata <- bind_cols(labels, rundata)         #bind the ctivity labels to the data set
rundata <- bind_cols(subject, rundata)        #bind the subject ID to the data set

features <- features %>% unite(feature, V1,V2)#bind the row number to the variable name 
                                              #  due to a duplicate variable name issue that was occuring 
features <- c("Subject", "ActivityLabel", "Activity", features$feature)#append bound column headings to the data set column headings
names(rundata) <- features                    #Apply all the headings to the data set

rm(list=c("labels", "activities", "features", "subject"))  #cleanup the workspace

#########################################################################
## Filter and summarize the data set
#########################################################################
rundata <- rundata %>%
  select(matches("mean\\(\\)|std\\(\\)|^Activity$|^Subject$")) #uses Regex to match column names to select

rundata_tidy <- rundata %>%
  group_by(Subject, Activity) %>%             
  summarize_all(mean)                         #summarizes all the columns by the grouping, applying mean()