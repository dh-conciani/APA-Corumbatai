## Read, separate time/date from INPE active fires product
## Dhemerson Conciani (dh.conciani@gmail.com)
## Florestal Foundation // São Paulo State University

## Read libraries 
library (tools)
library (rgdal)
library (stringr)
library (rgeos)
library (raster)
library (lubridate)

## Read INPE active fires and reproject to SIRGAS UTM 23S
INPE_AF  <- readOGR(dsn= "C:/Users/BSD/Desktop/APA Corumbatai/focos_inpe/paola",layer='focos_munic_apacp_ate_2017-09-19_WGS84_edited')

## Parse strings 
year  = substr (INPE_AF@data$Data, 1,4)
month = substr (INPE_AF@data$Data, 6,7 )
day   = substr (INPE_AF@data$Data, 9,10)

## Save separated variables
INPE_AF@data$day   <- day
INPE_AF@data$month <- month
INPE_AF@data$year  <- year

## Export 
writeOGR(obj= INPE_AF, dsn="C:/Users/BSD/Desktop/APA Corumbatai/focos_inpe/paola", layer="focos_2017", driver="ESRI Shapefile")
