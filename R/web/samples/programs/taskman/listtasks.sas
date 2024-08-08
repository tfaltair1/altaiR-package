%MACRO getData;
	PROC SQL;
	  CREATE TABLE work.tasklist AS SELECT *
		FROM SAVE.tasklist
		WHERE description LIKE "%sysfunc(catx(&filter, %str(%%), %str(%%)))";
	QUIT; 
%MEND;
%getData

%MACRO doSort;
	PROC SORT DATA=tasklist OUT=tasklist;
		BY %IF &SORTASC = false %THEN %DO; DESCENDING %END; &SORTCOL;
%MEND doSort;

%doSort

PROC SQL;
	SELECT COUNT(*) INTO:OBSERVATIONS FROM tasklist;
RUN;

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	PUT;
	PUT '[';
RUN;

%MACRO listTasks;
	%IF &SAVE_tasksCreatedCount > 0 %THEN %DO;
		DATA _NULL_;
			SET tasklist;
			FILE _webout TERMSTR=CRLF;
			PUT "{";
			PUT '  "id": "' id '",';
			PUT '  "type": "' type '",';
			PUT '  "description": "' description '",';
			PUT '  "priority": "' priority '"';
			PUT "}";
			IF _N_ < &OBSERVATIONS THEN DO;
				PUT ',';
			END;
		RUN;
	%END;
%MEND listTasks;

%listTasks

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "]";
RUN;
