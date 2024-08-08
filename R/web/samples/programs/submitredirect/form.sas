%macro SET_DEFAULT_VALUE(name, value);
	%if 0 = %symexist(&name) %THEN %DO;
		%GLOBAL &name;
		DATA _NULL_;
			CALL SYMPUT("&name", &value);
		RUN;
	%END;
%mend;

%SET_DEFAULT_VALUE(FNAME, "")
%SET_DEFAULT_VALUE(SNAME, "")

******************************************************************************;
* Create a new session if one does not exist already                          ;
******************************************************************************;
DATA _NULL_;
	rc = APPSRV_SESSION('create');
RUN;

DATA _NULL_;
	FILE _WEBOUT;
	PUT "<h2>Generate a message</h2>";
RUN;

******************************************************************************;
* Display an validations errors from a previous form submission and restore   ;
* input values. Then delete the save.inputs and save.validation_errors        ;
* datasets                                                                    ;
******************************************************************************;
%macro displayErrors;
	%if %sysfunc(exist(save.validation_errors)) %then %do;
		PROC SQL;
			SELECT COUNT(*) INTO:ERRORS FROM save.validation_errors;
		QUIT;
		RUN;
		%IF &ERRORS > 0 %THEN %DO;
			DATA _NULL_;
				FILE _WEBOUT;
				PUT "<div style=""font-weight: bold;"">";
				PUT "&ERRORS Errors</div>";
			RUN;
			DATA _NULL_;
				SET save.validation_errors;
				FILE _WEBOUT;
				PUT "<div style=""color: red;"">" error "</div>";
			DATA _NULL_;
				SET save.inputs;
				CALL SYMPUT(parm, trimn(left(value)));
			RUN;
		%END;
		proc datasets library=save;
			delete validation_errors;
			delete inputs;
		run;
	%end;
%mend;
%displayErrors

******************************************************************************;
* Display the form                                                            ;
******************************************************************************;
DATA _NULL_;
	FILE _WEBOUT;
	PUT "<form action=""&_URL"" METHOD=""GET"">";
	PUT "<label>Firstname:</label>";
	PUT "<input type=""text"" value=""&FNAME"" name=""FNAME"" />";
	PUT "<br />";
	PUT "<label>Surname:</label>";
	PUT "<input type=""text"" value=""&SNAME"" name=""SNAME"" />";
	PUT "<br />";
	PUT "<button name=""_program"" type=""submit"" value=""sr.work.sas"">";
	PUT "  Display message";
	PUT "</button>";
	PUT "<input type=""hidden"" value=""&_Service"" name=""_SERVICE"" />";
	PUT "<input type=""hidden"" value=""&_SERVER"" name=""_SERVER"" />";
	PUT "<input type=""hidden"" value=""&_PORT"" name=""_PORT"" />";
	PUT "<input type=""hidden"" value=""&_SESSIONID"" name=""_SESSIONID"" />";
	PUT "</form>";
RUN;
