data _null_;
a=42;
b=73;
c=sdkxmpadd(a,b);

put c= "(should be 115)";

data _null_;
a="Hello ";
b="World";
length c $16;
c=sdkxmpcat(a, b);
put c= "(should be 'Hello World')";

data _null_;
a=sdkxmpchoosen(4, 1, 2, 3, 5, 7, 9, 11, 13);
put a= "(should be 5)";

data _null_;
a=sdkxmpchoosec(4, "one", "two", 
      "three", "five", "seven", "nine", 
      "eleven", "thirteen");
put a= "(should be 'five')";

data _null_;
a=1;
put a sdkxmponetwo5. " (should be 'ONE')";

data _null_;
a='hello';
put a sdkxmponeoff5. " (should be 'ifmmp')";

data _null_;
a=input('ONE', sdkxmponetwo.);
b=input('TWO', sdkxmponetwo.);
put a= "(should be 1)";
put b= "(should be 2)";
run;
