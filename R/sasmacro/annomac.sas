%macro ANNOMAC;
%mend ANNOMAC;

%macro ARROW(x1, y1, x2, y2, color, line, size, angle, style);
  function = "move";
  x        = &x1;
  y        = &y1;
  output;

  function = "arrow";
  x        = &x2;
  y        = &y2;
  color    = "&color";
  line     = &line;
  size     = &size;
  angle    = &angle;
  style    = "&style";
  output;
%mend ARROW;

%macro BAR(x1, y1, x2, y2, color, line, style);
  function = "move";
  x        = &x1;
  y        = &y1;
  output;

  function = "bar";
  x        = &x2;
  y        = &y2;
  color    = "&color";
  line     = &line;
  style    = "&style";
  output;
%mend BAR;

%macro BAR2(x1, y1, x2, y2, color, line, style, width);
  function = "move";
  x        = &x1;
  y        = &y1;
  output;

  function = "bar";
  x        = &x2;
  y        = &y2;
  color    = "&color";
  line     = &line;
  style    = "&style";
  size     = &width; output;
%mend BAR2;

%macro CENTROID (input_dataset,
                 output_dataset,
                 id_vars,
                 segonly=);
  %local i
         id
         id_count
         has_segment_var
         opt_segment
         needle
         haystack;

  %macro DATASET_HAS_VAR(dataset, variable);
    %local dataset_id rc;
    %let dataset_id = %sysfunc(open(&dataset));
    %if (&dataset_id) %then %do;
      %if %sysfunc(varnum(&dataset_id, &variable)) %then 1;
      %else 0;
      %let rc = %sysfunc(close(&dataset_id));
    %end;
    %else 0;
  %mend;

  %macro HAS_AREA_CHANGED;
    %local i;
    %do i = 1 %to &id_count;
      %if &i > 1 %then or; &id ^= &id._prev
    %end;
  %mend;

  %macro HAS_SEGMENT_CHANGED;
    %HAS_AREA_CHANGED
    %if &has_segment_var %then or segment ^= segment_prev;
  %mend;

  %macro IS_FIRST_OBS_IN_AREA;
    %local i id;
    %do i = 1 %to &id_count;
      %let id = %sysfunc(scan(&id_vars., &i, " "));
      %if &i > 1 %then or; first.&id.
    %end;
  %mend;

  %macro IS_LAST_OBS_IN_AREA;
    %local i id;
    %do i = 1 %to &id_count;
      %let id = %sysfunc(scan(&id_vars., &i, " "));
      %if &i > 1 %then or; last.&id.
    %end;
  %mend;

  %macro IS_FIRST_OBS_IN_SEGMENT;
    %IS_FIRST_OBS_IN_AREA
    %if &has_segment_var %then or first.segment;
  %mend;

  %macro IS_LAST_OBS_IN_SEGMENT;
    %IS_LAST_OBS_IN_AREA
    %if &has_segment_var %then or last.segment;
  %mend;

  %macro IS_FIRST_OBS_IN_POLY;
    %IS_FIRST_OBS_IN_SEGMENT or first.polygon_num
  %mend;

  %macro IS_LAST_OBS_IN_POLY;
    %IS_LAST_OBS_IN_SEGMENT or last.polygon_num
  %mend;

  /* Count number of ID variables. */
  %let id_count = %sysfunc(countw(&id_vars));

  /* Check input_dataset exists. */
  %if %sysfunc(exist(&input_dataset)) = 0 %then %do;
    %let needle = %upcase(&input_dataset);
    %put ERROR: CENTROID: %upcase(&needle) does not exist.;
    %return;
  %end;

  /* Check ID variables are defined in input_dataset. */
  %do i = 1 %to &id_count;
    %let id = %sysfunc(scan(&id_vars., &i, " "));
    %if %DATASET_HAS_VAR(&input_dataset, &id) = 0 %then %do;
      %let needle = %upcase(&id);
      %let haystack = %upcase(&input_dataset);
      %put ERROR: CENTROID: &needle does not exist in &haystack.;
      %return;
    %end;
  %end;

  /* Determine if SEGMENT variable is defined in input_dataset. */
  %let has_segment_var = %DATASET_HAS_VAR(&input_dataset, segment);

  %if &has_segment_var %then %do;
    %let opt_segment = segment;
  %end;
  %else %do;
    %let opt_segment =;
  %end;

  /*
   * STEP 1: Pre-process the dataset:
   *         - Add polygon numbers.
   *         - Remove observations with null X/Y values (i.e. holes).
   *         - Remove segments that do not contribute to the centroid.
   */
  data __centroid_tmp_1 / view=__centroid_tmp_1;
    set &input_dataset(keep=&id_vars &opt_segment x y);
    retain segment_num polygon_num 1;
    keep &id_vars &opt_segment polygon_num x y;

    %do i = 1 %to &id_count;
      %let id = %sysfunc(scan(&id_vars., &i, " "));
      retain &id._prev;
    %end;

    %if &has_segment_var %then %do;
      retain segment_prev;
    %end;

    if %HAS_AREA_CHANGED then do;
      segment_num = 1;
    end;
    else if %HAS_SEGMENT_CHANGED then do;
      segment_num = segment_num + 1;
    end;

    if %HAS_SEGMENT_CHANGED then do;
      polygon_num = 1;
    end;

    %do i = 1 %to &id_count;
      %let id = %sysfunc(scan(&id_vars., &i, " "));
      &id._prev = &id;
    %end;

    %if &has_segment_var %then %do;
      segment_prev = segment;
    %end;

    if x = . or y = . then do;
      polygon_num = polygon_num + 1;
      delete;
    end;

    %if %quote(&segonly) ^= %str() %then %do;
      if &segonly ^= segment_num then do;
        delete;
      end;
    %end;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 2: Sort observations by area, segment (if we have it) and
   *         polygon, allowing easier identification of the first and
   *         last observations in each.
   */
  proc sort data=__centroid_tmp_1 out=__centroid_tmp_2;
    by &id_vars &opt_segment polygon_num;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 3: Make sure that all polygons are closed (i.e. the first and
   *         and last X/Y values are identical). This is required for
   *         correct centroid calculation.
   */
  data __centroid_tmp_3 / view=__centroid_tmp_3;
    set __centroid_tmp_2;
    by &id_vars &opt_segment polygon_num;
    retain x_first y_first 0;
    keep &id_vars &opt_segment polygon_num x y;

    if %IS_FIRST_OBS_IN_POLY then do;
      x_first = x;
      y_first = y;
    end;

    if %IS_LAST_OBS_IN_POLY and (x_first ^= x or y_first ^= y) then do;
      output;

      x = x_first;
      y = y_first;
    end;

    output;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 4: Calculate the centroid and area of each polygon.
   */
  data __centroid_tmp_4 / view=__centroid_tmp_4;
    set __centroid_tmp_3;
    by &id_vars &opt_segment polygon_num;
    keep &id_vars &opt_segment x y area;
    retain x_prev y_prev cx_tmp cy_tmp area_tmp 0;

    if %IS_FIRST_OBS_IN_POLY then do;
      cx_tmp = 0;
      cy_tmp = 0;
      area_tmp = 0;
    end;
    else do;
      xprev_mult_ycurr = x_prev * y;
      xcurr_mult_yprev = x * y_prev;

      diff_tmp = xprev_mult_ycurr - xcurr_mult_yprev;

      cx_tmp = cx_tmp + ((x_prev + x) * diff_tmp);
      cy_tmp = cy_tmp + ((y_prev + y) * diff_tmp);

      area_tmp = area_tmp + diff_tmp;
    end;

    x_prev = x;
    y_prev = y;

    if %IS_LAST_OBS_IN_POLY then do;
      area = 0.5 * area_tmp;
      denom = 6.0 * area;
      x = cx_tmp / denom;
      y = cy_tmp / denom;

      /* Modify the calculated area such that a filled polygons have a
         positive area and holes have a negative area. */
      if (polygon_num = 1 and area < 0) or
         (polygon_num > 1 and area > 0) then do;
        area = area * -1;
      end;
    end;
    else delete;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 5: For each area, calculate the total area of all contained
   *         polygons.
   */
  data __centroid_tmp_5 / view=__centroid_tmp_5;
    set __centroid_tmp_4;
    by &id_vars;
    keep &id_vars area_sum;
    retain area_sum;

    if %IS_FIRST_OBS_IN_AREA then do;
      area_sum = 0;
    end;

    area_sum = area_sum + area;

    if %IS_LAST_OBS_IN_AREA then do;
      output;
    end;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 6: Merge centroids with area totals.
   */
  data __centroid_tmp_6 / view=__centroid_tmp_6;
    merge __centroid_tmp_4 __centroid_tmp_5;
    by &id_vars;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 7: Calculate the centroid of each area.
   */
  data &output_dataset;
    set __centroid_tmp_6;
    by &id_vars;
    keep &id_vars &opt_segment x y;
    retain cx cy 0;

    if %IS_FIRST_OBS_IN_AREA then do;
      cx = 0;
      cy = 0;
    end;

    weight = area / area_sum;

    cx = cx + (x * weight);
    cy = cy + (y * weight);

    if %IS_LAST_OBS_IN_AREA then do;
      x = cx;
      y = cy;
      output;
    end;
  run;

