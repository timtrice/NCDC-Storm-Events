# Cleaning NCDC Storm Events
Tim Trice  



```r
knitr::opts_chunk$set(
 fig.align = "center",
 fig.path = "figures/", 
 cache.path = "cache/", 
 cache = FALSE
)
```


```r
library(data.table)
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
## 
## The following objects are masked from 'package:data.table':
## 
##     hour, mday, month, quarter, wday, week, yday, year
```

```r
library(knitr)
library(tidyr)
```


```r
sessionInfo()
```

```
## R version 3.2.3 (2015-12-10)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 8.1 x64 (build 9600)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] tidyr_0.3.1      knitr_1.11       lubridate_1.5.0  data.table_1.9.6
## 
## loaded via a namespace (and not attached):
##  [1] magrittr_1.5    formatR_1.2.1   tools_3.2.3     htmltools_0.2.6
##  [5] yaml_2.1.13     Rcpp_0.12.2     stringi_1.0-1   rmarkdown_0.9  
##  [9] stringr_1.0.0   digest_0.6.8    chron_2.3-47    evaluate_0.8
```

## Details


```r
details <- fread("data/details.csv")
```

```
## 
Read 0.0% of 981997 rows
Read 12.2% of 981997 rows
Read 24.4% of 981997 rows
Read 25.5% of 981997 rows
Read 33.6% of 981997 rows
Read 36.7% of 981997 rows
Read 43.8% of 981997 rows
Read 50.9% of 981997 rows
Read 57.0% of 981997 rows
Read 66.2% of 981997 rows
Read 68.2% of 981997 rows
Read 76.4% of 981997 rows
Read 83.5% of 981997 rows
Read 90.6% of 981997 rows
Read 96.7% of 981997 rows
Read 99.8% of 981997 rows
Read 981997 rows and 52 (of 52) columns from 0.671 GB file in 00:00:25
```


```r
dim(details)
```

```
## [1] 981997     52
```

```r
colnames(details)
```

```
##  [1] "V1"                 "BEGIN_YEARMONTH"    "BEGIN_DAY"         
##  [4] "BEGIN_TIME"         "END_YEARMONTH"      "END_DAY"           
##  [7] "END_TIME"           "EPISODE_ID"         "EVENT_ID"          
## [10] "STATE"              "STATE_FIPS"         "YEAR"              
## [13] "MONTH_NAME"         "EVENT_TYPE"         "CZ_TYPE"           
## [16] "CZ_FIPS"            "CZ_NAME"            "WFO"               
## [19] "BEGIN_DATE_TIME"    "CZ_TIMEZONE"        "END_DATE_TIME"     
## [22] "INJURIES_DIRECT"    "INJURIES_INDIRECT"  "DEATHS_DIRECT"     
## [25] "DEATHS_INDIRECT"    "DAMAGE_PROPERTY"    "DAMAGE_CROPS"      
## [28] "SOURCE"             "MAGNITUDE"          "MAGNITUDE_TYPE"    
## [31] "FLOOD_CAUSE"        "CATEGORY"           "TOR_F_SCALE"       
## [34] "TOR_LENGTH"         "TOR_WIDTH"          "TOR_OTHER_WFO"     
## [37] "TOR_OTHER_CZ_STATE" "TOR_OTHER_CZ_FIPS"  "TOR_OTHER_CZ_NAME" 
## [40] "BEGIN_RANGE"        "BEGIN_AZIMUTH"      "BEGIN_LOCATION"    
## [43] "END_RANGE"          "END_AZIMUTH"        "END_LOCATION"      
## [46] "BEGIN_LAT"          "BEGIN_LON"          "END_LAT"           
## [49] "END_LON"            "EPISODE_NARRATIVE"  "EVENT_NARRATIVE"   
## [52] "DATA_SOURCE"
```

```r
str(details)
```

