library(data.table)
# Reading text files data
activityLabels<- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
features<- read.table("./UCI HAR Dataset/features.txt")

# Reading Test data
test_activity<- read.table("./UCI HAR Dataset/test/y_test.txt")
test_features<- read.table("./UCI HAR Dataset/test/X_test.txt")
test_subject<- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Reading Table Data
train_activity<- read.table("./UCI HAR Dataset/train/y_train.txt")
train_features<- read.table("./UCI HAR Dataset/train/X_train.txt")
train_subject<- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Binding data tables by row
Activity<- rbind(test_activity,train_activity)
Feature<- rbind(test_features,train_features)
Subject<- rbind(test_subject,train_subject)

# Naming the column of data tables
names(Activity)<-"Activity"
names(Subject)<-"Subject"
names(Feature)<- features$V2

#binding data tables by column
combine<- cbind(Activity, Subject)
CombineData<- cbind(combine,Feature)

#Get data of only mean() and std()
selectedData<- CombineData[,grep("mean\\(\\)|std\\(\\)|Activity|Subject", names(CombineData))]

#Factorize the activity Column
selectedData$Activity<- as.factor(selectedData$Activity)

#Assigning descriptive names to the Activity from activity labels
levels(selectedData$Activity)<- activityLabels[,2]

#Assigning suitable names to variables
names(selectedData)<-gsub("^t", "Time", names(selectedData))
names(selectedData)<-gsub("^f", "Frequency", names(selectedData))
names(selectedData)<-gsub("Acc", "Accelerometer", names(selectedData))
names(selectedData)<-gsub("Gyro", "Gyroscope", names(selectedData))
names(selectedData)<-gsub("Mag", "Magnitude", names(selectedData))
names(selectedData)<-gsub("BodyBody", "Body", names(selectedData))

AggregatedData<- aggregate(. ~Subject + Activity, selectedData, mean)
FinalData<-AggregatedData[order(AggregatedData$Subject,AggregatedData$Activity),]
write.table(FinalData, "tidyDataset.txt", row.names = FALSE, quote = FALSE, sep = '\t')
