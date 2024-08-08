DATA _NULL_;
	filesep =  '/';
	IF index("&SYSSCP", 'WIN') THEN DO;
		filesep = '\';
	END;
	full = SYMGET('SYSPROCESSNAME');
	path = TRANWRD(full, 'Program', '');
	index_before_rev = INDEX(path, "s");
	path_sub = SUBSTR(path, index_before_rev);
	rpath = STRIP(REVERSE(path));
	index = INDEX(rpath, filesep);
	rpath_sub = SUBSTR(rpath, index);
	dir = TRIM(STRIP(REVERSE(rpath_sub)));
	programs_dir = CATS(dir, "programs");
	data_dir = CATS(dir, "data");

	basic_programs_dir = CATS(programs_dir, filesep, "basic");
	CALL SYMPUT('BASIC_PROGRAMS_DIR', basic_programs_dir);

	taskman = CATS(programs_dir, filesep, "taskman");
	CALL SYMPUT('TASKMAN_PROGRAMS_DIR', taskman);

	crudapp = CATS(programs_dir, filesep, "crudapp");
	CALL SYMPUT('CRUDAPP_PROGRAMS_DIR', crudapp);

	tr = CATS(programs_dir, filesep, "tmpcatreplay");
	CALL SYMPUT('TR_PROGRAMS_DIR', tr);

	chatapp = CATS(programs_dir, filesep, "chatapp");
	CALL SYMPUT('CA_PROGRAMS_DIR', chatapp);

	sr = CATS(programs_dir, filesep, "submitredirect");
	CALL SYMPUT('SR_PROGRAMS_DIR', sr);

	filterapp = CATS(programs_dir, filesep, "filter");
	CALL SYMPUT('FILTER_PROGRAMS_DIR', filterapp);
	
	CALL SYMPUT('DATA_DIR', data_dir);
RUN;

LIBNAME data "&DATA_DIR";

DATA data.items;
INPUT name$ category$ price sales;
	CARDS;
pants uwear 5.00 100.0
socks uwear 8.00 250.0
jeans casual 25.00 50.0
tie smart 5.00 1.0
coat outdoors 70.00 50.0
scarf outdoors 5.00 300.0
tshirt casual 7.00 100.0
shirt smart 20.00 20.0
RUN;

PROC APPSRV &SYSPARM;
	ALLOCATE FILE sample "&BASIC_PROGRAMS_DIR";
	ALLOCATE FILE crud "&CRUDAPP_PROGRAMS_DIR";
	ALLOCATE FILE taskman "&TASKMAN_PROGRAMS_DIR";
	ALLOCATE FILE tr "&TR_PROGRAMS_DIR";
	ALLOCATE FILE ca "&CA_PROGRAMS_DIR";
	ALLOCATE FILE sr "&SR_PROGRAMS_DIR";
	ALLOCATE FILE filter "&FILTER_PROGRAMS_DIR";
	ALLOCATE LIBRARY data "&DATA_DIR";
	PROGLIBS sample crud taskman tr ca sr filter;
	DATALIBS data;
RUN;