```
## Classes 'data.table' and 'data.frame':	981997 obs. of  52 variables:
##  $ V1                : chr  "1" "2" "3" "4" ...
##  $ BEGIN_YEARMONTH   : int  195004 195004 195006 195009 195009 195010 195007 195007 195007 195008 ...
##  $ BEGIN_DAY         : int  28 29 22 15 16 1 5 5 24 29 ...
##  $ BEGIN_TIME        : int  1445 1530 2100 1745 130 2100 1800 1830 1440 1600 ...
##  $ END_YEARMONTH     : int  195004 195004 195006 195009 195009 195010 195007 195007 195007 195008 ...
##  $ END_DAY           : int  28 29 22 15 16 1 5 5 24 29 ...
##  $ END_TIME          : int  1445 1530 2100 1745 130 2100 1800 1830 1440 1600 ...
##  $ EPISODE_ID        : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ EVENT_ID          : int  10096222 10120412 10073785 10099490 10099491 10099492 10104927 10104928 10104929 10104930 ...
##  $ STATE             : chr  "OKLAHOMA" "TEXAS" "NEBRASKA" "OKLAHOMA" ...
##  $ STATE_FIPS        : chr  "40" "48" "31" "40" ...
##  $ YEAR              : int  1950 1950 1950 1950 1950 1950 1950 1950 1950 1950 ...
##  $ MONTH_NAME        : chr  "April" "April" "June" "September" ...
##  $ EVENT_TYPE        : chr  "Tornado" "Tornado" "Tornado" "Tornado" ...
##  $ CZ_TYPE           : chr  "C" "C" "C" "C" ...
##  $ CZ_FIPS           : int  149 93 129 63 121 25 77 43 39 17 ...
##  $ CZ_NAME           : chr  "WASHITA" "COMANCHE" "NUCKOLLS" "HUGHES" ...
##  $ WFO               : chr  "" "" "" "" ...
##  $ BEGIN_DATE_TIME   : chr  "28-APR-50 14:45:00" "29-APR-50 15:30:00" "22-JUN-50 21:00:00" "15-SEP-50 17:45:00" ...
##  $ CZ_TIMEZONE       : chr  "CST" "CST" "CST" "CST" ...
##  $ END_DATE_TIME     : chr  "28-APR-50 14:45:00" "29-APR-50 15:30:00" "22-JUN-50 21:00:00" "15-SEP-50 17:45:00" ...
##  $ INJURIES_DIRECT   : chr  "0" "0" "0" "6" ...
##  $ INJURIES_INDIRECT : chr  "0" "0" "0" "0" ...
##  $ DEATHS_DIRECT     : chr  "0" "0" "0" "0" ...
##  $ DEATHS_INDIRECT   : chr  "0" "0" "0" "0" ...
##  $ DAMAGE_PROPERTY   : chr  "250K" "25K" "0K" "250K" ...
##  $ DAMAGE_CROPS      : chr  "0" "0" "0" "0" ...
##  $ SOURCE            : chr  "" "" "" "" ...
##  $ MAGNITUDE         : chr  "0" "0" "0" "0" ...
##  $ MAGNITUDE_TYPE    : chr  "" "" "" "" ...
##  $ FLOOD_CAUSE       : chr  "" "" "" "" ...
##  $ CATEGORY          : chr  "" "" "" "" ...
##  $ TOR_F_SCALE       : chr  "F3" "F1" "F0" "F2" ...
##  $ TOR_LENGTH        : chr  "3.4" "11.5" "1.9" "6.8" ...
##  $ TOR_WIDTH         : chr  "400" "200" "33" "100" ...
##  $ TOR_OTHER_WFO     : chr  "" "" "" "" ...
##  $ TOR_OTHER_CZ_STATE: chr  "" "" "" "" ...
##  $ TOR_OTHER_CZ_FIPS : chr  "" "" "" "" ...
##  $ TOR_OTHER_CZ_NAME : chr  "" "" "" "" ...
##  $ BEGIN_RANGE       : chr  "0" "0" "0" "0" ...
##  $ BEGIN_AZIMUTH     : chr  "" "" "" "" ...
##  $ BEGIN_LOCATION    : chr  "" "" "" "" ...
##  $ END_RANGE         : chr  "0" "0" "0" "0" ...
##  $ END_AZIMUTH       : chr  "" "" "" "" ...
##  $ END_LOCATION      : chr  "" "" "" "" ...
##  $ BEGIN_LAT         : chr  "35.12" "31.90" "40.18" "35.00" ...
##  $ BEGIN_LON         : chr  "-99.20" "-98.60" "-98.03" "-96.25" ...
##  $ END_LAT           : chr  "35.17" "31.73" "40.20" "35.07" ...
##  $ END_LON           : chr  "-99.20" "-98.60" "-97.98" "-96.17" ...
##  $ EPISODE_NARRATIVE : chr  "" "" "" "" ...
##  $ EVENT_NARRATIVE   : chr  "" "" "" "" ...
##  $ DATA_SOURCE       : chr  "PUB" "PUB" "PUB" "PUB" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

### Dates and Times

I look first on concatenating `BEGIN_YEARMONTH`, `BEGIN_DAY`, `BEGIN_TIME` and `END_YEARMONTH`, `END_DAY`, `END_TIME`. These should be only two variables. Scrolling further down the names there is already a `BEGIN_DATE_TIME` and `END_DATE_TIME` variable.

I'll look first at making sure the beginning time periods match.


```r
x <- details[1:10, .(BEGIN_YEARMONTH, BEGIN_DAY, BEGIN_TIME, BEGIN_DATE_TIME)]
kable(x)
```



 BEGIN_YEARMONTH   BEGIN_DAY   BEGIN_TIME  BEGIN_DATE_TIME    
----------------  ----------  -----------  -------------------
          195004          28         1445  28-APR-50 14:45:00 
          195004          29         1530  29-APR-50 15:30:00 
          195006          22         2100  22-JUN-50 21:00:00 
          195009          15         1745  15-SEP-50 17:45:00 
          195009          16          130  16-SEP-50 01:30:00 
          195010           1         2100  01-OCT-50 21:00:00 
          195007           5         1800  05-JUL-50 18:00:00 
          195007           5         1830  05-JUL-50 18:30:00 
          195007          24         1440  24-JUL-50 14:40:00 
          195008          29         1600  29-AUG-50 16:00:00 

They do line up so I know I can drop `BEGIN_YEARMONTH`, `BEGIN_DAY` and `BEGIN_TIME`.

What about the end times?


```r
x <- details[1:10, .(END_YEARMONTH, END_DAY, END_TIME, END_DATE_TIME)]
kable(x)
```



 END_YEARMONTH   END_DAY   END_TIME  END_DATE_TIME      
--------------  --------  ---------  -------------------
        195004        28       1445  28-APR-50 14:45:00 
        195004        29       1530  29-APR-50 15:30:00 
        195006        22       2100  22-JUN-50 21:00:00 
        195009        15       1745  15-SEP-50 17:45:00 
        195009        16        130  16-SEP-50 01:30:00 
        195010         1       2100  01-OCT-50 21:00:00 
        195007         5       1800  05-JUL-50 18:00:00 
        195007         5       1830  05-JUL-50 18:30:00 
        195007        24       1440  24-JUL-50 14:40:00 
        195008        29       1600  29-AUG-50 16:00:00 

These are lined up as well. 

I'll rebuild `details` minus `BEGIN_YEARMONTH`, `BEGIN_DAY`, `BEGIN_TIME`, `END_YEARMONTH`, `END_DAY`, `END_TIME`.


```r
details <- details[, c("BEGIN_YEARMONTH", 
                       "BEGIN_DAY", 
                       "BEGIN_TIME", 
                       "END_YEARMONTH", 
                       "END_DAY", 
                       "END_TIME") := NULL]

