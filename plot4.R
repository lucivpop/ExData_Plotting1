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

## get max value for y axis
y1max<-data$Sub_metering_1[which.max(data$Sub_metering_1)]
y2max<-data$Sub_metering_2[which.max(data$Sub_metering_2)]
y3max<-data$Sub_metering_3[which.max(data$Sub_metering_3)]
ymax<-max(c(y1max,y2max,y3max))

## open png file device
## plot the 4 graphics 
## close device
png(filename="plot4.png",width = 480, height = 480, units = "px")
par(mfrow=c(2,2),byrow=T,mar=c(5,4,4,2))

## plot first graphic
plot(data$x,data$Global_active_power,
     type="l",
     col="black",
     xaxt="n",
     xlab="",
     ylab="Global active power (kilowatts)")
axis(1,at=i.wd,labels=wd)

## plot second graphic
plot(data$Voltage,type="l",
     ylab="Voltage",
     xlab="datetime",
     xaxt="n")
axis(1,at=i.wd,labels=wd)

## plot third graphic
plot(data$Sub_metering_3,type="n",
     ylim=c(1,ymax),
     ylab="Energy sub metering",
     xlab="",
     xaxt="n")
lines(data$x,data$Sub_metering_1,col="black")
lines(data$x,data$Sub_metering_2,col="red")
lines(data$x,data$Sub_metering_3,col="blue")
axis(1,at=i.wd,labels=wd)
legend("topright",lty=1,lwd=2,col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")

## plot fourth graphic
plot(data$Global_reactive_power,type="l",
         ylab="Global_reactive_power",
         xlab="datetime",
         xaxt="n")
axis(1,at=i.wd,labels=wd)

dev.off()
