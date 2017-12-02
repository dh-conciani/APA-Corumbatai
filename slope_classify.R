## reclassify APA slope based on MDE (Emplasa images)
## Dhemerson Conciani (dh.conciani@gmail.com)

## Read packages
library (rgdal)
library (raster)

## Read data
apa_slope <- list.files(path = 'C:/Users/BSD/Desktop/APA Corumbatai/slope/', pattern = '.tif$', full.names = T)
raster <- raster (apa_slope[[1]])

## Make reclassify matrix 
m  <- c( 0, 20, 1, 
        20, 25, 2,
        25, 45, 3,
        45, 90, 4)   

rclmat <- matrix(m, ncol=3, byrow=TRUE)
rm(m, apa_slope)

## Define functions
reclass = function (x) reclassify (x, rclmat)                 

## Reclassify
rcl_slope <- reclass(raster)  

## Export raster
## Define folder
setwd("C:/Users/BSD/Desktop/APA Corumbatai/slope/rcl")

## Save raster
writeRaster (rcl_slope, filename='rcl_apa_slope',format='GTiff', overwrite=TRUE)