dim(details)
```

```
## [1] 981997     46
```

### EPISODE_ID

`EPISODE_ID` is the key linking `details` to `locations`. Not all events have `EPISODE_ID`


```r
summary(details$EPISODE_ID)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       3   34830  133800  336000  201000 1419000  232240
```

### EVENT_ID

`EVENT_ID` links the events across the three datasets and can be used as a *PRIMARY KEY*.


```r
summary(details$EVENT_ID)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
##     3419   267800  5416000  5194000  5712000 10360000
```

### STATE

`STATE` is listed in it's full name, all caps. I'll first get a list of unique `STATE`'s. 


```r
unique_states <- unique(details$STATE)
print(sort(unique_states))
```

```
##  [1] ""                     "ALABAMA"              "ALASKA"              
##  [4] "AMERICAN SAMOA"       "ARIZONA"              "ARKANSAS"            
##  [7] "ATLANTIC NORTH"       "ATLANTIC SOUTH"       "CALIFORNIA"          
## [10] "COLORADO"             "CONNECTICUT"          "DELAWARE"            
## [13] "DISTRICT OF COLUMBIA" "E PACIFIC"            "FLORIDA"             
## [16] "GEORGIA"              "GUAM"                 "GULF OF ALASKA"      
## [19] "GULF OF MEXICO"       "HAWAII"               "HAWAII WATERS"       
## [22] "IDAHO"                "ILLINOIS"             "INDIANA"             
## [25] "IOWA"                 "KANSAS"               "KENTUCKY"            
## [28] "LAKE ERIE"            "LAKE HURON"           "LAKE MICHIGAN"       
## [31] "LAKE ONTARIO"         "LAKE ST CLAIR"        "LAKE SUPERIOR"       
## [34] "LOUISIANA"            "MAINE"                "MARYLAND"            
## [37] "MASSACHUSETTS"        "MICHIGAN"             "MINNESOTA"           
## [40] "MISSISSIPPI"          "MISSOURI"             "MONTANA"             
## [43] "NEBRASKA"             "NEVADA"               "NEW HAMPSHIRE"       
## [46] "NEW JERSEY"           "NEW MEXICO"           "NEW YORK"            
## [49] "NORTH CAROLINA"       "NORTH DAKOTA"         "OHIO"                
## [52] "OKLAHOMA"             "OREGON"               "PENNSYLVANIA"        
## [55] "PUERTO RICO"          "RHODE ISLAND"         "SOUTH CAROLINA"      
## [58] "SOUTH DAKOTA"         "ST LAWRENCE R"        "TENNESSEE"           
## [61] "TEXAS"                "UTAH"                 "VERMONT"             
## [64] "VIRGIN ISLANDS"       "VIRGINIA"             "WASHINGTON"          
## [67] "WEST VIRGINIA"        "WISCONSIN"            "WYOMING"
```

```r
sum(is.na(details$STATE))
```

```
## [1] 0
```

We have one empty entry which I will convert to `NA` for the time being. There are also generic entries such as *ATLANTIC NORTH* and *ATLANTIC SOUTH* which I suspect are for hurricane activity. 

For the moment, I will not make any additional changes other than the empty strings to `NA`.


```r
setkey(details, STATE)
details["", STATE := NA]