%DONE:
  /*
   * Delete temporary datasets and views.
   */
  proc datasets;
    delete __centroid_tmp_1
           __centroid_tmp_2
           __centroid_tmp_3
           __centroid_tmp_4
           __centroid_tmp_5
           __centroid_tmp_6;
  run;
%mend;

%macro CIRCLE(x, y, size, color);
  function = "pie";
  x        = &x;
  y        = &y;
  angle    = 0;
  rotate   = 360;
  style    = "pe";
  size     = &size;
  line     = 0;
  color    = "&color";
  output;
%mend CIRCLE;

%macro CNTL2TXT;
  function = "cntl2txt";
  output;
%mend CNTL2TXT;

%macro COMMENT(textString);
  function = "comment";
  text     = &textString;
  output;
%mend COMMENT;

%macro DCLANNO;
length
  cborder cbox color style $ 64
  function $ 8
  hsys position when xsys ysys zsys $ 1
  imgpath $ 255;
%mend DCLANNO;

%macro DRAW(x, y, color, line, size);
  function = "draw";
  x        = &x;
  y        = &y;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;
%mend DRAW;

%macro DRAW2TXT(color, line, size);
  function = "draw2txt";
  color    = "&color";
  line     = &line;
  size     = &size;
  output;
%mend DRAW2TXT;

