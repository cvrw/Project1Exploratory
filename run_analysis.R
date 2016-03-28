library(Hmisc)
library(plyr)
library(dplyr)
library(reshape2)
setwd("D:/NEW/R/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
features=read.table("features.txt")
length(features$V2)
################
#read train data
################
X_train=read.table("./train/X_train.txt")
head(X_train)
str(X_train)
Y_train=read.table("./train/Y_train.txt")
head(Y_train)
length(Y_train)
length(Y_train$V1)
summary(Y_train$V1)
subject_train=read.table("./train/subject_train.txt")
head(subject_train)
length(subject_train$V1)
summary(subject_train$V1)
#body_acc_x_train=read.table("./train/Inertial Signals/body_acc_x_train.txt")
#str(body_acc_x_train)
#str(body_acc_x_train$V128)
###
#label variables
###
data=X_train
var.labels=as.character(features$V2)
for (i in 1:561) {
label(data[[i]])=var.labels[i]
}
label(data)
###
#assign subject id's
###
id=subject_train$V1
data=mutate(data,id=id)
###
#assign activities and description
###
activity=Y_train$V1
data=mutate(data,activity=activity)
activity_labels=read.table("activity_labels.txt")
l=as.character(activity_labels$V2)
aux=1:7352
for (i in 1:7352) {
aux[i]=l[activity[i]]
}
data=mutate(data,activity_desc=aux)
dataTrain=data
label(dataTrain[["id"]])="subject id"
label(dataTrain[["activity"]])="activity index"
label(dataTrain[["activity_desc"]])="activity description"
save(dataTrain,file="data1.Rdata")
################
#read test data
################
X_test=read.table("./test/X_test.txt")
head(X_test)
str(X_test)
Y_test=read.table("./test/Y_test.txt")
head(Y_test)
length(Y_test)
length(Y_test$V1)
summary(Y_test$V1)
subject_test=read.table("./test/subject_test.txt")
head(subject_test)
length(subject_test$V1)
summary(subject_test$V1)
###
#label variables
###
data=X_test
var.labels=as.character(features$V2)
for (i in 1:561) {
label(data[[i]])=var.labels[i]
}
label(data)
###
#assign subject id's
###
id=subject_test$V1
data=mutate(data,id=id)
###
#assign activities and description
###
activity=Y_test$V1
data=mutate(data,activity=activity)
aux=1:2947
for (i in 1:2947) {
aux[i]=l[activity[i]]
}
data=mutate(data,activity_desc=aux)
dataTest=data
label(dataTest[["id"]])="subject id"
label(dataTest[["activity"]])="activity index"
label(dataTest[["activity_desc"]])="activity description"
save(dataTest,file="data2.Rdata")
################
#merge data
################
data=rbind(dataTrain,dataTest)
################
#get mean & std data
################
grep("mean()",features$V2)
ind_mean=grep("mean()",features$V2)
length(ind_mean)
ind_std=grep("std()",features$V2)
length(ind_std)
index=c(ind_mean,ind_std,c(562,563,564))
index=sort(index)
data=data[,index]
#label(data[["activity"]])="activity index"
label(data)
save(data,file="data.Rdata")
################
#create tidy data
################
dataMelt=melt(data,id=c("id","activity"),measure.vars=c("V1","V2","V3","V4","V5","V6","V41","V42","V43","V44","V45","V46","V81", "V82", "V83", "V84", "V85", "V86", "V542", "V543", "V552"))
#for sake of simplicity I haven't included all variables, 
#you can add them from the index variable for a complete answer
tidyData=dcast(dataMelt, id + activity ~ variable,mean)
save(tidyData,file="tidyData.Rdata")
write.table(tidyData,file="tidyData.txt",row.name=FALSE)