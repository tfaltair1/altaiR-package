DATA _NULL_;
	FILE _WEBOUT TERMSTR=CRLF;
	PUT "<html>";
	PUT "<body>";
	PUT "<div id='first'>";
	PUT "  <h1>Please wait..</h1>";
	PUT "  <p>In the background an image is being generated into the _TMPCAT catalog by the same program which created this output. Using Javascript, the document will automatically pull the image in when ready.</p>";
	PUT "</div>";
	PUT "<div id='second' style='display: none;'>";
	PUT "  <h1>Output</h1>";
	PUT "  <img id='output' />";
	PUT "</div>";
	PUT "<script type='text/javascript'>";
	PUT "setTimeout(function() {";
	PUT "document.getElementById('output').src='&_REPLAY.img.gif';";
	PUT "document.getElementById('second').style.display = 'block';";
	PUT "document.getElementById('first').style.display = 'none';";
	PUT "}, 1500);";
	PUT "</script>";
	PUT "</body>";
	PUT "</html>";
RUN;

DATA _NULL_;
	rc = APPSRV_SET('disconnect');
RUN;

DATA work.shoes;
  input product $ region $ sales;
cards;
foo a 100
foo b 100
foo c 100
bar a 100
bar b 100
bar c 100
baz a 300
baz b 300
baz c 300
;
RUN;

goptions gsfname=myGraph dev=gif xpixels=800 gsfmode=replace ypixels=400 transparency;

PROC GCHART DATA = work.shoes;
	TITLE;
	FILENAME myGraph catalog "&_TMPCAT..img.gif";
	HBAR2D product/sumvar=sales
	NOSTATS DISCRETE;
	RUN;
QUIT;
