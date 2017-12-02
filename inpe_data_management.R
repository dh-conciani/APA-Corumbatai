## Read, separate time/date and crop APA's from INPE active fires product
## Dhemerson Conciani (dh.conciani@gmail.com)
## Florestal Foundation // São Paulo State University

## Read libraries 
library (tools)
library (rgdal)
library (stringr)
library (rgeos)
library (raster)
library (lubridate)
library (ggplot2)

## Read APA's shapefiles
APA_Pira    <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/shps",layer='apap_limite-errado-pol_utm23-sirgas2000')
APA_Corumb  <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/shps",layer='apac_Pol_utm23-sirgas2000')

## Extract reference projection
ref_proj = crs (APA_Pira)
ref_proj

## Read overlaping and total area of APA's
APA_overlap <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/shps",layer='APAs_overlap')
APAS        <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/shps",layer='dissolve')

## Read INPE active fires and reproject to SIRGAS UTM 23S
INPE_AF  <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/focos_inpe",layer='Focos.2017-01-01.2017-11-06')
INPE_AF2 <- spTransform (INPE_AF, CRS("+proj=utm +zone=23 +south +ellps=GRS80 +units=m +no_defs"))

## Crop Active fires only in APA's area
INPE_AF_APAS <- crop (INPE_AF2, APAS)
rm(INPE_AF2)

## Exploratory plot
plot (APAS, axes=TRUE, main='Active fires in APAs between Jan/Nov 2017')
points (INPE_AF_APAS, col='red', pch='+', cex=.6)

## Convert attributes table to data.frame
INPE_DF <- INPE_AF_APAS@data

## Read variables for each active fire
dates    <- INPE_DF$DataHora
state    <- INPE_DF$Estado
city     <- INPE_DF$Municipi
bioma    <- INPE_DF$Bioma
satelite <- INPE_DF$Satelite

## Parse strings 
year  = substr (dates, 1,4)
month = substr (dates, 6,7 )
day   = substr (dates, 9,10)

## Build new attributes table for INPE active fire product
INPE_DF <- data.frame (year, month, day, city, state, bioma, satelite)
INPE_AF_APAS@data <- INPE_DF

## Export adjusted shapefile
writeOGR(obj=INPE_AF_APAS, dsn="C:/Users/BSD/Desktop/APA Corumbatai/focos_inpe", layer="2017_at11", driver="ESRI Shapefile") # this is in equal area projection

## Read exported shapefile
INPE_AF_APAS <- readOGR(dsn="C:/Users/BSD/Desktop/APA Corumbatai/focos_inpe", layer="2017_at11")
INPE_DF <- INPE_AF_APAS@data

## Calc statistics
summary(INPE_DF)
par(mfrow=c(1,2))

## Analize mensal distribution
names_month = c('J', 'F', 'M', 'A' ,'M', 'J', 'J', 'A', 'S', 'O', 'N')
plot (INPE_DF$month, col='tan1', names.arg=names_month, axes=T, 
      ylab= 'Frequency',xlab='Month', main='Fire frequency in APAs per Month (2017)', 
      ylim=c(0,300))

## Analize cities distribution
names_cities <- levels(INPE_DF$city)
par(las=1)
plot (INPE_DF$city, col='ivory3', axes=T, cex.names=0.8,
      ylab=NULL,xlab='Frequency', main='Fire frequency in APAs per city (2017)', 
      xlim= c(0,120), horiz=TRUE)

