# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this 
project adheres to [Semantic Versioning](http://semver.org/).

## [v0.0.0.9004] - yyyy-mm-dd

### Added
  - NA

### Changed
  - NA

### Removed
  - NA

## [v0.0.0.9003] - 2016-11-02

### Added
  - NA

### Changed
  - In `details_col_types`, `CZ_FIPS` from character class to integer class. 
  - In "Downloading Datasets" vignette, removed content about merging datasets 
    automatically which at the moment produces errors.

### Removed
  - `Cleaning Datasets` vignette
  - `Comment Errors and Messages` vignette which was never written.

## [v0.0.0.9002] - 2016-11-02

### Added
  - `details_names`, `details_col_types`, `fatalities_names`, 
    `fatalities_col_types`, `locations_names`, `locations_col_types` to assign 
    column names and types when using `readr::read_csv`.

### Changed

### Removed
  - setkey; no longer needed for Data.Table joins since v1.9.6
  - removed the modifications from v0.0.0.9001 (2016-11-01)

## [v0.0.0.9001] - 2016-11-01

### Added

### Changed
  - `get_datasets`: Modified to read in all column values as character strings 
    to avoid `readr::read_csv` assuming one type then passing another value type 
    as NA. This was a particular problem with `details.TOR_WIDTH` where `readr` 
    would assume the values were integer then if it came across any floats it 
    would just pass NA as the value.

### Removed

