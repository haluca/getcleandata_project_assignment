## Introduction
This CodeBook describes the content of the dataset 'wantedoutput.txt'. 
The dataset 'wantedoutput.txt' is made using the R-script 'run-analyses.R', performed on the "Human Activity Recognition Using Smartphones Data Set" (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
See the README, features.txt and features_info.txt files in the original dataset to learn more about the measurements taken from the accelerometer and gyroscope and variables estimated from these signals.
features are normalized and bounded within [-1,1]. The original set contains a set of testdata and a set of trainingdata. These sets are merged.  
See also the README file in this repo to learn more about the choosen solution.  

## run_analysis.R, how it works
* using dplyr
  	library(dplyr)
* testdata and trainingdata is read into datatabels and merged together: subject, x_test and y_test
  	subjecttot<-rbind(read.table("./UCI HAR Dataset/test/subject_test.txt"),read.table("./UCI HAR Dataset/train/subject_train.txt"))
  	xtemp<-rbind(read.table("./UCI HAR Dataset/test/x_test.txt"),read.table("./UCI HAR Dataset/train/x_train.txt"))
  	ytot<-rbind(read.table("./UCI HAR Dataset/test/y_test.txt"),read.table("./UCI HAR Dataset/train/y_train.txt"))
* the feature names are read into a datatable and assigned as colnames to the x-data.
  	features<-read.table("./UCI HAR Dataset/features.txt")
  	names(xtemp)<-features[,2]
* only columns containing 'std()' and 'mean()' are selected (first delete columns with duplicate names) 
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

## Dataset
The dataset 'wantedoutput.txt' contains the average for each activity and subject on the mean and standarddeviation measuruments from the original dataset.
66 measurements for each of the 6 activities for each of the 30 subjects: 180 rows of 68 variables. 

* "activity" :
  	activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING
, STANDING, LAYING
)
* "subject"  :
  	subject (1:30)
* Calculated means for each activity,subject (66 variables):
  	"tbodyaccstandarddeviationx" "tbodyaccstandarddeviationy" "tbodyaccstandarddeviationz" "tgravityaccstandarddeviationx" "tgravityaccstandarddeviationy" "tgravityaccstandarddeviationz" "tbodyaccjerkstandarddeviationx" "tbodyaccjerkstandarddeviationy" "tbodyaccjerkstandarddeviationz" "tbodygyrostandarddeviationx" "tbodygyrostandarddeviationy" "tbodygyrostandarddeviationz" "tbodygyrojerkstandarddeviationx" "tbodygyrojerkstandarddeviationy" "tbodygyrojerkstandarddeviationz" "tbodyaccmagstandarddeviation" "tgravityaccmagstandarddeviation" "tbodyaccjerkmagstandarddeviation" "tbodygyromagstandarddeviation" "tbodygyrojerkmagstandarddeviation"  "fbodyaccstandarddeviationx" "fbodyaccstandarddeviationy" "fbodyaccstandarddeviationz" "fbodyaccjerkstandarddeviationx" "fbodyaccjerkstandarddeviationy" "fbodyaccjerkstandarddeviationz" "fbodygyrostandarddeviationx" "fbodygyrostandarddeviationy" "fbodygyrostandarddeviationz" "fbodyaccmagstandarddeviation" "fbodybodyaccjerkmagstandarddeviation" "fbodybodygyromagstandarddeviation" "fbodybodygyrojerkmagstandarddeviation" "tbodyaccmeanx" "tbodyaccmeany" "tbodyaccmeanz" "tgravityaccmeanx" "tgravityaccmeany" "tgravityaccmeanz" "tbodyaccjerkmeanx" "tbodyaccjerkmeany" "tbodyaccjerkmeanz" "tbodygyromeanx" "tbodygyromeany" "tbodygyromeanz" "tbodygyrojerkmeanx" "tbodygyrojerkmeany" "tbodygyrojerkmeanz" "tbodyaccmagmean" "tgravityaccmagmean" "tbodyaccjerkmagmean" "tbodygyromagmean" "tbodygyrojerkmagmean" "fbodyaccmeanx" "fbodyaccmeany" "fbodyaccmeanz" "fbodyaccjerkmeanx" "fbodyaccjerkmeany" "fbodyaccjerkmeanz" "fbodygyromeanx" "fbodygyromeany" "fbodygyromeanz" "fbodyaccmagmean" "fbodybodyaccjerkmagmean" "fbodybodygyromagmean" "fbodybodygyrojerkmagmean"

## example (head(xtidy,3))
* activity subject tbodyaccstandarddeviationx tbodyaccstandarddeviationy tbodyaccstandarddeviationz tgravityaccstandarddeviationx
  1.   LAYING       1                 -0.9280565                 -0.8368274                 -0.8260614                    -0.8968300
  2.   LAYING       2                 -0.9740595                 -0.9802774                 -0.9842333                    -0.9590144
  3.   LAYING       3                 -0.9827766                 -0.9620575                 -0.9636910                    -0.9825122
* tgravityaccstandarddeviationy tgravityaccstandarddeviationz tbodyaccjerkstandarddeviationx tbodyaccjerkstandarddeviationy
  1.                    -0.9077200                    -0.8523663                     -0.9584821                     -0.9241493
  2.                    -0.9882119                    -0.9842304                     -0.9858722                     -0.9831725
  3.                    -0.9812027                    -0.9648075                     -0.9808793                     -0.9687107
