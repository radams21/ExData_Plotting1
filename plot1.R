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

# Plot 1: Global Active Power vs Frequency as a Red Histogram
png(filename = "plot1.png", width = 480, height = 480, units="px")
hist(as.numeric(DT_small$Global_active_power), col="red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()