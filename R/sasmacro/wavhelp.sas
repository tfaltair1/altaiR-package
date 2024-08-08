%MACRO wavhelp(name);
%if %length(&name) = 0 %then %do;
  print "supported macro:";
  print "wavinit";
%end;
%else %if &name = wavinit %then %do;
  print "Macro variables defined in the autocall WAVINIT macro";
    
  label1 = {"Macro Variables for Wavelet Specification"};    
  contents1 = {
"       Position                  Admissible Values         ",
"Name            Value    Name                         Value",
'"&boundary"       1      "&zeroExtension"                 0',
'                         "&periodic"                      1',
'                         "&polynomial"                    2',
'                         "&reflection"                    3',
'                         "&antisymmetricReflection"       4',
'"&degree"         2      "&constant"                      0',
'                         "&linear"                        1',
'                         "&quadratic"                     2',
'"&family"         3      "&daubechies"                    1',
'                         "&symmlet"                       2',
'"&member"         4                  1-10                  '};
  print contents1 [label = label1];


  label2 = {"Macro Variables for Threshold Specification"};
  contents2 = {
"       Position                   Admissible Values         ", 
"Name            Value     Name                         Value",
'"&policy"         1       "&none"                          0',
'                          "&hard"                          1',
'                          "&soft"                          2',
'                          "&garrote"                       3',
'"&method"         2       "&absolute"                      0',
'                          "&minimax"                       1',
'                          "&universal"                     2',
'                          "&sure"                          3',
'                          "&sureHybrid"                    4',
'                          "&nhoodCoeffs"                   5',
'"&value"          3                             positive real',
'"&levels"         4       "&all"                           -1',
'                                              positive integer'};
  print contents2 [label = label2];

  label3 = {"Symbolic Names for the Third Argument of WAVGET"};
  contents3 = {
"Name                  Value",
'"&numPoints"              1',
'"&detailCoeffs"           2',
'"&scalingCoeffs"          3',
'"&thresholdingStatus"     4',
'"&specification"          5',
'"&topLevel"               6',
'"&startLevel"             7',
'"&fatherWavelet"          8'};
  print contents3 [label = label3];

  label4 = {"Macro Variables for the Second Argument of WAVPRINT"};
  contents4 = {
"Name                    Value",
'"&summary"                  1',
'"&detailCoeffs"             2',
'"&scalingCoeffs"            3',
'"&thresholdedDetailCoeffs"  4'};
  print contents4 [label = label4];
        
  label5 = {"Macro Variables for Predefined Wavelet Specifications "};
  contents5 = {
'Name             
"&boundary"   "&degree"    "&family"    "&member"     ',
'"&waveSpec"    
{      .            .            .            .       } ',
'"&haar"        
{ "&periodic"       .        "&daubechies"    1       } ',
'"&daubechies3" 
{ "&periodic"       .        "&daubechies"    3       } ',
'"&daubechies5" 
{ "&periodic"       .        "&daubechies"    5       } ',
'"&symmlet5"    
{ "&periodic"       .        "&symmlet"       5       } ',
'"&symmlet8"    
{ "&periodic"       .        "&symmlet"       8       } '};
  print contents5 [label = label5];

  label6 = 
  {"Macro Variables for Predefined Threshold Specifications"};
  contents6 = {
'Name             
"&policy"     "&method"     "&value"    "&levels"      ',
'"&threshSpec"  
{     .              .            .            .      }  ',
'"&RiskShrink"  
{   &hard        &minimax         .          &all     }  ',
'"&VisuShrink"  
{   &soft        &universal       .          &all     }  ',
'"&SureShrink"  
{   &soft        &sureHybrid      .          &all     }  '};
  print contents6 [label = label6];
        
%end;
%else %do;
  print "The module &name is not supported.";
%end;
%MEND;
