train <- read.table("train/X_train.txt")[featuresWanted]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

####### prepare test datasets
test <- read.table("test/X_test.txt")[featuresWanted]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Load  labels and features
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract the data on mean and standard deviation
featuresneed <- grep(".*mean.*|.*std.*", features[,2])
featuresneed.names <- features[featuresneed,2]

# remove/replace '-' and '()'to make them more readable and less error-prone
featuresneed.names<-gsub('-mean', 'Mean', featuresneed.names)
featuresneed.names<-gsub('-std', 'Std', featuresneed.names)
featuresneed.names <- gsub('[-()]', '', featuresneed.names)
                           
                           
allData <- rbind(train, test)
# create a tidy data set with the average of each variable for each activity and each subject.
 colnames(allData) <- c("subject", "activity", featuresneed.names)
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)
                           
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)
                           
write.table(allData.mean, "tidy.txt", row.names = FALSE)
write.csv(tidy.csv, file = "tidy.csv")