# Check again
unique_states <- unique(details$STATE)
print(sort(unique_states))
```

```
##  [1] "ALABAMA"              "ALASKA"               "AMERICAN SAMOA"      
##  [4] "ARIZONA"              "ARKANSAS"             "ATLANTIC NORTH"      
##  [7] "ATLANTIC SOUTH"       "CALIFORNIA"           "COLORADO"            
## [10] "CONNECTICUT"          "DELAWARE"             "DISTRICT OF COLUMBIA"
## [13] "E PACIFIC"            "FLORIDA"              "GEORGIA"             
## [16] "GUAM"                 "GULF OF ALASKA"       "GULF OF MEXICO"      
## [19] "HAWAII"               "HAWAII WATERS"        "IDAHO"               
## [22] "ILLINOIS"             "INDIANA"              "IOWA"                
## [25] "KANSAS"               "KENTUCKY"             "LAKE ERIE"           
## [28] "LAKE HURON"           "LAKE MICHIGAN"        "LAKE ONTARIO"        
## [31] "LAKE ST CLAIR"        "LAKE SUPERIOR"        "LOUISIANA"           
## [34] "MAINE"                "MARYLAND"             "MASSACHUSETTS"       
## [37] "MICHIGAN"             "MINNESOTA"            "MISSISSIPPI"         
## [40] "MISSOURI"             "MONTANA"              "NEBRASKA"            
## [43] "NEVADA"               "NEW HAMPSHIRE"        "NEW JERSEY"          
## [46] "NEW MEXICO"           "NEW YORK"             "NORTH CAROLINA"      
## [49] "NORTH DAKOTA"         "OHIO"                 "OKLAHOMA"            
## [52] "OREGON"               "PENNSYLVANIA"         "PUERTO RICO"         
## [55] "RHODE ISLAND"         "SOUTH CAROLINA"       "SOUTH DAKOTA"        
## [58] "ST LAWRENCE R"        "TENNESSEE"            "TEXAS"               
## [61] "UTAH"                 "VERMONT"              "VIRGIN ISLANDS"      
## [64] "VIRGINIA"             "WASHINGTON"           "WEST VIRGINIA"       
## [67] "WISCONSIN"            "WYOMING"
```

```r
sum(is.na(details$STATE))
```

```
## [1] 1
```


## Fatalities

## Locations

