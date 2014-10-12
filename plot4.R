library(data.table)

###########################################################
# Load data (redundant for all plotN.R files)
###########################################################

# Read data in or download the file into working directory if it doesn't exist
data_file = "household_power_consumption.txt"
if(! file.exists(data_file)) {
    url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
    zip_file = "household_power_consumption.zip"
    download.file(url, destfile = zip_file, method="curl")
    unzip(zip_file)
}
colClasses = c('character', 'character', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric')
DT = fread(data_file, colClasses=colClasses, na.strings=c("NA","N/A","","?"))

# Make sure the Date column is read as a Date; this will be used for subsetting
DT$Date = as.Date(DT$Date,"%d/%m/%Y")

# Subset table; only use data from the dates 2007-02-01 and 2007-02-02
DT_small = DT[Date >= "2007-02-01",]
DT_small = DT_small[Date <= "2007-02-02",]

# Remove the large dataset from memory; we will only work with the subset table
rm(DT)

# Create new column (DateTime) with merged values of Date and Time 
DT_small[,c("DateTime") := as.POSIXct(format(paste(DT_small$Date, DT_small$Time), format="%Y-%m-%d %H:%M:%S"))]

###########################################################
# Plot-specific code
###########################################################

# Plot 4: Include 4 graphs in a 2x2 matrix
png(filename = "plot4.png", width = 480, height = 480, units="px")
par(mfrow=c(2,2))

# code from plot2.png
plot(DT_small$DateTime, DT_small$Global_active_power, type="l", xlab="", ylab = "Global Active Power")

# modified code from plot2.png
plot(DT_small$DateTime, DT_small$Voltage, type="l", xlab="datetime", ylab = "Voltage")

# code from plot3.png
plot(DT_small$DateTime, DT_small$Sub_metering_1, type="l", xlab="", ylab = "Energy sub metering")
lines(DT_small$DateTime, DT_small$Sub_metering_2, type="l", col="red", xaxt="n", xlab="", ylab = "Energy sub metering")
lines(DT_small$DateTime, DT_small$Sub_metering_3, type="l", col="blue", xaxt="n", xlab="", ylab = "Energy sub metering")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, bty="n")

# modified code from plot2.png
plot(DT_small$DateTime, DT_small$Global_reactive_power, type="l", xlab="datetime", ylab = "Global_reactive_power")

dev.off()