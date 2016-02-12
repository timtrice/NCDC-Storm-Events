# README

## NCDC Storm Events

This project is in continuation of a project assignment I took in *Reproducible Research* offered through [Coursera](http://www.coursera.org) via Johns Hopkins University. 

This project does *not* provide solutions to that programming assignment. It is merely an effort to perform data collection, cleaning and analysis with a very large dataset. However, one may be able to get a better idea on handling that dataset or similarly large datasets. 

Data files will not be hosted in this repository due to the size. To reproduce any analysis or perform your own, you are welcome to download the scripts. 

### Codebook

The most recent codebook and naming conventions can be found on the [Storm Events Database](https://www.ncdc.noaa.gov/stormevents/ftp.jsp) website.

### Nomenclature

* files are verbs to describe a dataset, function or group of functions contained within, or the analysis. Names are seperated by hyphens and generally will not extend beyond fiften characters.

> sample-file.R

* functions are verbs to describe the function. Names are seperated by underscore characters.

> sample_function()

* variables are nouns and follow the function naming structure.

> sample_var

### Warning Messages

When retrieving data, i.e., `get_data`, there are three types of warnings to know about:

> Max file size exceeded. Max size (5e+06) < Aggregate (1e+07) To proceed, set warn = FALSE. Otherwise, select fewer years or types.

This means no datasets were downloaded. The estimated size of all datasets requested is larger than the  `max_size` parameter. By default, `max_size` is 5MB (5e6). So if the estimated aggregate size of the datasets is greater than `max_size` then `get_data` will stop and throw the above error.

To overcome this, you can either increase `max_size` which is advisable only if you have the proper resources (i.e., internet speed, processor speed, etc.). Or, you can simply turn off warnings by setting `warn` to **FALSE**. Changing the `warn` parameter *does not* turn off warnings. It only allows the script to skip the `max_size` check.

Note that `max_size` is based on estimates of *.gz* files and the actual data imported will be larger. 

> In get_data(c(), type = c("details", "fatalities", "locations"),  :
  No check on aggregate max file size.

This message simply states that the `warn` parameter was turned off or set to **FALSE**.

> Total data size requested: 12825.20kb

States the *estimated* total size of data requested. This estimate is based on *.gz* files, therefore the data actually imported after extraction will be larger. 
