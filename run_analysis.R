# The following script assumes the unzipped file folder UCI HAR Dataset is
# located in your working directory. i.e. you are in the parent directory of the
# folder. This will ensure any saved R outputs are kept separate from the data.

# Load in descriptive variable names from features.txt as a vector
variable_names<-as.character(read.table("./UCI HAR Dataset/features.txt",
    header=FALSE,sep="")[,2])
# Select only mean and sd variable names by index number. Exclude meanFreq data.
variables_mean_sd<-c(grep("mean",variable_names),
    grep("std",variable_names))
variables_noFreq<-c(grep("meanFreq",variable_names,invert=TRUE))
variables_wanted<-intersect(variables_mean_sd,variables_noFreq)

# Order selected index numbers low to high
variables_wanted<-variables_wanted[order(variables_wanted)]

# Load in labels for activities as a vector
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",
                            header=FALSE)[,2]

# Load ID numbers for training data set
id_train<-as.numeric(readLines("./UCI HAR Dataset/train/subject_train.txt"))
# Create a variable to tell the user which data set the data came from
dataset_train<-rep("train",length(id_train))
# Load activity data as numeric vector; convert to factor & apply descriptive labels
activity_train<-as.numeric(readLines("./UCI HAR Dataset/train/y_train.txt"))
activity_train<-factor(activity_train,labels=activity_labels)
# Read in the main data set for training
raw_train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE,
                      sep="",colClasses="numeric")
# Name the variables from the descriptive variable names list
names(raw_train)<-variable_names
# Select only the mean and standard deviation measures for each variable
trimmed_train<-raw_train[,variables_wanted]
# Combine the id, dataset, activity and main data in a training data set
combined_train_data<-cbind(id=id_train,dataset=dataset_train,
                           activity=activity_train,trimmed_train)

# See comments for traiing data set; uses same approach
id_test<-as.numeric(readLines("./UCI HAR Dataset/test/subject_test.txt"))
dataset_test<-rep("test",length(id_test))
activity_test<-as.numeric(readLines("./UCI HAR Dataset/test/y_test.txt"))
activity_test<-factor(activity_test,labels=activity_labels)
raw_test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE,
                      sep="",colClasses="numeric")
names(raw_test)<-variable_names
trimmed_test<-raw_test[,variables_wanted]
combined_test_data<-cbind(id=id_test,dataset=dataset_test,
                          activity=activity_test,trimmed_test)

# Merge into a single combined data set and give nicer variable names (esp no brackets)

samsung_data<-rbind(combined_train_data,combined_test_data)
names(samsung_data)<-c("id","dataset","activity","t.BodyAcc.mean.X","t.BodyAcc.mean.Y","t.BodyAcc.mean.Z",
    "t.BodyAcc.sd.X","t.BodyAcc.sd.Y","t.BodyAcc.sd.Z","t.GravityAcc.mean.X","t.GravityAcc.mean.Y",
    "t.GravityAcc.mean.Z","t.GravityAcc.sd.X","t.GravityAcc.sd.Y","t.GravityAcc.sd.Z","tBodyAccJerk.mean.X",
    "tBodyAccJerk.mean.Y","tBodyAccJerk.mean.Z","t.BodyAccJerk.sd.X","t.BodyAccJerk.sd.Y","t.BodyAccJerk.sd.Z",
    "t.BodyGyro.mean.X","t.BodyGyro.mean.Y","t.BodyGyro.mean.Z","t.BodyGyro.sd.X","t.BodyGyro.sd.Y",
    "t.BodyGyro.sd.Z","t.BodyGyroJerk.mean.X","t.BodyGyroJerk.mean.Y","t.BodyGyroJerk.mean.Z",
    "t.BodyGyroJerk.sd.X","t.BodyGyroJerk.sd.Y","t.BodyGyroJerk.sd.Z","t.BodyAccMag.mean","t.BodyAccMag.sd",
    "t.GravityAccMag.mean","t.GravityAccMag.sd","t.BodyAccJerkMag.mean","t.BodyAccJerkMag.sd","t.BodyGyroMag.mean",
    "t.BodyGyroMag.sd","t.BodyGyroJerkMag.mean","t.BodyGyroJerkMag.sd","f.BodyAcc.mean.X","f.BodyAcc.mean.Y",
    "f.BodyAcc.mean.Z","f.BodyAcc.sd.X","f.BodyAcc.sd.Y","f.BodyAcc.sd.Z","f.BodyAccJerk.mean.X",
    "f.BodyAccJerk.mean.Y",    "f.BodyAccJerk.mean.Z","f.BodyAccJerk.sd.X","f.BodyAccJerk.sd.Y","f.BodyAccJerk.sd.Z",
    "f.BodyGyro.mean.X","f.BodyGyro.mean.Y","f.BodyGyro.mean.Z","f.BodyGyro.sd.X","f.BodyGyro.sd.Y","f.BodyGyro.sd.Z",
    "f.BodyAccMag.mean","f.BodyAccMag.sd","f.BodyAccJerkMag.mean","f.BodyAccJerkMag.sd","f.BodyGyroMag.mean",
    "f.BodyGyroMag.sd","f.BodyGyroJerkMag.mean","f.BodyGyroJerkMag.sd")

# Produce consolidated tidy data file with single case for each
# activity - subject combination, shoing the mean of each variable
# in previous data set
samsung_data_condensed<-aggregate(samsung_data[,4:69],by=list(id=samsung_data$id,
            dataset=samsung_data$dataset,activity=samsung_data$activity),mean)
            
# The following line cleans up the intermediate data, leaving only the two data
# sets (condensed and full). Uncomment and run if required.

# rm(activity_labels,activity_test,activity_train,combined_test_data,
 #combined_train_data,dataset_test,dataset_train,id_test,id_train,raw_test,
 #raw_train,trimmed_test,trimmed_train,variable_names,variables_wanted)
