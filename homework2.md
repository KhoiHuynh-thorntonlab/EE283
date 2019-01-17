
## transforming data with base R

```
data <- read.csv("D:/data.txt", sep="")

matrix <- as.matrix(data)
location <- which(matrix==1,arr.ind = TRUE)

data$rownumber <- row(data,as.factor=FALSE)
data$`9`<-abs(data$rownumber-location[3,1])
data$`8`<-abs(data$rownumber-location[2,1])
data$`3`<-abs(data$rownumber-location[1,1])
data$closest <- colnames(data[,3:5])[apply(data[,3:5],1,which.min)]
data
data$rownumber<-NULL
data$`3`<-NULL
data$`9`<-NULL
data$`8`<-NULL
data

```


## transforming data with tidyverse:


```
library(tidyverse)
library(readr)

tdata <- read_csv("D:/data.txt")

matrix<-as.matrix(tdata)
location <- which(matrix==1,arr.ind = TRUE)

testdata <- tdata %>% mutate(value,rownumber=row(tdata,as.factor=FALSE),`3`=abs(rownumber-location[1,1]),`8`=abs(rownumber-location[2,1]),`9`=abs(rownumber-location[3,1]),minimum=pmin(`3`,`8`,`9`),compare3= if_else(minimum == `3`, 3,0),compare8= if_else(minimum == `8`, 8,0),compare9= if_else(minimum == `9`, 9,0)) %>% rowwise() %>% mutate(closest=sum(compare3,compare8,compare9)) %>% select(value,closest)


testdata


```
