# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this 
project adheres to [Semantic Versioning](http://semver.org/).

## [v0.0.0.9001] - 2016-11-01

### Added

### Changed
  - `get_datasets`: Modified to read in all column values as character strings 
    to avoid `readr::read_csv` assuming one type then passing another value type 
    as NA. This was a particular problem with `details.TOR_WIDTH` where `readr` 
    would assume the values were integer then if it came across any floats it 
    would just pass NA as the value.

### Removed

