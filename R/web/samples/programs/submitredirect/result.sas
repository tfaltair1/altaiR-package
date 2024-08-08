DATA _NULL_;
	SET save.messages;
	FILE _WEBOUT;
	PUT "<p>" msg "</p>";
RUN;
