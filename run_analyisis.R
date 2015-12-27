library(dplyr)
x_train<-read.table(".\\train\\X_train.txt",header=F)
y_train<-read.table(".\\train\\y_train.txt",header=F)
subject_train<-read.table(".\\train\\subject_train.txt")

x_test<-read.table(".\\test\\x_test.txt")
y_test<-read.table(".\\test\\y_test.txt")
subject_test<-read.table(".\\test\\subject_test.txt")

train<-cbind(y_train,subject_train,x_train)
test<-cbind(y_test,subject_test,x_test)

df<-rbind(train,test)

feature_names<-read.table("features.txt")
feature_names[,2]<-gsub("[[:punct:]]"," ",feature_names[,2])



colnames(df)[-c(1:2)]<-as.character(feature_names[,2])  ##assign descriptive column names to feature set. 
colnames(df)[1]<-"activity"
colnames(df)[2]<-"subject_id"



activity_lables<-read.table(".\\activity_labels.txt")
#for( i in 1:nrow(df)){
#  df[i,1]<-activity_lables[df[i,1],2]
  
#}
df<-df[,c(1,2,grep("mean()|std",colnames(df)))]


##attach activity label to activity ids.
df<-mutate(df,activity=activity_lables[activity,2])
df<-mutate(df,subject_id=as.factor(subject_id))





df2<-as.data.frame(df %>% group_by(activity,subject_id) %>% summarise_each(funs(mean)))
write.table(df2,"clean_data.txt",row.names = F)


