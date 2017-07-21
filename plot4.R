#Exploratory Data Analysis course.  Week 1 - Assignment 1.
#Code reads in a dataset, generates four plots based on
#two days worth of household power data.  The code
#then saves the plot to a .png file.  This is the 
#code for the 4th plot (Plot4).  The working directory has
#already been set ahead of time in RStudio.


#Read in the data file, delimited by semicolon and replace question marks with NAs.
power_data <- read.table("household_power_consumption.txt",sep = ";", header = TRUE, na.strings = "?")


#Set the date and time columns as characters.
power_data$Date <- as.character(power_data$Date)
power_data$Time <- as.character(power_data$Time)


#Create a single character column that contains the date and time together.
Date_Time<- as.character(with(power_data, paste(power_data$Date, power_data$Time, sep = " ")))


#Add the datetime column to the front of the data frame.
power_data <-cbind(DateTime = Date_Time, power_data)


#Convert the datetime column to a DateTime class (POSIXlt, POSIXt)
power_data$DateTime <- strptime(power_data$DateTime, "%d/%m/%Y %H:%M:%S")


#Get rid of the original date and time columns, since a new DateTime class column has been created.
power_data <- power_data[,!names(power_data) %in% c("Date","Time")]

#Subset the data for the two days of interest for the plots, Feb 1st and 2nd, 2007.
subset_data <-subset(power_data, power_data$DateTime >= "2007-02-01 00:00:00" & power_data$DateTime <= "2007-02-02 23:59:00")


# #Open up the png graphics device.  Sit the width and height of the image to be 480 pixels.
png(file="plot4.png",width = 480, height = 480)
 
 
# #Create multiple plots.  
par(mfrow = c(2,2))
with(subset_data, {
  plot(subset_data$DateTime, subset_data$Global_active_power,type = "l", xlab = " ", ylab = "Global Active Power")

  plot(subset_data$DateTime, subset_data$Voltage,type = "l", xlab = "datetime", ylab = "Voltage")
  
  with(subset_data,(plot(subset_data$DateTime, subset_data$Sub_metering_1,type = "l", xlab = " ", ylab = "Energy sub metering")))
  with(subset_data, lines(subset_data$DateTime, subset_data$Sub_metering_2, col = "red"))
  with(subset_data, lines(subset_data$DateTime, subset_data$Sub_metering_3, col = "blue"))
  legend("topright", lty = 1, col = c("black", "red", "blue"),  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty= "n")

  plot(subset_data$DateTime, subset_data$Global_reactive_power,type = "l", xlab = "datetime", ylab = "Global_reactive_power", yaxt ="n")
  axis(2, at = c(0.0, 0.1,0.2,0.3,0.4, 0.5))

})

 #Turn off the graphics device.
 dev.off()
