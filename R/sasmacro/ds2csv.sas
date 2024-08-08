%macro ds2csv(data=, sepchar=, csvfile=, csvfref=, labels=Y,
  colhead=Y, formats=Y, var=, where=, openmode=REPLACE, pw=,
  runmode=S, conttype=Y, contdisp=Y, savefile=, mimehdr1=,
  mimehdr2=, mimehdr3=, mimehdr4=, mimehdr5=);
  %let colhead = %upcase(&colhead);
  %let formats = %upcase(&formats);
  %let openmode = %upcase(&openmode);
  %let runmode = %upcase(&runmode);
  %let labels = %upcase(&labels);
  %let conttype = %upcase(&conttype);
  %let contdisp = %upcase(&contdisp);

  %if %eval("&csvfile" NE "" and "&csvfref" NE "") %then %do;
    %put CSVFILE= and CSVFREF= specified. CSVFREF will be ignored;
  %end;
  %else %if %eval("&csvfile" EQ "" and "&csvfref" EQ "") %then %do;
    %put One of CSVFILE= and CSVFREF= must be specified.;
    %return;
  %end;

  %if "&data" EQ "" %then %do;
    %put DATA= must be specified;
    %return;    
  %end;
  
  %if %eval("&openmode" NE "REPLACE" and "&openmode" NE "APPEND") 
  %then %do;
    %put "&openmode" is not valid for OPENMODE=.
Please use APPEND or REPLACE.;
    %return;
  %end;

  %if %eval("&labels" NE "Y" and "&labels" NE "N") %then %do;
    %put "&labels" is not valid for LABELS=. Please use Y or N.;
    %return;
  %end;

  %if %eval("&formats" NE "Y" and "&formats" NE "N") %then %do;
    %put "&formats" is not valid for FORMATS=. Please use Y or N.;
    %return;
  %end;

  %if %eval("&colhead" NE "Y" and "&colhead" NE "N") %then %do;
    %put "&colhead" is not valid for COLHEAD=. Please use Y or N.;
    %return;
  %end;

  %if %eval("&conttype" NE "Y" and "&conttype" NE "N") %then %do;
    %put "&conttype" is not valid for CONTTYPE=. Please use Y or N.;
    %return;
  %end;

  %if %eval("&contdisp" NE "Y" and "&contdisp" NE "N") %then %do;
    %put "&contdisp" is not valid for CONTDISP=. Please use Y or N.;
    %return;
  %end;

  %if "&sepchar" NE "" %then %do;
    %let sepchar="&sepchar"x;
  %end;
  %else %do;
    %if "&SYSSCP" EQ "OS" %then %do;
      %let sepchar = '6b'x;
    %end;
    %else %do;
      %let sepchar = '2c'x;
    %end;
  %end;

 %if %eval("&contdisp" NE "Y" and "&contdisp" NE "N") %then %do;
  %put "&contdisp" is not valid for CONTDISP=. Please use Y or N.;
  %return;
 %end;

  %let random = %sysfunc(ceil(%sysfunc(time())));

  %if "&runmode" EQ "S" %then %do;
    %if "&savefile" EQ "" %then %do;
      %let savefile = &data..csv;
    %end;
    %let lrecl = %sysfunc(max(80,
      %eval(%length(&savefile) + 50),
      %length(&mimehdr1),
      %length(&mimehdr2),
      %length(&mimehdr3),
      %length(&mimehdr4),
      %length(&mimehdr5)));
    
    data _null_;
    %if "&csvfile" NE "" %then %do;
      file "%sysfunc(compress(&csvfile, %str(%')))" DSD DROPOVER 
    %end;
    %else %do;
      file &csvfref DSD DROPOVER 
    %end;
    %if "&openmode" EQ "APPEND" %then %do;
      mod
    %end;
    %if "&SYSSCP" NE "OS" %then %do;
      lrecl=&lrecl
    %end;
    ;
    
    %if "&conttype" EQ "Y" %then %do;
      put "Content-Type: text/csv";
    %end;   

    %if "&contdisp" EQ "Y" %then %do;
      put "Content-Disposition: attachment; filename=&savefile";
    %end;   
    
    
    do i = 1 to 5;
      length _mh &SYSDOLLARCHAR &lrecl;
      _mh = symget('mimehdr'||putn(i,'1.'));
      if _mh NE "" then do;
        put _mh;
      end;
    end;

    put;
    run;
  %end;

  proc sql;
    create view work._tmp&random as
    %if %str(&var) NE %str() %then %do;
      select %sysfunc(translate(%cmpres(&var),%quote(,), %quote( ))) 
        from &data
    %end;
    %else %do;
      select * from &data
    %end;
    %if %str(&where) NE %str() %then %do;
      where &where
    %end;
    ;
  quit;
  
  quit;
  proc export
    data=work._tmp&random
    %if "&csvfile" NE "" %then %do;
      outfile="%sysfunc(compress(&csvfile, %str(%')))"
    %end;
    %else %do;
      outfile=&csvfref
    %end;
    dbms=dlm
    %if %eval("&openmode" EQ "APPEND" or "&runmode" EQ "S") %then %do;
      append
    %end;
    %else %do;
      replace
    %end;
    quote
    %if "&labels" EQ "Y" %then %do;
      label
    %end;
    %if "&formats" EQ "N" %then %do;
      %put FORMATS=NO;
      noformats
    %end;
    ;
    %if "&colhead" EQ "N" %then %do;
      putnames=no;
    %end;
    delimiter=&sepchar;
  run;
  
  proc datasets library=work nolist;
    delete _tmp&random / mt=view;
  quit;
%mend ds2csv;
