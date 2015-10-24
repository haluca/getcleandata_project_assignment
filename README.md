## Introduction
This repository contains the data asked for in the course project 'Getting and Cleaning Data' (coursera getdata-033).

## Motivation
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare a tidy data that can be used for later analysis.

## Assignment 
The data to be processed represents data collected from the accelerometers from a Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained [1]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
Data for the project can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Tasks: 
* Create a R-script called run_analysis.R that does the following: 
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set.
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
* Upload the tidy data set created in step 5 of the instructions. Upload the data set as a txt file created with write.table() using row.name=FALSE.
* Submit a link to a Github repo with the code for performing the analysis. Include a README.md describing how all fits together and a code book (CodeBook.MD) that describes the variables, the data, and any transformations or work performed to clean up the data.

## Files
This repository contains the following files:
* README.md : this file
* run_analysis.R: contains the R code that reads the samsung dataset UCIHAR Dataset and produces a tidy dataset with average values for the mean and standarddeviations measurements for each activity and each subject
* CodeBook.MD: describes the output file of run_analysis.R (named 'wantedoutput.txt')
* wantedoutput.txt: example of the output, 180 rows (6 activities of 30 subjects) with 66 calculated averages of means and standarddeviations

## How does it work ?  
The UCIHAR dataset contains a README file with descriptions of the content of the files in the set. 
The file 'features_info.txt' describes the measured signals and calculated estimations stored in the dataset.

The script run_analyses.R does the following:  
a. making a datatable with the columns 'subject', 'activity' and the wanted variables with means and standarddeviations.
	1. Files 'x_test', 'x-train' contain the training data of the test en training sets. We merge the x-data into one datatable.
	2. The file 'features.txt' contains the list of all the features in the x-data. From this we add column names to the x-data.  
	3. We want averages for variables containing means and standarddeviations. Viewing the description of the features, we select only the columns with 'std()' or 'mean()' in the name.  
	4. Files 'subject-test', 'subject-train' contain the subject of the trainingdata: row n in the subjectdata shows the subject related to the data of row n in the x-file. we merge the subjectdata and add a colum 'subject' to the x-data
	5. Files 'y-test', 'y-train' contain the labels of the trainingdata: row n in the y-file shows the activity related to the data of row n in the x-file. The file 'activity-labels.txt' contains the descriptions of the activities y. We merge the y-data and add a column 'activity' to the x-data. We add the activity descriptions to the x-data instead of the 'meaningless' activitynumbers. 
b. tidy the datatable variable names  
c. summarizing the resulting x-data, calculating the means of the variables grouped by subject and activity.  
d. writing the summarized data to a txt-file 'wantedoutput.txt'.

## Installation
Run the run_analyse.R code from your working directory. 
Be sure the Samsung data is in your working directory, if not you can also download and unzip the files from the script by removing the 'comments' (#). 
The scripts puts a file 'wantedoutput.txt' in your working directory. 


[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
