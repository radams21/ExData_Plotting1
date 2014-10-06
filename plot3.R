library(data.table)

data_file = "household_power_consumption.txt"
colClasses = c('character', 'character', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
DT = fread(data_file, colClasses=colClasses, na.strings=c("NA","N/A","","?"))

#names(DT)

DT$Date = as.Date(DT$Date,"%d/%m/%Y")
#head(DT$Date)

# We will only be using data from the dates 2007-02-01 and 2007-02-02.
DT_small = DT[Date >= "2007-02-01",]
DT_small = DT_small[Date <= "2007-02-02",]

DT_small$DateTime = "?"
my_time_list = strptime(paste(DT_small$Date, DT_small$Time), format="%Y-%m-%d %H:%M:%S")

# 
DT_small[,c("DateTime") := format(paste(DT_small$Date, DT_small$Time), format="%Y-%m-%d %H:%M:%S")]
DT_small[,c("Seconds") := as.Date(DT_small$DateTime, "%Y-%m-%d %H:%M:%S")]
DT_small[,c("Days") := weekdays(as.Date(DT_small$DateTime), abbreviate=TRUE)]

# Plot 3: Energy sub metering vs Day of Week as Line Graph
png(filename = "plot3.png", width = 480, height = 480, units="px")
plot(DT_small$Seconds, DT_small$Sub_metering_1, type="l", xaxt="n", xlab="", ylab = "Energy sub metering")
lines(DT_small$Seconds, DT_small$Sub_metering_2, type="l", col="red", xaxt="n", xlab="", ylab = "Energy sub metering")
lines(DT_small$Seconds, DT_small$Sub_metering_3, type="l", col="blue", xaxt="n", xlab="", ylab = "Energy sub metering")
axis(1, at=c(min(DT_small$Seconds),mean(DT_small$Seconds),max(DT_small$Seconds)),labels=c("Thu", "Fri", "Sat"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1)
dev.off()
