library(plyr)
library(dplyr)

#read the data
subjecttest<-read.table("test/subject_test.txt")
subjecttrain<-read.table("train/subject_train.txt")
xtest<-read.table("test/X_test.txt")
ytest<-read.table("test/Y_test.txt")
xtrain<-read.table("train/X_train.txt")
ytrain<-read.table("train/y_train.txt")

#1.Merges the training and the test sets to create one data set.
x<-rbind(xtest,xtrain)
y<-rbind(ytest,ytrain)
subject<-rbind(subjecttest,subjecttrain)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
feature<-read.table("features.txt")
only<-grep("-(mean|std)\\(\\)", feature[, 2])
x<-x[,only]

#3.Uses descriptive activity names to name the activities in the data set.
activity<-read.table("activity_labels.txt")
y[,1]<-activity[y[,1],2]

#4.Appropriately labels the data set with descriptive variable names. 
names(x)<-feature[only,2]
names(y)<-"activity"
names(subject)<-"subject"
result<-cbind(x,y,subject)
names(result)<-gsub('Acc','Acceleration',names(result))
names(result)<-gsub('Mag','Magnitude',names(result))
names(result)<-gsub('Freq\\.','Frequency',names(result))
names(result)<-gsub('Freq$','Frequency',names(result))


#5.From the data set in step 4,
# creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.

tidy<-ddply(result, c("subject","activity"), numcolwise(mean))
write.table(tidy,file="averages_data.txt",row.name=FALSE)
