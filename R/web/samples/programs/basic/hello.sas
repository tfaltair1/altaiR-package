data _null_;
file _webout TERMSTR=CRLF;
put "Content-type: text/html";
put;
put "<html>";
put "Hello World!";
put "</html>";
