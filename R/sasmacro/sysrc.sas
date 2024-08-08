%macro sysrc(mnemonic);
  %let _DSENOM  = 1230015;
  %let _DSENMR  = 1230013;
  %let _DSEMTR  = 1230014;
  %let _SENOCHN =  630058;
  %let _SEDLREC =  630049;
  %let _SEINVLN =   20014;
  %let _SOK     =  0;
  %let _SWLKUSR = -630097;
  %let _SWLKYOU = -630098;
  %let _SWNOLKH = -630099;
  &&&mnemonic
%mend;

