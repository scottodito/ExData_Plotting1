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

#Plot 1
#download files if (if needed) and get table
df <- downloadWorkingFiles()

#filter the frame to specific dates
p1 <- filter(df, as.character(Date) == '1/2/2007' | as.character(Date) == '2/2/2007')

#turn global active power to numeric
p1$Global_active_power <- as.numeric(as.character(p1$Global_active_power))

#crete png canvas
png("plot1.png",width=480,height=480,bg="transparent",units="px")

#get the global active power vs frequency
hist(p1$Global_active_power, main="Global Active Power", ylab = "Frequency", xlab = "Global Active Power (Killowats)", col="red", ylim=c(0, 1300))

#close device
dev.off()