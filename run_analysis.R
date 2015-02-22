# # project
# #for simplicity, to check this code regarding the files it needs you should:
# 1.make a new folder
# 2.Set this new folder as your working directory
# 3.put this R file in to the new folder you made
# 4.Unzip the data for this projct,
# 		the data folder after unzipping called "UCI HAR Dataset". put this data 
# 		folder into the folder that you made.
# The directory format that I used is compatible with WIndows \\ is the seperator

library(dplyr)


### making one data.frame out of three _train.txt files
		# read the X_train.txt file into a data.fram
		trainData <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
		
		#Read the activity label for train data to a data.frame
		ActivityLable_Train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")
		
		#Read the subject data for the train set
		Subject_Train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
		
		#adding the "ActivityLable_Train" as a new column to the "trainData" data.frame
		trainData$Activity <- ActivityLable_Train$V1 
		
		#Adding "Subject_Train" as a new subject to the "trainData" data.frame
		trainData$Subject <- Subject_Train$V1

### making one data.frame out of three _test.txt files
		testData <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
		
		#Read the activity label for test data to a data.frame
		ActivityLable_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")
		
		#Read the subject data for the test set
		Subject_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
		
		#adding the "ActivityLable_test" as a new column to the "testData" data.frame
		testData$Activity <- ActivityLable_test$V1 
		
		#Adding "Subject_test" as a new subject to the "testData" data.frame
		testData$Subject <- Subject_test$V1

###implementing point1 of the project:
###Merge the training and the test sets to create one data set
		totalData <- rbind(trainData,testData)

###implementing point2 of the project:
###Extracts only the measurements on the mean and standard deviation for each measurement. 
   #read the feature.txt file 
		Feature_names <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\Features.txt", stringsAsFactors=FALSE)

		#getting the indices of the features that contains the "-mean()"
		indices_Contain_mean <- grep("mean", Feature_names$V2)

		#getting the indices of the features that contains the "-std()"
		indices_Contain_std <- grep("std", Feature_names$V2)

		#combine the two type indices related to mean ans std to have a vector of interested features
		#also we should includ the columns related to the activity and the subject: 562 & 563
    indices_contain_stdAndMean <- c(indices_Contain_mean, indices_Contain_std)
		indices_interested_features <- c(indices_contain_stdAndMean, 562, 563)

		# remove the columns of the "TotalData" that are not among the interested features
		totalData <- totalData[,indices_interested_features]

###implementing point3 of the project:
###Uses descriptive activity names to name the activities in the data set

		descriptive_activity_Data <- totalData
		descriptive_activity_Data <- mutate(descriptive_activity_Data, Activity = factor(Activity, labels= c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))

###implementing point4 of the project:
###Appropriately labels the data set with descriptive variable names.
		label <- Feature_names[indices_contain_stdAndMean,2]
		names(descriptive_activity_Data) <- c(label,"Activity", "Subject")


###implementing point5 of the project:
###From the data set in step 4, creates a second, independent tidy data set with the 
###average of each variable for each activity and each subject.
	Grouped_Data <- group_by(descriptive_activity_Data, Activity, Subject )
	Final_result <- summarise_each(Grouped_Data,funs(mean))

###Write the result as a .txt file 
write.table(Final_result, "ProjectResult.txt", row.name=FALSE)