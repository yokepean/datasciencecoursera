# read data
subject_test <- read.table("subject_test.txt")		# 2497x1
x_test <- read.table("X_test.txt") 				# 2947x561
y_test <- read.table("y_test.txt") 				# 2947x1
subject_train <- read.table("subject_train.txt")	# 7352x1
x_train <- read.table("X_train.txt")	 		# 7352x561
y_train <- read.table("y_train.txt")			# 7352x1
variables <- read.table("features.txt")			

# merge measurements only
dat <- rbind(x_test, x_train)					# 10299x561

# insert variable names
colnames(dat) <- variables[,2]

# extract measurements of means and standard deviations
datmeans <- dat[, grep("mean", colnames(dat))]	# mean measurements
datstd <- dat[, grep("std", colnames(dat))]	# standard deviation measuresments
datreq <- cbind(datmeans, datstd)			# combine measurements, 10299x79


# name activities for each measurement
labels <- c("1" = "walking", "2" = "walking upstairs", "3" = "walking downstairs", "4" = "sitting", "5" = "standing", "6" = "laying")	# define activity labels
labelall <- rbind(y_test, y_train)
library(plyr)
labelall_name <- revalue(as.factor(labelall[,1]), labels)

# merge measurements with activities and subjects
subjectall <- rbind(subject_test, subject_train)	# 10299x1
subjectall <- as.factor(subjectall[,1])
datall <- cbind(labelall_name, subjectall, datreq)	# 10299x81

# find average values for each activity and subject
s <- split(datall, list(datall$labelall_name, datall$subjectall))				# split data by activity and subject
datmeans <- sapply(s, function (x) colMeans(x[, colnames(datreq)], na.rm = TRUE))	# find average; activity and subject in columns
