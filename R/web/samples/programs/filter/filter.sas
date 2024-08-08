%macro SET_DEFAULT_VALUE(name, value);
	%if 0 = %symexist(&name) %THEN %DO;
		%GLOBAL &name;
		%LET &name = &value;
	%END;
%mend;

%SET_DEFAULT_VALUE(DEPARTMENT, )
%SET_DEFAULT_VALUE(ITEM, )

DATA data;
	LENGTH department $ 60;
	LENGTH item $ 60;
	department = "Sales";
	item  = "Pens";
	quantity = 100;
	cost = 10.00;
	output;
	department = "Sales";
	item  = "Paper";
	quantity = 5000;
	cost = 20.00;
	output;
	department = "Sales";
	item  = "Laptop";
	quantity = 2;
	cost =  1000.00;
	output;
	department = "IT";
	item  = "Computer Screen";
	quantity = 10;
	cost = 2000.00;
	output;
	department = "IT";
	item  = "Printer";
	quantity = 1;
	cost = 100.00;
	output;
	department = "IT";
	item  = "Paper";
	quantity = 5000;
	cost = 20.00;
	output;
RUN;

%MACRO getUnique(column);
	PROC SQL;
		CREATE TABLE unique_&column AS SELECT UNIQUE &column FROM data;
	QUIT;
	RUN;

	DATA unique_&column;
		SET unique_&column;
		LENGTH code $ 60;
		code = &column;
	RUN;

	DATA addAll;
		LENGTH &column $ 60;
		LENGTH code $ 60;
		&column = 'ALL';
		code = '';
	RUN;

	DATA unique_&column;
		SET addAll unique_&column;
	RUN;

%MEND;

%MACRO showSelect(dataset, column, valCol, name, value);
	DATA _NULL_;
		FILE _WEBOUT;
		PUT "<select name=""&name"">";
	RUN;

	DATA _NULL_;
		SET &dataset;
		FILE _WEBOUT;
		PUT "<option";
		IF "&value" = &valCol THEN DO;
			PUT "selected=""selected""";
		END;
		PUT "value=""";
		PUT &valCol;
		PUT """";
		PUT ">";
		PUT &column;
		PUT "</option>";
	RUN;

	DATA _NULL_;
		FILE _WEBOUT;
		PUT "</select>";
	RUN;
%MEND;

%getUnique(department)
%getUnique(item)


DATA _NULL_;
	FILE _WEBOUT;
	PUT "<form action=""&_URL"" METHOD=""POST"">";
	PUT "<h2>Filter</h2>";
	PUT "<label>Department:</label>";
RUN;

%showSelect(unique_department, department, code, department, &department)
DATA _NULL_;
	FILE _WEBOUT;
	PUT "<br />";
	PUT "<label>Item:</label>";
RUN;

%showSelect(unique_item, item, code, item, &item)

DATA _NULL_;
	FILE _WEBOUT;
	PUT "<br />";
	PUT "<input type=""submit"" value=""Filter"" name=""filter"" />";
	PUT "<input type=""hidden"" value=""&_Service"" name=""_SERVICE"" />";
	PUT "<input type=""hidden"" value=""&_program"" name=""_program"" />";
	PUT "</form>";
RUN;

ODS HTML BODY=_WEBOUT (TITLE="Department = &DEPARTMENT and Item = &ITEM");

TITLE 'Accounts report';
TITLE2 '';

%MACRO getData;
	PROC SQL;
		SELECT * FROM data WHERE
			department LIKE "%sysfunc(catx(&DEPARTMENT, %str(%%), %str(%%)))"
			AND item LIKE "%sysfunc(catx(&ITEM, %str(%%), %str(%%)))"
			ORDER BY department, item;
	QUIT;
	RUN;
%MEND;
%getData

ODS HTML CLOSE;
