## Analize fire occurence
## Dhemerson Conciani (dh.conciani@gmail.com)
## Florestal Foundation // São Paulo State University

## Read packages
library (rgdal)
library (raster)
library (ggplot2)
library (gridExtra)
library (xlsx)

## Read burned area (ba) shapefile
ba <- readOGR (dsn= "C:/Users/BSD/Desktop/APA Corumbatai/burned_area/2017_inpe_validated/2017",layer='ba_apac_UTM_SIRGAS_2017')

## Read APA shapeifile
APA_corumb   <- readOGR (dsn="C:/Users/BSD/Desktop/APA Corumbatai/shps", layer = "apac_Pol_utm23-sirgas2000")
APA_pirac    <- readOGR (dsn="C:/Users/BSD/Desktop/APA Corumbatai/shps", layer="apap_limite-errado-pol_utm23-sirgas2000")
APAS_overlap <- readOGR (dsn="C:/Users/BSD/Desktop/APA Corumbatai/shps", layer="APAs_overlap")

## Crop burned area by different APAS
ba_corumb   <- crop (ba, APA_corumb)
ba_pirac    <- crop (ba, APA_pirac)
ba_overlap  <- crop (ba, APAS_overlap)

## Sum mensal burned area and frequency
## APA Corumbatai
df_corumb <- aggregate (area ~ month, ba_corumb, sum)
freq_corumb <- table (ba_corumb$month)
temp_freq <- as.data.frame (freq_corumb)
temp_freq <- temp_freq[-1,]
df_corumb$month <- as.numeric(paste(df_corumb$month))
df_corumb["freq"] <- temp_freq$Freq
df_corumb["APA"] <- rep ("Corumbatai",9)                                           
df_corumb["local_area"] <- rep (275317, 9)

## APA Piracicaba
df_pirac <- aggregate (area ~ month, ba_pirac, sum)
freq_pirac <- table (ba_pirac$month)
temp_freq <- as.data.frame (freq_pirac)
temp_freq <- temp_freq[-1,]
df_pirac$month <- as.numeric(paste(df_pirac$month))
df_pirac["freq"] <- temp_freq$Freq
df_pirac["APA"] <- rep ("Piracicaba",9)                                           
df_pirac["local_area"] <- rep (114860, 9)

## Overlapin' area
df_overlap <- aggregate (area ~ month, ba_overlap, sum)
freq_overlap <- table (ba_overlap$month)
temp_freq <- as.data.frame (freq_overlap)
temp_freq <- temp_freq[-1,]
temp_freq <- temp_freq[-4,]
df_overlap$month <- as.numeric(paste(df_overlap$month))
df_overlap["freq"] <- temp_freq$Freq
df_overlap["APA"] <- rep ("Sobreposicao",8)                                           
df_overlap["local_area"] <- rep (64156, 8)

## make single data.frame
df <- rbind (df_corumb, df_pirac, df_overlap)

## Calc dire metrics
df["percent_ba"] <- df[, "area"] / df[, "local_area"]
df["ign_density"] <- df[, "freq"] / df[, "local_area"] 
df["mean_size"] <- df[, "area"] / df[, "freq"]

## clean cache
rm (df_corumb, df_overlap, df_pirac, temp_freq, APA_corumb, APA_pirac, APAS_overlap, 
    ba, ba_corumb, ba_overlap, ba_pirac, freq_corumb, freq_pirac, freq_overlap)

## Compare Burned Area 
sp1 <- ggplot(df, aes(month, percent_ba)) +   
  geom_bar(aes(fill = APA), position = "dodge", stat="identity") +
  scale_x_continuous (breaks=1:12, labels= c('J','F','M','A','M','J','J','A','S','O','N','D')) +
  xlab('Meses') + ylab('Área queimada acumulada (%)') 

## Compare Density
sp2 <- ggplot(df, aes(month, ign_density, group = APA, colour=APA)) +
  geom_line() +
  geom_point( size=1.3) +
  scale_x_continuous (breaks=1:12, labels= c('J','F','M','A','M','J','J','A','S','O','N','D')) +
  xlab('Meses') + ylab('Densidade de Ignições (n/hectare)')

# Plot
x11()
grid.arrange(sp1, sp2, nrow=1, ncol=2)

write.xlsx(df, file="mensal_count.xlsx", sheetName="sheet1")

