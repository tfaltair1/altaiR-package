DATA SAVE.tasklist;
	SET SAVE.tasklist;
	IF id = APPSRV_UNSAFE('id') THEN DELETE;
RUN;

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	PUT "status: 204";
	PUT;
RUN;