%macro FRAME(color, line, size, style);
  function = "frame";
  color    = "&color";
  line     = &line;
  size     = &size;
  style    = "&style";
  output;
%mend FRAME;

%macro LABEL(x, y, text, color, angle, rot, size, style, pos);
  function = "label";
  x        = &x;
  y        = &y;
  text     = &text; 
  color    = "&color";
  angle    = &angle;
  rotate   = &rot;
  size     = &size;
  style    = "&style";
  position = "&pos";
  output;
%mend LABEL;

%macro LINE(x1, y1, x2, y2, color, line, size);
  function = "move";
  x        = &x1;
  y        = &y1;
  output;

  function = "draw";
  x        = &x2;
  y        = &y2;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;
%mend LINE;

%macro MAPLABEL (map_dataset,
                 attr_dataset,
                 output_dataset,
                 label_var,
                 id_vars,
                 font=,
                 color=,
                 size=2,
                 hsys=3);
  %local i
         id
         id_count
         needle
         haystack;

  %macro DATASET_HAS_VAR(dataset, variable);
    %local dataset_id rc;
    %let dataset_id = %sysfunc(open(&dataset));
    %if (&dataset_id) %then %do;
      %if %sysfunc(varnum(&dataset_id, &variable)) %then 1;
      %else 0;
      %let rc = %sysfunc(close(&dataset_id));
    %end;
    %else 0;
  %mend;

  /* Count number of ID variables. */
  %let id_count = %sysfunc(countw(&id_vars));

  /* Check that input_dataset exists. */
  %if %sysfunc(exist(&map_dataset)) = 0 %then %do;
    %put ERROR: MAPLABEL: %upcase(&map_dataset) does not exist.;
    %return;
  %end;

 /* Check ID variables are defined in map_dataset. */
  %do i = 1 %to &id_count;
    %let id = %sysfunc(scan(&id_vars., &i, " "));
    %if %DATASET_HAS_VAR(&map_dataset, &id) = 0 %then %do;
      %let needle = %upcase(&id);
      %let haystack = %upcase(&map_dataset);
      %put ERROR: MAPLABEL: &needle does not exist in &haystack.;
      %return;
    %end;
  %end;

  /* Check ID variables are defined in attr_dataset. */
  %do i = 1 %to &id_count;
    %local id;
    %let id = %sysfunc(scan(&id_vars., &i, " "));
    %if %DATASET_HAS_VAR(&attr_dataset, &id) = 0 %then %do;
      %let needle = %upcase(&id);
      %let haystack = %upcase(&map_dataset);
      %put ERROR: MAPLABEL: &needle does not exist in &haystack.;
      %return;
    %end;
  %end;

  /* Check that attr_dataset exists. */
  %if %sysfunc(exist(&attr_dataset)) = 0 %then %do;
    %put ERROR: MAPLABEL: %upcase(&attr_dataset) does not exist.;
    %return;
  %end;

  /* Check that label_var is defined in attr_dataset. */
  %if %DATASET_HAS_VAR(&attr_dataset, &label_var) = 0 %then %do;
    %let needle = %upcase(&label_var);
    %let haystack = %upcase(&attr_dataset);
    %put ERROR: MAPLABEL: &needle does not exist in &haystack.;
    %return;
  %end;

  /*
   * STEP 1: Generate centroid dataset.
   */
  %CENTROID(&map_dataset, __maplabel_tmp_1, &id_vars);

  %if %sysfunc(exist(__maplabel_tmp_1)) = 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 2: Sort attribute dataset by ID variables.
   */
  proc sort data=&attr_dataset out=__maplabel_tmp_2;
    by &id_vars;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 3: Merge centroid and (sorted) attribute datasets.
   */
  data __maplabel_tmp_3 / view=__maplabel_tmp_3;
    merge __maplabel_tmp_1 (in=in_centroid)
          __maplabel_tmp_2 (in=in_attr keep=&id_vars &label_var);
    by &id_vars;
    if in_centroid and in_attr;
  run;

  %if &syserr > 0 %then %do;
    %goto DONE;
  %end;

  /*
   * STEP 4: Generate annotate dataset.
   */
  data &output_dataset;
    set __maplabel_tmp_3 (drop=&id_vars);

    function = "label";
    position = "5";
    when     = "A";
    xsys     = "2";
    ysys     = "2";
    size     = &size;
    text     = &label_var;
    hsys     = %sysfunc(quote(%sysfunc(dequote(&hsys))));

    %if %quote(&color) ^= %str() %then %do;
      color = %sysfunc(quote(%sysfunc(dequote(&color))));
    %end;

    %if %quote(&font) ^= %str() %then %do;
      style = %sysfunc(quote(%sysfunc(dequote(&font))));
    %end;
  run;

