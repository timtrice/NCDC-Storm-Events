## Test environments
* Ubuntu 16.04.1 LTS, R 3.2.3

## R CMD check results
There are no ERRORs or WARNINGs. 

There is 1 NOTE:

* checking R code for possible problems ... NOTE
  .sample_dataframes: no visible binding for global variable ‘details’
  ... 75 lines ...
  
  These are names of dataframes and dataframe variables/columns used within dplyr functions.

***

## Downstream dependencies
I have also run R CMD check on downstream dependencies of httr 
(https://github.com/wch/checkresults/blob/master/httr/r-release). 
All packages that I could install passed except:

* Ecoengine: this appears to be a failure related to config on 
  that machine. I couldn't reproduce it locally, and it doesn't 
  seem to be related to changes in httr (the same problem exists 
  with httr 0.4).