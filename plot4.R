# @function downloadWorkingFiles
# @desciption dowloads files (if non existant)
downloadWorkingFiles <- function () {
  
  tableFile <- "./household_power_consumption.txt"
  
  if (!file.exists(tableFile) ) {
    
    dir.create("data")
    filedirectory <- "./data"
    
    zip <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    datasetzip <- paste(filedirectory,'household_power_consumption.zip', sep = "/");
    
    #download zip
    if (!file.exists(zip) ) {
      download.file(zip, datasetzip, method="curl")
    }
    
    #unzip files to data directoru
    unzip(datasetzip)
    
  }
  
  df <- read.table("./household_power_consumption.txt", header=T, sep=";")
  
  if ("dplyr"  %in% rownames(installed.packages()) == FALSE) {
    install.packages("dplyr")
  }
  
  library(dplyr)
  
  df
  
}

#Plot 4
#download files if (if needed) and get table
df <- downloadWorkingFiles()
p4 <- filter(df, as.character(Date) == '1/2/2007' | as.character(Date) == '2/2/2007')
#create datetime field
p4[,"Datetime"] <- paste(p4$Date, p4$Time);
p4$Datetime = as.POSIXlt(p4$Datetime,format="%d/%m/%Y %H:%M:%S")

#create png canvas
png("plot4.png",width=480,height=480,bg="transparent",units="px")

#create 2 X 2 grid
par(mfrow=c(2,2))

#top left
plot(p4$Datetime,p4$Global_active_power,xlab ="",ylab = "Global Active Power",type ="l")

#top right
plot(p4$Datetime,p4$Voltage,xlab ="datetime",ylab = "Voltage",type ="l")

#bottom left
plot(p4$Datetime,p4$Sub_metering_1,xlab ="",ylab = "Energy sub metering",type ="l",col = 'black')
lines( p4$Datetime, p4$Sub_metering_2, col = "red")
lines( p4$Datetime, p4$Sub_metering_3, col = "blue")

#create key
legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c('black','red','blue'),lty = 1,lwd = 3)

#bottom right
plot(p4$Datetime,p4$Global_reactive_power,xlab ="datetime", ylab = "Global_reactive_power", type ="l")

#close
dev.off()