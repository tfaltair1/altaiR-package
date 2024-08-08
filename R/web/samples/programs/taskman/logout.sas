DATA _NULL_;
	rc = APPSRV_SESSION('delete');
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	PUT;
	PUT '{rc:' rc '}';
RUN;
