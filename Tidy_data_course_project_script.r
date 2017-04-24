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

#Use descriptive activity names to name the activities in the data set
test_data_A$V1<-factor(test_data_A$V1, levels=Act$V1, labels=Act$V2)
train_data_A$V1<-factor(train_data_A$V1, levels=Act$V1, labels=Act$V2)
merge_y<-rbind(test_data_A,train_data_A)

#Appropriately labels the data set with descriptive variable names
colnames(test_data)<-Feat$V2
colnames(train_data)<-Feat$V2
colnames(test_data_A)<-c("Act")
colnames(train_data_A)<-c("Act")
colnames(test_sub)<-c("Sub")
colnames(train_sub)<-c("Sub")

#Merges the training and the test sets to create one data set.
testset_A<-cbind(test_data,test_data_A)
test_data_c<-cbind(testset_A,test_sub)
trainset_A<-cbind(train_data,train_data_A)
train_data_c<-cbind(trainset_A,train_sub)
Merged_TE_TR<-rbind(test_data_c, train_data_c)

#Extracts only the measurements on the mean and standard deviation for each measurement
Merged_TE_TR_std<-sapply(Merged_TE_TR,sd,na,rm=TRUE)
Merged_TE_TR_mn<-sapply(Merged_TE_TR,mean,na.rm=TRUE)

#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for
#each activity and each subject.
library(data.table)
tidy_data<-data.table(Merged_TE_TR)
TD<-tidy_data[,lapply(.SD,mean), by="Act,Sub"]
write.table(TD,file="tidy_data_extract.csv",sep=",",row.names=FALSE)