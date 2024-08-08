PROC SQL;
  CREATE TABLE work.output AS SELECT
	distinct category
  FROM DATA.items;
QUIT; 

PROC SQL;
	SELECT COUNT(*) INTO:OBSERVATIONS FROM output;
RUN;

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
    PUT "PRAGMA: NO-CACHE";
    PUT "CACHE-CONTROL: NO-CACHE";
RUN;

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT;
	PUT '[';
RUN;

%MACRO listData;
	%IF &OBSERVATIONS > 0 %THEN %DO;
		DATA _NULL_;
			SET output;
			FILE _webout TERMSTR=CRLF;
			PUT "{";
			PUT '  "category": "' category '"' ;
			PUT "}";
			IF _N_ < &OBSERVATIONS THEN DO;
				PUT ',';
			END;
		RUN;
	%END;
%MEND listData;

%listData

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "]";
RUN;
