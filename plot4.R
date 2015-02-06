#load file
library(sqldf)
f <- file("household_power_consumption.txt")
data <- sqldf("select * from f where (Date == '1/2/2007' OR Date == '2/2/2007')", dbname = tempfile(), file.format = list(header = TRUE, sep = ";"))
close(f)
remove(f)

#alternate way: read in full dataset and then subset
#fulldata <- read.csv(header=TRUE,sep=";")
#data <- fulldata[fulldata$Date == "1/2/2007" | fulldata$Date == "2/2/2007",]
#remove(fulldata)

#convert dates to Date format
library(chron)
data$Date <- as.Date(data$Date,"%d/%m/%Y")

#convert times to a time format
data$Time <- times(data$Time)

#add convenient DateTime column
data$DateTime <- as.POSIXct(paste(data$Date,data$Time))


#plot4

#open png graphics device
png("plot4.png",width=480,height=480)

#make 4 plots
par(mfrow = c(2,2))

#first plot
xrange <-range(data$DateTime)
yrange <- range(data$Global_active_power)
plot(xrange, yrange, type="n", xlab="",ylab="Global Active Power" ) 
lines(x=data$DateTime,y=data$Global_active_power)

#second plot
xrange <-range(data$DateTime)
yrange <- range(data$Voltage)
plot(xrange, yrange, type="n", xlab="datetime",ylab="Voltage" ) 
lines(x=data$DateTime,y=data$Voltage)

#third plot
xrange <-range(data$DateTime)
yrange <- range(data$Sub_metering_1)
plot(xrange, yrange, type="n", xlab="",ylab="Energy sub metering" ) 
lines(x=data$DateTime,y=data$Sub_metering_1,col="black")
lines(x=data$DateTime,y=data$Sub_metering_2,col="red")
lines(x=data$DateTime,y=data$Sub_metering_3,col="blue")
legend("topright",bty="n",lty=1,col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")) 

#fourth plot
xrange <-range(data$DateTime)
yrange <- range(data$Global_reactive_power)
plot(xrange, yrange, type="n", xlab="datetime",ylab="Global_reactive_power" ) 
lines(x=data$DateTime,y=data$Global_reactive_power)

#close graphics device
dev.off()
