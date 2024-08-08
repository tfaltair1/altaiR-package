/*
 * VERIFY macro
 * The VERIFY macro returns the position of the first 
 * character of source that is not in excerpt
 */
%MACRO VERIFY(source, excerpt);
  %IF %length(&source)=0 OR %length(&excerpt)=0 %THEN %DO;
    %put ERROR: ARGUMENT TO VERIFY FUNCTION MISSING;
    %RETURN;
  %END;

  %LOCAL i;
  %DO i=1 %TO %LENGTH(&source);
    %IF %index(&excerpt, %qsubstr(&source, &i, 1))=0 %THEN %DO;
      &i
      %RETURN;
    %END;
  %END;
  0
%MEND;