%DONE:
  /*
   * Delete temporary datasets and views.
   */
  proc datasets;
    delete __maplabel_tmp_1
           __maplabel_tmp_2
           __maplabel_tmp_3;
	run;
%mend;

%macro MOVE(x,y);
  function = "move";
  x        = &x;
  y        = &y;
  output;
%mend MOVE;

%macro PIECNTR(x, y, size);
  function = "piecntr";
  x        = &x;
  y        = &y;
  size     = &size;
  output;
%mend PIECNTR;

%macro PIEXY(angle, size);
  function = "piexy";
  angle    = &angle;
  size     = &size;
  output;
%mend PIEXY;

%macro POINT(x, y, color);
  function = "point";
  x        = &x;
  y        = &y;
  color    = "&color";
  output;
%mend POINT;

%macro POLY(x, y, color, style, line);
  function = "poly";
  x        = &x;
  y        = &y;
  color    = "&color";
  style    = "&style";
  line     = &line;
  output;
%mend POLY;

%macro POLY2(x, y, color, style, line, width);
  function = "poly";
  x        = &x;
  y        = &y;
  color    = "&color";
  style    = "&style";
  line     = &line;
  size     = &width;
  output;
%mend POLY2;

%macro POLYCONT(x, y, color);
  function = "polycont";
  x        = &x;
  y        = &y;
  color    = "&color";
  output;
