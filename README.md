## Introduction
This repository contains the data asked for in the course project 'Getting and Cleaning Data' (coursera getdata-033).

## Motivation
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## Assignment 
The data to be processed represents data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained [1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
Data for the project can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Create a R-script called run_analysis.R that does the following: 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
=> Upload the tidy data set created in step 5 of the instructions. Upload the data set as a txt file created with write.table() using row.name=FALSE.
=> Submit a link to a Github repo with the code for performing the analysis. Include a README.md in describing how the script works and the code book describing the variables.

## Files
This repository cotains the following files:
* README.md : this file
* run_analysis.R: contains the R code that reads the samsung dataset UCIHAR Dataset and produces a tidy dataset with average values for the mean and standarddeviations measurements for each activity and each subject
* CodeBook.MD: describes the ouput file of run_analysis.R (wantedoutput.txt)
* wantedoutput.txt: example of the output, 180 rows (6 activities of 30 subjects) with 66 calculated averages of means and standarddeviations

## How it works
* testdata and trainingdata is read into datatabels and merged together: subject, x_test and y_test
  	subjecttot<-rbind(read.table("./UCI HAR Dataset/test/subject_test.txt"),read.table("./UCI HAR Dataset/train/subject_train.txt"))
  	xtemp<-rbind(read.table("./UCI HAR Dataset/test/x_test.txt"),read.table("./UCI HAR Dataset/train/x_train.txt"))
  	ytot<-rbind(read.table("./UCI HAR Dataset/test/y_test.txt"),read.table("./UCI HAR Dataset/train/y_train.txt"))
* the feature names are read into a datatable and assigned as colnames to the x-data.
  	features<-read.table("./UCI HAR Dataset/features.txt")
  	names(xtemp)<-features[,2]
* Only columns containing 'std()' and 'mean()' are selected (first delete columns with duplicate names) 
  	xtemp<- xtemp[, !duplicated(colnames(xtemp))]
  	xtot<-select(xtemp,contains("std()"))
  	xtot<-cbind(xtot,select(xtemp,contains("mean()")))
* subjects (in the subjectdata) are added to the x-data
  	xtot<-cbind(subject=as.factor(subjecttot$V1),xtot)
* activitynames are read into a datatable, the names of the activities (in the y-data) are added to the x-data
  	activitylabels<-read.table("./UCI HAR Dataset/activity_labels.txt")
  	xtemp<-activitylabels$V2[ytot$V1]
  	xtot<-cbind(activity=xtemp,xtot)
* tidy variable names: removing '_', "()", lowercase, abbreviations
  	names(xtot)<-gsub("-","",names(xtot))
  	names(xtot)<-gsub("\\()","",names(xtot))
  	names(xtot)<-tolower(names(xtot))
  	names(xtot)<-gsub("std","standarddeviation",names(xtot))
* group, summarize averages by activity-subject
  	xgroup<-xtot %>% group_by(activity,subject)
  	xtidy<- xgroup %>% summarise_each(funs(mean)) 
* write output
  	write.table(xtidy,file="wantedoutput.txt", row.names=FALSE)

## Installation
Run the run_analyse.R code from your working directory. 
Be sure the Samsung data is in your working directory, if not you can also download and unzip the files from the script by removing the 'comments' (#). 
The scripts puts a file 'wantedoutput.txt' in your working directory with the wanted tidy data.  


[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
