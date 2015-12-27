This document describe how the run_analysis.R script works. The order of operation is not exactly same as the original step, the filter by column step is done at the second last step. 


First, it reads the train data set together with subject ids.

```{r eval=FALSE}
x_train<-read.table(".\\train\\X_train.txt",header=F)
y_train<-read.table(".\\train\\y_train.txt",header=F)
subject_train<-read.table(".\\train\\subject_train.txt")
```
and it does the same on the test set. 
```{r eval=FALSE}
x_test<-read.table(".\\test\\x_test.txt")
y_test<-read.table(".\\test\\y_test.txt")
subject_test<-read.table(".\\test\\subject_test.txt")
```
combine data with corresponding subject and activity IDs.
```{r eval=FALSE}
train<-cbind(y_train,subject_train,x_train)
test<-cbind(y_test,subject_test,x_test)
```

merge train and test set
```{r eval=FALSE}
df<-rbind(train,test)
```

Read original feature names and simplify them, rename the columns with new names

```{r eval=FALSE}
feature_names<-read.table("features.txt")
feature_names[,2]<-gsub("[[:punct:]]"," ",feature_names[,2])
colnames(df)[-c(1:2)]<-as.character(feature_names[,2])  
colnames(df)[1]<-"activity"
colnames(df)[2]<-"subject_id"
```

get label to replace activity Id
```{r eval=FALSE}
activity_lables<-read.table(".\\activity_labels.txt")
```

Only reserve columns with mean and std
```{r eval=FALSE}
df<-df[,c(1,2,grep("mean()|std",colnames(df)))]

```

attach activity label to activity ids and mutate subject id to factor
```{r eval=FALSE}
df<-mutate(df,activity=activity_lables[activity,2])
df<-mutate(df,subject_id=as.factor(subject_id))
```
Group data by activity and subject id, and then summerize by mean. 
```{r eval=FALSE}
df2<-as.data.frame(df %>% group_by(activity,subject_id) %>% summarise_each(funs(mean)))
```
Write the dataframe into a table, without outputing row names.
```{r eval=FALSE}
write.table(df2,"clean_data.txt",row.names = F)
```