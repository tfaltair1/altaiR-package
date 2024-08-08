ods listing close;
ods html body=_webout(dynamic);
proc print data=sashelp.vmacro;
run;
ods html close;