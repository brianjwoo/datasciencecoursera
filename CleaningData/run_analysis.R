## The first step is to read the files into R

library(plyr)
library(reshape2)

activity_labels <- read.table('activity_labels.txt')
features <- read.table('features.txt')

subject_train <- read.table('subject_train.txt')
subject_test <- read.table('subject_test.txt')

X_train <- read.table('X_train.txt')
X_test <- read.table('X_test.txt')

y_train <- read.table('y_train.txt')
y_test <- read.table('y_test.txt')

#Adding the features labels to the colnames

colnames(X_train) <- features$V2
colnames(X_test) <- features$V2

##Merges the training and the test sets to create one data set.

train.complete <- cbind(subject = subject_train$V1, y=y_train$V1, X_train)
test.complete <- cbind(subject = subject_test$V1, y=y_test$V1, X_test)

merged <- rbind(train.complete,test.complete)


##Extracts only the measurements on the mean and standard deviation for each measurement. 

meanIndex <- grep("mean", colnames(merged))
stdIndex <- grep("std",colnames(merged))

merged.subset <- merged[,c(1,2,meanIndex,stdIndex)]

##Uses descriptive activity names to name the activities in the data set

merged.subset$y <- activity_labels$V2[merged.subset$y]

colnames(merged.subset)[2] <- 'Activity'

##Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

m.merged.subset <- melt(merged.subset, id = c('subject','Activity'))
mean.merged.subset <- dcast(m.merged.subset, subject + Activity ~ variable, mean)

write.table(mean.merged.subset, 'tidy.txt', row.name=FALSE)
