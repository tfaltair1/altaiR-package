%MACRO getData;
	PROC SQL;
	  CREATE TABLE work.output AS SELECT
	    name, category, price, sales
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
	  ORDER BY &SORTCOL %IF &SORTASC = false %THEN %DO; DESC %END;;
	QUIT; 
%MEND;

%getData

DATA _NULL_;
  FILE _WEBOUT TERMSTR=CRLF;
  PUT "Content-type: text/csv";
  PUT "Set-Cookie: fileDownload=true; path=/";
  PUT "PRAGMA: NO-CACHE";
  PUT "CACHE-CONTROL: NO-CACHE";
  PUT "Content-Disposition: attachment; filename=items.csv";
  PUT;
RUN;

PROC EXPORT DATA=WORK.OUTPUT
OUTFILE=_webout
DBMS=CSV REPLACE;
RUN;
