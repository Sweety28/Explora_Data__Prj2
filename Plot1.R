library(plyr)
library(ggplot2)
library(data.table)
library(grid)
library(scales)
library(httr)

setwd("~/GitHub/Sweety28/Explora_Data__Prj2")

if(!file.exists("./dataStore")){dir.create("./dataStore")}
# activity monitoring data
get.data.project <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(get.data.project,destfile="./dataStore/exdata-data-NEI_data.zip",method="auto")  

  # make sure the site is live, if it is not live stop function terminate the program
  check.url <- file(get.data.project,"r")
  if (!isOpen(check.url)) {
    stop(paste("There's a problem with the data:",geterrmessage()))
  }
  # zipfile.data is the variable to keep the *.zip file
  zipfile.data = "exdata-data-NEI_data.zip"
  
  # make sure the data in the working directory if not download the zip file into the to zipfile.data and unzip the zipfile.data
  if(!file.exists(zipfile.data)) {        
        # download.file(get.data.project,zipfile.data)
        unzip(zipfile="./dataStore/exdata-data-NEI_data.zip",exdir="./dataStore")
   } 
path_rf <- file.path("./dataStore" , "exdata-data-NEI_data")
files<-list.files(path_rf, recursive=TRUE)
files

NEI <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")
number.add.width<-800                             # width length to make the changes faster
number.add.height<-800                             # height length to make the changes faster
require(dplyr)

total.emissions <- summarise(group_by(NEI, year), Emissions=sum(Emissions))
clrs <- c("red", "green", "blue", "yellow")
x1<-barplot(height=total.emissions$Emissions/1000, names.arg=total.emissions$year,
        xlab="years", ylab=expression('total PM'[2.5]*' emission in kilotons'),ylim=c(0,8000),
        main=expression('Total PM'[2.5]*' emissions at various years in kilotons'),col=clrs)

## Add text at top of bars
text(x = x1, y = round(total.emissions$Emissions/1000,2), label = round(total.emissions$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")

