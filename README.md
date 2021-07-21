# README

### AUTHOR
Tom Kulmacz - July 21 2021


## DESCRIPTION
person_matcher.rb - is a command line utility that matches CSV rows that share an email or phone number

Parses a csv file to find matching rows via the email, phone, or any other column added to the config. Output
file will have a new first column added labeled matching_id that will contain a UUID. All rows that have a
matching identifiable attribute will share this UUID. The output file will be written in your pwd, assuming
you have write permission there.

Default algorithm options are same_email same_phone same_email_or_phone. For email and phone, the app will
automatically find columns in a csv file that start with the string email and phone, regardless of case.
The config file includes a regular expression that can be updated as you like, as well as an array field
to hard code any column titles you'd like to include for any algorithm.

To match against other column types, just add an alogirhtm to the algorithm list, an algorithm definition hash,
and optionally, a sanitizer file to normalize the data in this column. There is a default blank sanitizer to
use if no normalization is desired.

### SYNOPSIS
From the root app folder:

Usage: bin/person_matcher.rb (-a ALGORITHM -f FILEPATH | -h | -v)

```
 bin/person_matcher.rb -h
 bin/person_matcher.rb -v
 bin/person_matcher.rb -a same_email -f path/to/file.csv
```


###  OPTIONS
```
Usage: person_matcher.rb [options]

Required:
    -a, --algorithm ALGORITHM        [Required] Type of matching algorithm to use. Valid options are: same_email same_phone same_email_or_phone
    -f, --file FILEPATH              [Required] Process a CSV file: Please provide a complete file path.

Optional:
    -h, --help                       Prints this help
    -v, --version                    Show version
```


### OUTPUT
Results are written to a CSV file in the pwd that the utility is called from

`output_{timestamp}_{algorithm}.csv`


## TEST
Testing is done with Aruba/Cucumber for integration and Rspec for unit. The tmp folder is used for writing to during testing.
* Integration: `rake features`
* Unit tests: `rake spec`
* Both types: `rake spec features`


## Exit Codes
* 0 - Success
* 1 - Invalid command line option provided
* 2 - Missing argument on a required option
* 3 - Missing algorithm option
* 4 - Invalid matching algorithm provided
* 5 - Missing source file option
* 6 - Source CSV file not found
* 7 - Insufficient permissions to read source CSV
* 8 - Malformed source CSV
* 9 - Source CSV does not contain target column
* 10 - Insufficient permissions to write results CSV


## Future Improvements
* Save sanitized data into the output file
* Add a DB for storing the dictionary
* Localization


# TASK DESCRIPTION

The goal of this exercise is to identify rows in a CSV file that may represent the same person based on a provided Matching Type (definition below).

The resulting program should allow us to test at least three matching types:

one that matches records with the same email address
one that matches records with the same phone number
one that matches records with the same email address OR the same phone number

## Guidelines

Please DO NOT fork this repository with your solution
Use any language you want, as long as it can be compiled on OSX
Only use code that you have license to use
Don't hesitate to ask us any questions to clarify the project

## Resources

### CSV Files
Three sample input files are included. All files should be successfully processed by the resulting code.

### Matching Type
A matching type is a declaration of what logic should be used to compare the rows.
For example: A matching type named same_email might make use of an algorithm that matches rows based on email columns.

## Interface
At a high level, the program should take two parameters. The input file and the matching type.

## Output
The expected output is a copy of the original CSV file with the unique identifier of the person each row represents prepended to the row.