* tbodyaccjerkstandarddeviationz tbodygyrostandarddeviationx tbodygyrostandarddeviationy tbodygyrostandarddeviationz tbodygyrojerkstandarddeviationx
  1.                     -0.9548551                  -0.8735439                  -0.9510904                  -0.9082847                      -0.9186085
  2.                     -0.9884420                  -0.9882752                  -0.9822916                  -0.9603066                      -0.9932358
  3.                     -0.9820932                  -0.9745458                  -0.9772727                  -0.9635056                      -0.9803286
* tbodygyrojerkstandarddeviationy tbodygyrojerkstandarddeviationz tbodyaccmagstandarddeviation tgravityaccmagstandarddeviation
  1.                      -0.9679072                      -0.9577902                   -0.7951449                      -0.7951449
  2.                      -0.9895675                      -0.9880358                   -0.9728739                      -0.9728739
  3.                      -0.9867627                      -0.9833383                   -0.9642182                      -0.9642182
* tbodyaccjerkmagstandarddeviation tbodygyromagstandarddeviation tbodygyrojerkmagstandarddeviation fbodyaccstandarddeviationx fbodyaccstandarddeviationy
  1.                       -0.9282456                    -0.8190102                        -0.9358410                 -0.9244374                 -0.8336256
  2.                       -0.9855181                    -0.9611641                        -0.9897181                 -0.9732465                 -0.9810251
  3.                       -0.9761213                    -0.9542751                        -0.9831393                 -0.9836911                 -0.9640946
* fbodyaccstandarddeviationz fbodyaccjerkstandarddeviationx fbodyaccjerkstandarddeviationy fbodyaccjerkstandarddeviationz fbodygyrostandarddeviationx
  1.                 -0.8128916                     -0.9641607                     -0.9322179                     -0.9605870                  -0.8822965
  2.                 -0.9847922                     -0.9872503                     -0.9849874                     -0.9893454                  -0.9888607
  3.                 -0.9632791                     -0.9831226                     -0.9710440                     -0.9837119                  -0.9759864
* fbodygyrostandarddeviationy fbodygyrostandarddeviationz fbodyaccmagstandarddeviation fbodybodyaccjerkmagstandarddeviation
  1.                  -0.9512320                  -0.9165825                   -0.7983009                           -0.9218040
  2.                  -0.9819106                  -0.9631742                   -0.9751214                           -0.9845685
  3.                  -0.9770325                  -0.9672569                   -0.9683502                           -0.9753054
* fbodybodygyromagstandarddeviation fbodybodygyrojerkmagstandarddeviation tbodyaccmeanx tbodyaccmeany tbodyaccmeanz tgravityaccmeanx tgravityaccmeany
  1.                        -0.8243194                            -0.9326607     0.2215982   -0.04051395    -0.1132036       -0.2488818        0.7055498
  2.                        -0.9610984                            -0.9894927     0.2813734   -0.01815874    -0.1072456       -0.5097542        0.7525366
  3.                        -0.9554419                            -0.9825682     0.2755169   -0.01895568    -0.1013005       -0.2417585        0.8370321
* tgravityaccmeanz tbodyaccjerkmeanx tbodyaccjerkmeany tbodyaccjerkmeanz tbodygyromeanx tbodygyromeany tbodygyromeanz tbodygyrojerkmeanx
  1.        0.4458177        0.08108653       0.003838204       0.010834236    -0.01655309    -0.06448612      0.1486894         -0.1072709
  2.        0.6468349        0.08259725       0.012254788      -0.001802649    -0.01847661    -0.11180082      0.1448828         -0.1019741
  3.        0.4887032        0.07698111       0.013804101      -0.004356259    -0.02081705    -0.07185072      0.1379996         -0.1000445
* tbodygyrojerkmeany tbodygyrojerkmeanz tbodyaccmagmean tgravityaccmagmean tbodyaccjerkmagmean tbodygyromagmean tbodygyrojerkmagmean fbodyaccmeanx
  1.        -0.04151729        -0.07405012      -0.8419292         -0.8419292          -0.9543963       -0.8747595           -0.9634610    -0.9390991
  2.        -0.03585902        -0.07017830      -0.9774355         -0.9774355          -0.9877417       -0.9500116           -0.9917671    -0.9767251
  3.        -0.03897718        -0.06873387      -0.9727913         -0.9727913          -0.9794846       -0.9515648           -0.9867136    -0.9806656
* fbodyaccmeany fbodyaccmeanz fbodyaccjerkmeanx fbodyaccjerkmeany fbodyaccjerkmeanz fbodygyromeanx fbodygyromeany fbodygyromeanz fbodyaccmagmean
  1.    -0.8670652    -0.8826669        -0.9570739        -0.9224626        -0.9480609     -0.8502492     -0.9521915     -0.9093027      -0.8617676
  2.    -0.9798009    -0.9843810        -0.9858136        -0.9827683        -0.9861971     -0.9864311     -0.9833216     -0.9626719      -0.9751102
  3.    -0.9611700    -0.9683321        -0.9805132        -0.9687521        -0.9791223     -0.9701673     -0.9780997     -0.9623420      -0.9655243
* fbodybodyaccjerkmagmean fbodybodygyromagmean fbodybodygyrojerkmagmean
  1.              -0.9333004           -0.8621902               -0.9423669
  2.              -0.9853741           -0.9721130               -0.9902487
  3.              -0.9759496           -0.9645867               -0.9842783
> 