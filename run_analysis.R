# Step 1 :- Merges the training and the test sets to create one data set.
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")

subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")

X <- rbind(xTrain, xTest)
subject <- rbind(subjectTrain, subjectTest)
Y <- rbind(yTrain, yTest)

# Step 2 :-  Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("UCI HAR Dataset/features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, indices_of_good_features]
names(X) <- features[indices_of_good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))

# Step 3:- Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"

# Step 4 :- Appropriately labels the data set with descriptive variable names. 
names(subject) <- "subject"
cleanData <- cbind(subject, Y, X)


# Step 5 :- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
cleanTidyData <- aggregate(cleanData[3:ncol(cleanData)], 
                        list(ActivityName=cleanData$activity, SubjectId=cleanData$subject),
                        FUN=mean)

write.table(cleanTidyData, file="final_tidy_data.txt")
