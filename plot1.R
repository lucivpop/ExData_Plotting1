## read raw data table from file
data.raw<-read.table("household_power_consumption.txt",
                 header=T,sep=";",nrows=2075259,na.strings=c("?"),
                 stringsAsFactors=F)

## select days "1/2/2007", "2/2/2007" in data
## create a datetime column from date and time columns
## order by datetime ascending
data<-subset(data.raw, Date=="1/2/2007" | Date=="2/2/2007")
data$dateTime<-paste(data$Date,data$Time)
data$dateTime<-strptime(data$dateTime,"%d/%m/%Y %H:%M:%S",tz="")
data[order(data$dateTime),]

## open png file device
## plot histogram of Global Active Power
## close device
png(filename="plot1.png",width = 480, height = 480, units = "px")
hist(data$Global_active_power,
     col="red",
     main="Global Active Power",
     xlab="Global active power (kilowatts)",
     ylab="Frequency")
dev.off()

