##read data into R

if(!file.exists("exdata-data-household_power_consumption.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

data <- read.table(file, header=T, sep=";", nrows=5)
classes <-sapply(data, class)
data2 <- read.table(file, header=T, sep=";", na.strings = "?", colClasses = classes)
data2$Date <- as.Date(data2$Date, format="%d/%m/%Y")

##subset data for specific dates
finaldata <- data2[(data2$Date=="2007-02-01") | (data2$Date=="2007-02-02"),]
df <- transform(finaldata, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

##create plot 3
with(df, {
  plot(Sub_metering_1~timestamp, type="l", 
              ylab="Energy sub metering", xlab="") 
   lines(Sub_metering_2~timestamp,col='Red') 
   lines(Sub_metering_3~timestamp,col='Blue') 
   }) 
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,  
legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 


##create png file
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()