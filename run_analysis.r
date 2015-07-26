#Load the data from the files with training set.
train<-read.table("UCI HAR Dataset/train/X_train.txt")
train_a<-read.table("UCI HAR Dataset/train/y_train.txt")
train_s<-read.table("UCI HAR Dataset/train/subject_train.txt")


#Load the data from the files with test set.
test<-read.table("UCI HAR Dataset/test/X_test.txt")
test_a<-read.table("UCI HAR Dataset/test/y_test.txt")
test_s<-read.table("UCI HAR Dataset/test/subject_test.txt")
#Load the list of features.
features<-read.table("UCI HAR Dataset/features.txt")

#Initializing the result with all the observations with the activity index. 
Tidy<-rbind(cbind(subject=train_s,activity=train_a,train),cbind(subject=test_s,activity=test_a,test))

#Giving the columns proper names.
colnames(Tidy)<-c("subject","activity",as.character(features[,2]))
names<-as.character(colnames(Tidy))

#Identifying the indices with activity, mean and standard deviation of variables.
indices<-c("subject","activity",names[grep("-mean()",names)],names[grep("-std()",names)])
indices<-indices[order(indices)]

#Subsetting the Dataset to get the Tidy dataset required.
Tidy<-Tidy[,indices]

#Reading the activity lables from the activity_labels.txt file and then replacing the 
#numbers with corresponding labels in the activity column.
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
Tidy$activity<-activity$V2[Tidy$activity]


#Creating the second Tidy data set with the averages of each variable for each activity 
#and each subject.
Tidy2<-NULL

for(i in 1:30){
  for(j in 1:5){
    ind<-which(Tidy[,"subject"]==i&Tidy[,"activity"]==as.character(activity[j,2]), arr.ind=TRUE)
    Tidy2<-rbind(Tidy2, cbind(subject=i, activity=as.character(activity[j,2]), t(colMeans(Tidy[ind,3:81]))))       
  }
}

