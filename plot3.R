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

#Plot 3
#download files if (if needed) and get table
df <- downloadWorkingFiles()
p3 <- filter(df, as.character(Date) == '1/2/2007' | as.character(Date) == '2/2/2007')

#create datetime field
p3[,"Datetime"] <- paste(p3$Date, p3$Time);
p3$Datetime = as.POSIXlt(p3$Datetime,format="%d/%m/%Y %H:%M:%S")

#format as numbers
p3$Sub_metering_1 <- as.double(as.character(p3$Sub_metering_1))
p3$Sub_metering_2 <- as.double(as.character(p3$Sub_metering_2))
p3$Sub_metering_3 <- as.double(as.character(p3$Sub_metering_3))

#create png canvas
png("plot3.png",width=480,height=480,bg="transparent",units="px")
plot(x=(p3$Datetime),y=p3$Sub_metering_1,type="l",ylab="Energy sub metering",xlab="")
lines(x=(p3$Datetime),y=p3$Sub_metering_2,col="red")
lines(x=(p3$Datetime),y=p3$Sub_metering_3,col="blue")

#create key
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="l",col=c("black","red","blue"),lwd=2,cex=0.7)

#close
dev.off()