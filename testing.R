auth("tfantuzzo@altair.com")

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

runFile("./test.sas", finalDSPath = "./sample_data.sas7bdat")