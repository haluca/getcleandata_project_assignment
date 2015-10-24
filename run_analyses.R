library(dplyr)

## download and unzip dataset (remove "###" if the data is not allready in your working directory)  
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,"acm.zip")
unzip("acm.zip")

## read labels
features<-read.table("./UCI HAR Dataset/features.txt")
activitylabels<-read.table("./UCI HAR Dataset/activity_labels.txt")

## read subject and subjectdata, bind test and train sets
subjecttot<-rbind(read.table("./UCI HAR Dataset/test/subject_test.txt"),read.table("./UCI HAR Dataset/train/subject_train.txt"))
xtemp<-rbind(read.table("./UCI HAR Dataset/test/x_test.txt"),read.table("./UCI HAR Dataset/train/x_train.txt"))
ytot<-rbind(read.table("./UCI HAR Dataset/test/y_test.txt"),read.table("./UCI HAR Dataset/train/y_train.txt"))

## naming variables of x-data, deleting columns with duplicate names    
names(xtemp)<-features[,2]
xtemp<- xtemp[, !duplicated(colnames(xtemp))]

## x-data: only columns with mean() and std(), adding subject fromsubjectdata and activitylabel from activitylabels in ytot 
xtot<-select(xtemp,contains("std()"))
xtot<-cbind(xtot,select(xtemp,contains("mean()")))
xtot<-cbind(subject=as.factor(subjecttot$V1),xtot)
xtemp<-activitylabels$V2[ytot$V1]
xtot<-cbind(activity=xtemp,xtot)

## xtidy: tidy names and summarize the main of each column group by activity, subject 
names(xtot)<-gsub("-","",names(xtot))
names(xtot)<-gsub("\\()","",names(xtot))
names(xtot)<-tolower(names(xtot))
names(xtot)<-gsub("std","standarddeviation",names(xtot))

xgroup<-xtot %>% group_by(activity,subject)
xtidy<- xgroup %>% summarise_each(funs(mean))

rm(xtemp,ytot,xtot,subjecttot,features,activitylabels,xgroup)
rm(fileurl)

## write table
write.table(xtidy,file="wantedoutput.txt", row.names=FALSE)

