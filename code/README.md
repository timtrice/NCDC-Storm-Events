# Code

## 01_get_data.R

This script downloads all csv.gz files from the database FTP server. The CSVs are imported and bound to one dataframe per table (`details`, `fatalities`, and `locations`) and saved within list `df`. 

Each table is saved to the ./data directory as a CSV file.

No tests or quality checks are performed.

## 02_tidy_data.R

Import the raw data files from ./data and perform cleaning operations. These operations are documented in some details in the README file within the ./output directory.

Tidied data files are saved in the ./output directory.

## fips.R

### Details

In the `details` dataset, there are two variables, `STATE_FIPS` and `CZ_FIPS`, that can be used to verify locations and help retrieve timezone information. A second source is needed; enter the US Census Bureau website.

There are several datasets available for the contiguous United States and additional states and territories. These datasets combined **may not** include everything needed. But, best guess, it should cover at least 95%

FIPS Class Codes

* H1: identifies an active county or statistically equivalent entity that does not qualify under subclass C7 or H6.
* H4: identifies a legally defined inactive or nonfunctioning county or statistically equivalent entity that does not qualify under subclass H6. 
* H5:  identifies census areas in Alaska, a statistical county equivalent entity.
* H6: identifies a county or statistically equivalent entity that is areally coextensive or governmentally consolidated with an incorporated place, part of an incorporated place, or a consolidated city.
* C7: identifies an incorporated place that is an independent city; that is, it also serves as a county equivalent because it is not part of any county, and a minor civil division (MCD) equivalent because it is not part of any MCD.

[Source](https://www.census.gov/geo/reference/codes/cou.html)

## functions.R

### var_conversion

Test variables in dataframe and convert, without error, to integer, double, or leave as character.

This function probably isn't necessary and was written more as a personal exercise. When `readr::read_csv` guesses at variable types, some are missed (classified as integer when should be double). Instead of changing the guess_max parameter, I just wrote this function.

## zone_county.R

### Details

`fips` helps validate location data; we can use the "ZoneCounty" dataset from the National Weather Service to get timezone information.

[Source](https://www.weather.gov/gis/ZoneCounty)
