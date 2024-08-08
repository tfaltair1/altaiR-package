data _NULL_;
  FILE _WEBOUT;
  PUT "Content-type: image/gif";
  PUT "PRAGMA: NO-CACHE";
  PUT "CACHE-CONTROL: NO-CACHE";
  PUT;
RUN;

%let name=bar3;

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
		%END;;
	QUIT; 
%MEND;

%getData


goptions gsfname=_grphout dev=gif xpixels=&width ypixels=&height transparency gunit=pct;


axis1 label=('Category');
axis2 label=('Sales') minor=(number=3);

pattern1 v=solid color=cx9999ff;  /* light blue */
pattern2 v=solid color=cx993366;  /* purplish */
pattern3 v=solid color=cxffffcc;  /* pale yellow */

title1 "";

proc gchart data=output;
hbar category / discrete type=sum sumvar=sales nostats
 subgroup=name /* this controls the coloring */
 autoref cref=graycc
 maxis=axis1 raxis=axis2
 coutline=black space=2
 des='' name="&name";  
run;

quit;
