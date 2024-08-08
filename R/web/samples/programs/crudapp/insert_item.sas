%MACRO dowork;
	PROC SQL;
	  INSERT INTO data.items (name, category, price, sales)
	  VALUES ("&name", "&category", &price, &sales);
	QUIT; 
%MEND;

%dowork

DATA _NULL_;
  FILE _WEBOUT TERMSTR=CRLF;
  PUT "Content-type: text/plain";
  PUT "PRAGMA: NO-CACHE";
  PUT "CACHE-CONTROL: NO-CACHE";
  PUT "Status: 201";
  PUT;
RUN;
