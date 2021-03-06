library(RJSONIO) # To parse JSON strings
library(RCurl) # To send GET requests
json <- getURL("http://giv-cyclop.uni-muenster.de/rest/index.php/measurements/after/2012-01-01")
x <- fromJSON(json) # Converts it to an R list
x$features[[1]]$properties
y<-matrix (x$features[[1]]$properties)
tempdata<- (c(y[2,1]))
tempdata
midata<- (c(y[1,1]))
midata

l<-length(x$features)

i<-1

repeat {
  i<-i+1
  if (i <= l) 
    y<-matrix (x$features[[i]]$properties)
  tempdata<- (c(tempdata,y[7,1]))
  tempdata
  midata<- (c(midata,y[1,1]))
  midata
  if (i> l) break
}

temp<-matrix(tempdata)
temp

table<-data.frame(temp)
table


#mean of temp table (all values)
x<-as.numeric(c(temp))
x
mean<-mean(x)

#standard deviation
sd(x)
sd<-sd(x)

#variane
var(x) 
v<-var(x)


#Time and date
time<-format(Sys.time(), "%a %b %d %X %Y %Z")
time
mid<-matrix(midata) 
mid

#########load Data in PostgreSQL
library(RPostgreSQL)
## loads the PostgreSQL driver 
drv <- dbDriver("PostgreSQL")
## Open a connection
con <- dbConnect(drv, user = "analysis", password="cyclop-analysis", dbname="cyclop", port="5432", host="giv-cyclop.uni-muenster.de")


##dbExistsTable(con, TableName, ...) checks whether a particular table exists on the given connection. Returns a logical
dbExistsTable(con,"analysis_temp")

dbSendQuery(con, paste("insert into analysis_temp (standard_deviation,time,variance,mean,id) VALUES ( '",sd,"','",time,"','",v,"','",mean,"','",mid,"');",sep=""))


