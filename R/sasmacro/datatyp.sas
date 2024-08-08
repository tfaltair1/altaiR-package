/*
 * DATATYP macro
 * The DATATYP macro outputs NUMERIC if the argument parses
 * as a number via the best32. informat. Otherwise it outputs CHAR.
 * Also returns CHAR if the argument is empty
 */
%MACRO DATATYP(arg);
  %if %length(&arg) = 0 %then %do;CHAR%end;
  %else %do;
  %if %sysfunc(lookslikenumber(&arg)) %then %do;NUMERIC%end;
  %else %do;CHAR%end;
  %end;
%MEND;