%mend POLYCONT;

%macro POP;
  function = "pop";
  output;
%mend POP;

%macro PUSH;
  function = "push";
  output;
%mend PUSH;

%macro RECT(x1, y1, x2, y2, color, line, size);
  function = "move";
  x        = &x1;
  y        = &y1;
  output;

  function = "draw";
  x        = &x2;
  y        = &y1;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;

  function = "draw";
  x        = &x2;
  y        = &y2;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;

  function = "draw";
  x        = &x1;
  y        = &y2;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;

  function = "draw";
  x        = &x1;
  y        = &y1;
  color    = "&color";
  line     = &line;
  size     = &size;
  output;
%mend RECT;

%macro SCALE(ptx, pty, x1, y1, x2, y2, vx1, vy1, vx2, vy2);
  %if &x2 eq &x1 %then
    %let xscale = 1;
  %else
    %let xscale = %sysevalf((&vx2 - &vx1)/(&x2 - &x1));

  %if &y2 eq &y1 %then
    %let yscale = 1;
  %else
    %let yscale = %sysevalf((&vy2 - &vy1)/(&y2 - &y1));

  %let x = %sysevalf(&xscale*&ptx);
  %let y = %sysevalf(&yscale*&pty);
%mend SCALE;

%macro SCALET(ptx, pty, x1, y1, x2, y2, vx1, vy1, vx2, vy2);
  %if &x2 eq &x1 %then
    %let xscale = 1;
  %else
    %let xscale = %sysevalf((&vx2 - &vx1)/(&x2 - &x1));

  %if &y2 eq &y1 %then
    %let yscale = 1; 
  %else
    %let yscale = %sysevalf((&vy2 - &vy1)/(&y2 - &y1));

  %let x = %sysevalf(&vx1 + %sysevalf(&xscale*&ptx));
  %let y = %sysevalf(&vy1 + %sysevalf(&yscale*&pty));
%mend SCALET;

%macro SEQUENCE(when);
  when="&when";
%mend SEQUENCE;

%macro SLICE(x, y, angle, rotate, size, color, style, line);
  function = "pie";
  x        = &x;
  y        = &y;
  angle    = &angle;
  rotate   = &rotate;
  style    = "&style";
  size     = &size;
  line     = &line;
  color    = "&color";
  output;
%mend SLICE;

%macro SWAP;
  function = "swap";
  output;
%mend SWAP;

%macro SYMBOL(x, y, text, cborder, color, size, style);
  function = "symbol";
  x        = &x;
  y        = &y;
  text     = &text;
  cborder  = &cborder;
  color    = "&color";
  size     = &size;
  style    = "&style";
  output;
%mend SYMBOL;

%macro SYMBOL(x, y, text, cborder, color, size, style);
  function = "symbol";
  x        = &x;
  y        = &y;
  text     = &text;
  cborder  = &cborder;
  color    = "&color";
  size     = &size;
  style    = "&style";
  output;
%mend SYMBOL;

%macro SYSTEM(xsys, ysys, hsys);
  xsys = "&xsys";
  ysys = "&ysys";
  hsys = "&hsys";
%mend SYSTEM;

%macro TXT2CNTL;
  function="txt2cntl";
  output;
%mend TXT2CNTL;
