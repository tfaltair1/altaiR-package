%MACRO saveMessage;
	%IF %SYMEXIST(msg) & "&msg" ~= "" %THEN %DO;
		%IF ¬%sysfunc(exist(APSWORK.messages)) %THEN %DO;
			DATA APSWORK.messages;
				LENGTH user $ 16;
				LENGTH msg $ 160;
				user = "&SAVE_username";
				msg = "&msg";
				date_time = datetime();
			RUN:
		%END;
		%ELSE %DO;
			DATA tmp;
				FILE _WEBOUT;
				user = "&SAVE_username";
				msg = "&msg";
				date_time = datetime();
			RUN;

			DATA APSWORK.messages;
				SET APSWORK.messages tmp;
			RUN;
		%END;
	%END;
%MEND;
%saveMessage

DATA _NULL_;
	FILE _WEBOUT;
	PUT "<html>";
	PUT " <head>";
	PUT "  <meta http-equiv=""refresh"" content=""0;URL=&_THISSESSION" '&_program=ca.chatapp.sas' """ />";
	PUT " </head>";
	PUT "<body>";
	PUT "  <a href=""&_THISSESSION" '&_program=ca.chatapp.sas' """>Click here if your browser does not redirect</a>";
	PUT "</body>";
	PUT;
RUN;
