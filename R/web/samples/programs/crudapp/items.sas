%MACRO getData;
	PROC SQL;
	  CREATE TABLE work.output AS SELECT
	    name, category, price, sales, monotonic() AS recno
	  FROM DATA.items
		%IF %symexist(categories) %THEN %DO;
			%IF %symexist(categories0) %THEN %DO;
				%DO i = 1 %to &CATEGORIES0;
				   %IF &i = 1 %THEN %DO;
					  WHERE (
				   %END;
				   category = "&&categories&i"
				   %IF &i < &CATEGORIES0 %THEN %DO;
					  OR
				   %END;
				   %IF &i = &CATEGORIES0 %THEN %DO;
					 )
				   %END;
				%%END;
			%END;
			%ELSE %DO;
				WHERE category = "&CATEGORIES"
			%END;
		%END;
	  HAVING recno > %IF &PAGE = 1 %THEN %DO; 0 %END; %ELSE %DO; %EVAL((&PAGE-1)*&PAGESIZE) %END;
	  AND recno <= %IF &PAGE = 1 %THEN %DO; &PAGESIZE %END; %ELSE %DO; &PAGESIZE %END;
	  ORDER BY &SORTCOL %IF &SORTASC = false %THEN %DO; DESC %END;;
	QUIT; 
%MEND;

%getData

PROC SQL;
	SELECT COUNT(*) INTO:OBSERVATIONS FROM output;
RUN;

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
    PUT "PRAGMA: NO-CACHE";
    PUT "CACHE-CONTROL: NO-CACHE";
	PUT "X-wps-numberOfItems: &OBSERVATIONS";
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
			PUT '  "name": "' name '",';
			PUT '  "category": "' category '",';
			PUT '  "price": ' price ',';
			PUT '  "sales": ' sales;
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
