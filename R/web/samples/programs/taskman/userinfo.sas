DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	PUT;
	PUT "{";
	PUT '  "fname": "' "&SAVE_FNAME" '",';
	PUT '  "sname": "' "&SAVE_SNAME" '"';
	PUT "}";
RUN;
