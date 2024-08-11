# altaiR

## This package is intended to wrap the functionality of Altair SAS Language Compiler, henceforth referred to as SLC. SLC is a language compiler that will run your native SAS code without a SAS Institute install or license. This product does require an Altair License to run, however. 

## There are three functions in this package. 

### 1) altaiR::auth() which takes one argument, your Altairone username in double quotes. It will prompt for your password to authenticate to the Altairone server.

### 2) altaiR::compile() which will take your rawtext code provided in argument one, and compile it. It also takes a second argument, that will set your final data set path. Whatever the last data step in your SAS program is named, be sure to include that as a second argument so this function can read your .sas7bdat output in haven and return a .rds dataset. 

### 3) altaiR::runFile() which takes a location of a local .sas program file, and a data set output path like in 2). 

## Once you have compiled your SAS data in R and have R dataframes of the outputs, you can interface seamlessly with ggplot2 et. Al. to do your visualisations.

#### developed with intent to distribute as open source by tfantuzzo@altair.com

## Authenticate
```r
auth("tfantuzzo@altair.com")
```

## Run raw code
```r
compile(
'
libname out sas7bdat "./";

data out.sample_data;
  input ID $ Name $ Age Salary;
  datalines;
101 John 28 50000
102 Jane 34 60000
103 Mike 45 70000
104 Lisa 29 55000
;
run;
', finalDSPath = "./sample_data.sas7bdat")
```

## Run a file
```r
runFile("./test.sas", finalDSPath = "./sample_data.sas7bdat")
```