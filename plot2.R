## read raw data table from file
data.raw<-read.table("household_power_consumption.txt",
                     header=T,sep=";",nrows=2075259,na.strings=c("?"),
                     stringsAsFactors=F)

## select days "1/2/2007", "2/2/2007" from data
## create a datetime column from date and time columns
## order by datetime ascending
data<-subset(data.raw, Date=="1/2/2007" | Date=="2/2/2007")
data$dateTime<-paste(data$Date,data$Time)
data$dateTime<-strptime(data$dateTime,"%d/%m/%Y %H:%M:%S",tz="")
data[order(data$dateTime),]

## create column x for indexing rows, to plot time series
data$x<-seq(1:nrow(data))

## get index of first row from 2/2/2007
firstDay<-strptime("1/2/2007 23:59:59","%d/%m/%Y %H:%M:%S",tz="")
i.sd<-which(data$dateTime>firstDay)[1]

## get short name of weekdays to be used in x axis in graphic
## get index for rows where each day starts
wd <- weekdays(as.Date(c("1/2/2007", "2/2/2007", "3/2/2007"),
              "%d/%m/%Y"),
              abbreviate=T)
i.wd<-c(1,i.sd,nrow(data))

## open png file device
## plot graphic of Global Active Power(as time series)
## close device
png(filename="plot2.png",width = 480, height = 480, units = "px")
plot(data$x,data$Global_active_power,
     type="l",
     col="black",
     xaxt="n",
     xlab="",
     ylab="Global active power (kilowatts)")
axis(1,at=i.wd,labels=wd)
dev.off()
