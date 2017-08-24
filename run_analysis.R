# 1. Merges the training and the test sets to create one data set.
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subject_all <- rbind(subject_train, subject_test)

# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement.
names(x_all) <- features[,2]
features <- read.table("features.txt", stringsAsFactors=FALSE)
matches <- features[,2][grep("*-(mean|std)\\(\\)*", features[,2])]
x_mean_std <- x_all[, matches]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(subject_all) <- "subject"
colnames(y_all) <-  "activity_number"
all_data <- cbind(x_mean_std, subject_all, y_all)
activity_labels <- read.table("activity_labels.txt", col.names = c("activity_number", "activity_name"))
all_data <- merge(all_data, activity_labels, by="activity_number", all.x=TRUE)

# 4. Appropriately labels the data set with descriptive variable names.
clean_names <- make.names(colnames(all_data))
clean_names <- gsub("\\.", " ", clean_names)
clean_names <- gsub("^(t|f)","",clean_names)
clean_names <- gsub("\\s+", " ", clean_names)
clean_names <- gsub("Acc", "Acceleration", clean_names)
clean_names <- gsub("GyroJerk", "AngularAcceleration", clean_names)
clean_names <- gsub("Gyro", "AngularSpeed", clean_names)
clean_names <- gsub("Mag", "Magnitude", clean_names)
clean_names <- gsub("std", "StandardDeviation", clean_names)

colnames(all_data) <- clean_names

# 5. creates a second, independent tidy data set with the average of each variable
# for each activity and each subject
library(plyr)
tidy_data <- ddply(all_data, c("subject","activity_name"))
write.table(tidy_data, file="tidy.txt", row.name=FALSE)