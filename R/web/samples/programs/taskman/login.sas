DATA sessstart;
	rc = APPSRV_SESSION('create');
RUN;

DATA _NULL_;
	SET sessstart;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	IF rc ~= 0 THEN DO;
		PUT "status: 400";
	END;
	ELSE DO;
		CALL SYMPUT("SAVE_FNAME", "&FNAME");
		CALL SYMPUT("SAVE_SNAME", "&SNAME");
		PUT;
		PUT "{";
		PUT '  "_service": "' "&_SERVICE" '",';
		PUT '  "_server": "' "&_SERVER" '",';
		PUT '  "_port": "' "&_PORT" '",';
		PUT '  "_sessionid": "' "&_SESSIONID" '"';
		PUT "}";
	END;
RUN;

DATA SAVE.tasklist;
	INPUT id type $ 32 description $ 1024 priority $ 4;
RUN;
%LET SAVE_tasksCreatedCount = 0;
