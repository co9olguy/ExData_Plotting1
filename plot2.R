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


#plot2

#open png graphics device
png("plot2.png",width=480,height=480)

#make plot
xrange <-range(data$DateTime)
yrange <- range(data$Global_active_power)
plot(xrange, yrange, type="n", xlab="",ylab="Global Active Power (kilowatts)" ) 
lines(x=data$DateTime,y=data$Global_active_power)

#close graphics device
dev.off()

