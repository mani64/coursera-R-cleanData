This file has two parts: 
1. how to come to the current data structure from the origin data
2.The information about the acquired data: like the column name and number of observations etc.

Part 1:
To get the final data I took several steps:
1. Get the data required for this project from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2.Here I tried to combine all the information that I have for the training set which are three files together. I did the same for testing set.
		training set:
		To do so I read each file to a dataset. One dataset contains the measurements with lots of column, the two rest each has one column, Subject and activity. I added Activity and the Subject as two new columns for the measurement data.
		training set:
		I did exactly the same as the training set. 
		
		result for training set: number of rows= 7352, number of columns = 563
		result for testing set: number of rows= 2947, number of columns = 563
3. Merge the training and the test sets to create one data set
By now I have two main dataset: "trainData" and "testData". the first one has all the data for the traing set and the second one has all the data for the testing set. To merge these two to create one dataset as the question asked for, I just need to bind them using the "rbind" function. To use this function you should be sure that the columns of the two set have the same name. I take this to account in step1.

		result for the total set: number of rows= 10299, number of columns = 563
		
4. Extracts only the measurements on the mean and standard deviation for each measurement. 
To implement this I first read the file "Features.txt" to a data.frame and find the row-numbers in which the second column contains "mean" or "std" strings. Using the "grep" function.
The aquied indices are the columns that the question asked for. 
Not:Do not forger to append the indices of the two columns that you made in step0 to the acquired indices list as well.
		result for the total set: number of rows= 10299, number of columns = 81

5.Uses descriptive activity names to name the activities in the data set.
For this point you need to categorized the column "Activity". the column "Activity" has values from 1 to 6.
The best way in my opinion is to use factor! and overwrite the content of this column. I found the corresponding intuitive names for these numbers from the file "activity_labels.txt". I found it more easier to rewrite the column using the "mutate" from the "dplyr" package.

6. Appropriately labels the data set with descriptive variable names.
To solve this point, I used the indices that I got from the step4. Each indice points to a special row in the Features.txt file that it's second column contains "main" or "std". Using the indices I read the actual feature name string from the coressponding dataset that I made from the "Features.txt" file.
Note: be care full when you use the names() for assigning the column names, if you do not cover all the column here, those column will loose their previous labels.

7.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
From the data set in step 6, creates a second, independent tidy data set with the 
To solve this point the easiest way for me was to use the dplyr package mentioned in the lecture. Though to apply the mean to all the column I found  function called "summarise_each" which was not mentioned in the lectures.

Part 2:
Database Information: 
The result database shows the average of the following 79 extracted features for the following 6 different activities over 30 different persons. 
The result has 81 column. Two columns shows the Activity type and the person's id who performed it.
There are 180 observations in the dataset. 

The 6 different activities are:  
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

The 81 variables of the dataset:
