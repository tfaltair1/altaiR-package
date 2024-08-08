%macro SGANNO;
%mend;

%macro SGANNO_HELP(macroname);
%mend;

%macro _SGANNO_IS_PARAM_SET(p);
    %quote(&&&p) ^= %str()
%mend;

%macro _SGANNO_SET_CVAR(p);
    %if %_sganno_is_param_set(&p) %then %do;
        &p = %sysfunc(quote(%sysfunc(dequote(&&&p))));
    %end;
    %else %if %_sganno_is_param_set(reset) %then %do;
        &p = "";
    %end;
%mend;

%macro _SGANNO_SET_NVAR(p);
    %if %_sganno_is_param_set(&p) %then %do;
        &p = &&&p;
    %end;
    %else %if %_sganno_is_param_set(reset) %then %do;
        &p = .;
    %end;
%mend;

%macro SGARROW(
    x1=,
    xc1=,
    x2=,
    xc2=,
    y1=,
    yc1=,
    y2=,
    yc2=,
    direction=,
    discreteoffset=,
    drawspace=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    scale=,
    shape=,
    transparency=,
    url=,
    x1space=,
    x2space=,
    xaxis=,
    y1space=,
    y2space=,
    yaxis=);

    function = "arrow";

    /* Required variables */
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(x2);
    %_sganno_set_cvar(xc2);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);
    %_sganno_set_nvar(y2);
    %_sganno_set_cvar(yc2);

    /* Optional variables */
    %_sganno_set_cvar(direction);
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(scale);
    %_sganno_set_cvar(shape);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(x2space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(y2space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGIMAGE(
    image=,
    anchor=,
    border=,
    discreteoffset=,
    drawspace=,
    height=,
    heightunit=,
    id=,
    imagescale=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    rotate=,
    transparency=,
    url=,
    width=,
    widthunit=,
    x1=,
    xc1=,
    x1space=,
    xaxis=,
    y1=,
    yc1=,
    y1space=,
    yaxis=);

    function = "image";

    /* Required variables */
    %_sganno_set_cvar(image);

    /* Optional variables */
    %_sganno_set_cvar(anchor);
    %_sganno_set_cvar(border);
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_nvar(height);
    %_sganno_set_cvar(heightunit);
    %_sganno_set_cvar(id);
    %_sganno_set_cvar(imagescale);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(rotate);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_nvar(width);
    %_sganno_set_cvar(widthunit);
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGLINE(
    x1=,
    xc1=,
    x2=,
    xc2=,
    y1=,
    yc1=,
    y2=,
    yc2=,
    discreteoffset=,
    drawspace=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    transparency=,
    url=,
    x1space=,
    x2space=,
    xaxis=,
    y1space=,
    y2space=,
    yaxis=);

    function = "line";

    /* Required variables */
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(x2);
    %_sganno_set_cvar(xc2);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);
    %_sganno_set_nvar(y2);
    %_sganno_set_cvar(yc2);

    /* Optional variables */
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(x2space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(y2space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGOVAL(
    height=,
    width=,
    x1=,
    xc1=,
    y1=,
    yc1=,
    anchor=,
    discreteoffset=,
    display=,
    drawspace=,
    fillcolor=,
    fillstyleelement=,
    filltransparency=,
    heightunit=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    rotate=,
    transparency=,
    url=,
    widthunit=,
    x1space=,
    xaxis=,
    y1space=,
    yaxis=);

    function = "oval";

    /* Required variables */
    %_sganno_set_nvar(height);
    %_sganno_set_nvar(width);
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);

    /* Optional variables */
    %_sganno_set_cvar(anchor);
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(display);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(fillcolor);
    %_sganno_set_cvar(fillstyleelement);
    %_sganno_set_nvar(filltransparency);
    %_sganno_set_cvar(heightunit);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(rotate);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(widthunit);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGPOLYCONT(
    x1=,
    xc1=,
    y1=,
    yc1=,
    drawspace=,
    reset=,
    x1space=,
    y1space=);

    function = "polycont";
    
    /* Required variables */
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);

    /* Optional variables */
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(y1space);

    output;
%mend;

%macro SGPOLYGON(
    x1=,
    xc1=,
    y1=,
    yc1=,
    discreteoffset=,
    display=,
    drawspace=,
    fillcolor=,
    fillstyleelement=,
    filltransparency=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    transparency=,
    url=,
    x1space=,
    xaxis=,
    y1space=,
    yaxis=);

    function = "polygon";

    /* Required variables */
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);

    /* Optional variables */
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(display);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(fillcolor);
    %_sganno_set_cvar(fillstyleelement);
    %_sganno_set_nvar(filltransparency);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGPOLYLINE(
    x1=,
    xc1=,
    y1=,
    yc1=,
    discreteoffset=,
    drawspace=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    transparency=,
    url=,
    x1space=,
    xaxis=,
    y1space=,
    yaxis=);

    function = "polyline";

    /* Required variables */
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);

    /* Optional variables */
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGRECTANGLE(
    height=,
    width=,
    x1=,
    xc1=,
    y1=,
    yc1=,
    anchor=,
    cornerradius=,
    discreteoffset=,
    display=,
    drawspace=,
    fillcolor=,
    fillstyleelement=,
    filltransparency=,
    heightunit=,
    id=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    rotate=,
    transparency=,
    url=,
    widthunit=,
    x1space=,
    xaxis=,
    y1space=,
    yaxis=);

    function = "rectangle";

    /* Required variables */
    %_sganno_set_nvar(height);
    %_sganno_set_nvar(width);
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);

    /* Optional variables */
    %_sganno_set_cvar(anchor);
    %_sganno_set_nvar(cornerradius);
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(display);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(fillcolor);
    %_sganno_set_cvar(fillstyleelement);
    %_sganno_set_nvar(filltransparency);
    %_sganno_set_cvar(heightunit);
    %_sganno_set_cvar(id);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(rotate);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_cvar(widthunit);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGTEXT(
    label=,
    anchor=,
    border=,
    discreteoffset=,
    drawspace=,
    fillcolor=,
    fillstyleelement=,
    filltransparency=,
    id=,
    justify=,
    layer=,
    linecolor=,
    linepattern=,
    linestyleelement=,
    linethickness=,
    reset=,
    rotate=,
    textcolor=,
    textfont=,
    textsize=,
    textstyle=,
    textstyleelement=,
    textweight=,
    transparency=,
    url=,
    width=,
    widthunit=,
    x1=,
    xc1=,
    x1space=,
    xaxis=,
    y1=,
    yc1=,
    y1space=,
    yaxis=);

    function = "text";

    /* Required variables */
    %_sganno_set_cvar(label);

    /* Optional variables */
    %_sganno_set_cvar(anchor);
    %_sganno_set_cvar(border);
    %_sganno_set_nvar(discreteoffset);
    %_sganno_set_cvar(drawspace);
    %_sganno_set_cvar(fillcolor);
    %_sganno_set_cvar(fillstyleelement);
    %_sganno_set_nvar(filltransparency);
    %_sganno_set_cvar(id);
    %_sganno_set_cvar(justify);
    %_sganno_set_cvar(layer);
    %_sganno_set_cvar(linecolor);
    %_sganno_set_cvar(linepattern);
    %_sganno_set_cvar(linestyleelement);
    %_sganno_set_nvar(linethickness);
    %_sganno_set_nvar(rotate);
    %_sganno_set_cvar(textcolor);
    %_sganno_set_cvar(textfont);
    %_sganno_set_nvar(textsize);
    %_sganno_set_cvar(textstyle);
    %_sganno_set_cvar(textstyleelement);
    %_sganno_set_cvar(textweight);
    %_sganno_set_nvar(transparency);
    %_sganno_set_cvar(url);
    %_sganno_set_nvar(width);
    %_sganno_set_cvar(widthunit);
    %_sganno_set_nvar(x1);
    %_sganno_set_cvar(xc1);
    %_sganno_set_cvar(x1space);
    %_sganno_set_cvar(xaxis);
    %_sganno_set_nvar(y1);
    %_sganno_set_cvar(yc1);
    %_sganno_set_cvar(y1space);
    %_sganno_set_cvar(yaxis);

    output;
%mend;

%macro SGTEXTCONT(
    label=,
    reset=,
    textcolor=,
    textfont=,
    textsize=,
    textstyle=,
    textstyleelement=,
    textweight=);

    function = "textcont";

    /* Required variables */
    %_sganno_set_cvar(label);

    /* Optional variables */
    %_sganno_set_cvar(textcolor);
    %_sganno_set_cvar(textfont);
    %_sganno_set_nvar(textsize);
    %_sganno_set_cvar(textstyle);
    %_sganno_set_cvar(textstyleelement);
    %_sganno_set_cvar(textweight);

    output;
%mend;
