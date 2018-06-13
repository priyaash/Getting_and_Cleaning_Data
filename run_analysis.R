getwd()
setwd("D:/profile/desktop/UCI HAR Dataset")
getwd()
library(readr)
library(dplyr)
feature_name<-read.table("features.txt")
our_features<- grep("mean|std",feature_name$V2)
train_features<-read.table("train/X_train.txt")
our_train_features<- train_features[,our_features]
test_features<- read.table("test/X_test.txt")
our_test_features<-test_features[,our_features]
total_features<- rbind(our_train_features, our_test_features)
colnames(total_features)<-feature_name[our_features,2]
train_activities<-read.table("train/Y_train.txt")
test_activities<-read.table("test/Y_test.txt")
total_activities<-rbind(train_activities, test_activities)
activity_labels<-read.table("activity_labels.txt")
total_activities$activities<-factor(total_activities$V1, levels = activity_labels$V1, labels = activity_labels$V2)
# step 5
# extract the trian and test subject data and merge
train_subjects<- read.table("train/subject_train.txt")
test_subjects<- read.table("test/subject_test.txt")
total_subjects<-rbind(train_subjects, test_subjects)

#step6
#link the subjects to their activity
subject_activity<-cbind(total_subjects, total_activities$activities)
colnames(subject_activity)<-c("subjectID", "activity")

#step7
#combine activity,ID and measurement in a data frame
activity_df<-cbind(subject_activity, total_features)

#step8
#create tidy data set with average of each variable
tidy_data<-aggregate(activity_df[,3:(ncol(activity_df))], by = list(activity_df$subjectID, activity_df$activity), FUN = mean)
colnames(tidy_data)[1:2]<-c("subject.id","activity")
write.table(tidy_data, file = "mean_tidy_data.txt", row.names = FALSE)

