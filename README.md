project solution:

There are some steps that you should take in order to make this code to work:
1. Get the data required for this project from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
		unzip the data folder and put the "run_analysis.R" in the folder called "UCI HAR Dataset".
2. Set the folder "UCI HAR Dataset" as your working directory.
3. Install the package "plyr"	
Note: My machine is a windows system, so in the directory addresses in the code I used "\\" if you have other operating system you should change this.
		e.g. in the code I used : "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt"
				
Code explanation:
I used the "dplr" package for manipulating the data.frames.

////////////////////////////////////////////////Step0 - Concept Explanation ///////////////////////////////////////////////////////////
Here I tried to combine all the information that I have for the training set which are three files together. I did the same for testing set.
training set:
To do so I read each file to a dataset. One dataset contains the measurements with lots of column, the two rest each has one column, Subject and activity. I added Activity and the Subject as two new columns for the measurement data.
training set:
I did exactly the same as the training set.

////////////////////////////////////////////////Step0 - Code Explanation    ///////////////////////////////////////////////////////////
making one data.frame out of three _train.txt files
		#read the X_train.txt file into a data.fram
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

////////////////////////////////////////////////Step1 - Concept Explanation ///////////////////////////////////////////////////////////
implementing point1 of the project:

Merge the training and the test sets to create one data set
By now I have two main dataset: "trainData" and "testData". the first one has all the data for the traing set and the second one has all the data for the testing set. To merge these two to create one dataset as the question asked for, I just need to bind them using the "rbind" function. To use this function you should be sure that the columns of the two set have the same name. I take this to account in step0.

////////////////////////////////////////////////Step1 -Code Explanation    ///////////////////////////////////////////////////////////
		totalData <- rbind(trainData,testData)

////////////////////////////////////////////////Step2 - Concept Explanation ///////////////////////////////////////////////////////////
implementing point2 of the project:

Extracts only the measurements on the mean and standard deviation for each measurement. 
To implement this I first read the file "Features.txt" to a data.frame and find the row-numbers in which the second column contains "mean" or "std" strings. Using the "grep" function.
The aquied indices are the columns that the question asked for. 
Not:Do not forger to append the indices of the two columns that you made in step0 to the acquired indices list as well.

////////////////////////////////////////////////Step2 - Code Explanation ///////////////////////////////////////////////////////////
#read the feature.txt file 
		Feature_names <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\Features.txt", stringsAsFactors=FALSE)

		#getting the indices of the features that contains the "-mean()"
		indices_Contain_mean <- grep("mean", Feature_names$V2)

		#getting the indices of the features that contains the "-std()"
		indices_Contain_std <- grep("std", Feature_names$V2)

		#combine the two type indices related to mean ans std to have a vector of interested features
		#also we should includ the columns related to the activity and the subject: 562 & 563
		Indices_contain_stdAndMean <- c(indices_Contain_mean, indices_Contain_std)
		indices_interested_features <- c(Indices_contain_stdAndMean, 562, 563)

		# remove the columns of the "TotalData" that are not among the interested features
		totalData <- totalData[,indices_interested_features]

////////////////////////////////////////////////Step3 - Concept Explanation ///////////////////////////////////////////////////////////
implementing point3 of the project:

Uses descriptive activity names to name the activities in the data set.
For this point you need to categorized the column "Activity". the column "Activity" has values from 1 to 6.
The best way in my opinion is to use factor! and overwrite the content of this column. I found the corresponding intuitive names for these numbers from the file "activity_labels.txt". I found it more easier to rewrite the column using the "mutate" from the "dplyr" package.

////////////////////////////////////////////////Step3 - Code Explanation ///////////////////////////////////////////////////////////
		descriptive_activity_Data <- totalData
		descriptive_activity_Data <- mutate(descriptive_activity_Data, Activity = factor(Activity, labels= c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))

////////////////////////////////////////////////Step4 - Concept Explanation ///////////////////////////////////////////////////////////		
implementing point4 of the project:

Appropriately labels the data set with descriptive variable names.
To solve this point, I used the indices that I got from the step2. Each indice points to a special row in the Features.txt file that it's second column contains "main" or "std". Using the indices I read the actual feature name string from the coresspomding dataset that I made from the "Features.txt" file.
Note: becare full when you use the names() for assigning the column names, if you do not cover all the column here, those column will loose their previous labes.

////////////////////////////////////////////////Step4 - Code Explanation ///////////////////////////////////////////////////////////		 
		label <- Feature_names[Indices_contain_stdAndMean,2]
		names(descriptive_activity_Data) <- c(label,"Activity", "Subject")

////////////////////////////////////////////////Step5 - Concept Explanation ///////////////////////////////////////////////////////////	
implementing point5 of the project:

From the data set in step 4, creates a second, independent tidy data set with the 
To solve this point the easirest way for me was to use the dplyr package mentioned in the lecture. Though to apply the mean to all the column I found  function called "summarise_each" which was not mentioned in the lectures.

////////////////////////////////////////////////Step5 - Code Explanation ///////////////////////////////////////////////////////////	
###average of each variable for each activity and each subject.
	Grouped_Data <- group_by(descriptive_activity_Data, Activity, Subject )
	Final_result <- summarise_each(Grouped_Data,funs(mean))
	
/////////////////////////////////////////// Final Step////////////////////////////////////////////////////////////////////////////////////
This line of the code write the final result as a txt file in to your working directory.
###Write the result as a .txt file 
write.table(Final_result, "ProjectResult.txt", row.name=FALSE)

