%MACRO newTask;
	DATA newtask;
		id = %QUOTE(&SAVE_tasksCreatedCount+1);
		type = APPSRV_UNSAFE('type');
		description = APPSRV_UNSAFE('description');
		priority = INPUT(APPSRV_UNSAFE('priority'), 1.0);
	RUN;
%MEND newTask;

%newTask

%MACRO appendTask;
	DATA SAVE.tasklist;
		%IF &SAVE_tasksCreatedCount > 0 %THEN %DO;
		SET SAVE.tasklist newtask;
		%END;
		%ELSE %THEN %DO;
		SET newtask;
		%END;
	RUN;
%MEND appendTask;

%appendTask

%LET SAVE_tasksCreatedCount = %EVAL(&SAVE_tasksCreatedCount+1);

DATA _NULL_;
	FILE _webout TERMSTR=CRLF;
	PUT "Content-type: application/json";
	PUT "status: 201";
	PUT;
RUN;
