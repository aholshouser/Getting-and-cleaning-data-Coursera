#Load Test and Training data sets
test_data<-read.table("X_test.txt", header=FALSE)
test_data_A<-read.table("y_test.txt", header= FALSE)
train_data<-read.table("X_train.txt", header = FALSE)
train_data_A<-read.table("y_train.txt", header=FALSE)

#Load subjects, features, and activities
test_sub<-read.table("subject_test.txt", header = FALSE)
train_sub<-read.table("subject_train.txt", header=FALSE)
Feat<-read.table("features.txt", header=FALSE)
Act<-read.table("activity_labels.txt", header=FALSE, colClasses = "character")

#Merges the training and the test sets to create one data set.
Set_B<-rbind(test_data,train_data)
Set_A<-rbind(test_data_A,train_data_A)
Subject<-rbind(test_sub, train_sub)

#Extracts only the measurements on the mean and standard deviation for each measurement
MS<-grep("-(mean|std)\\(\\)", Feat[, 2])
Set_B<- Set_B[, MS]
names(Set_B)<-Feat[MS,2]

#Use descriptive activity names to name the activities in the data set
Set_A[,1]<-Act[Set_A[,1],2]
names(Set_A)<-"Activity"
#Appropriately label the data set with descriptive variable names
names(Subject)<-"Subject"
mergedata<-cbind(Set_B,Set_A,Subject)

#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for
#each activity and each subject.

TD<-ddply(mergedata, .(Subject, Activity), function(y) colMeans(y[, 1:66]))
write.table(TD,"tidy_data.txt", row.name = FALSE)