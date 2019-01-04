/**
 /7 Data Manipulation
 /author Thomas Pattara
 /date 07/14/2018
 

/* options macrogen symbolgen mprint mlogic; */

/*
 * General Instructions.
 * There are not unit tests for this exercise. This file defines the data
 * you will need for this homework.
 * 
 * You can delete the data for exercises you do not attempt in SAS.
 */

%macro Homework4Data;
  Year = {1936 1946 1951 1963 1975 1997 2006};
  CaloriesPerRecipeMean = {2123.8 2122.3 2089.9 2250.0 2234.2 2249.6 3051.9};
  CaloriesPerRecipeSD = {1050.0 1002.3 1009.6 1078.6 1089.2 1094.8 1496.2};
  CaloriesPerServingMean = {268.1 271.1 280.9 294.7 285.6 288.6 384.4};

  CaloriesPerServingSD = {124.8 124.2 116.2 117.7 118.3 122.0 168.3};
  ServingsPerRecipeMean = {12.9 12.9 13.0 12.7 12.4 12.4 12.7};
  ServingsPerRecipeSD = {13.3 13.3 14.5 14.6 14.3 14.3 13.0};
  sample_size = 18;
  tenth_increment = 0.10;
  idx_1936 = 1;
  idx_2006 = dimension(CaloriesPerRecipeMean)[2];
  idxs36_07 = {idx_1936, idx_2006};
  alpha=0.05;
    
%mend;
%macro Homework4DataTable;  
  data CookingTooMuch;
    input Year CaloriesPerRecipeMean CaloriesPerRecipeSD CaloriesPerServingMean CaloriesPerServingSD ServingsPerRecipeMean ServingsPerRecipeSD;
    datalines;
    1936 2123.8 1050.0 268.1 124.8 12.9 13.3
    1946 2122.3 1002.3 271.1 124.2 12.9 13.3
    1951 2089.9 1009.6 280.9 116.2 13.0 14.5
    1963 2250.0 1078.6 294.7 117.7 12.7 14.6
    1975 2234.2 1089.2 285.6 118.3 12.4 14.3
    1997 2249.6 1094.8 288.6 122.0 12.4 14.3
    2006 3051.9 1496.2 384.4 168.3 12.7 13.0
  run;
%mend;


title 'Exercise 3';
/* Optional - see R Markdown  */
data NATR332;
  input Y1 Y2;
  datalines;
  146 141
  141 143
  135 139
  142 139
  140 140
  143 141
  138 138
  137 140
  142 142
  136 138
 
  
run;

proc iml;
%Homework4Data
use NATR332;
/*read all var _all_;
/*close NATR332;
show names;
*/
read all var {Y1 Y2};
Diff = Y2 - Y1;  /*difference of the values*/
set = 0; 
Difference = remove(Diff, loc(Diff = set));
Rank = rank(ABS(Difference));  /* rank gets the absolute value of difference*/
  SignedRank = {};
 do i = idx_1936 to idx_2006;
 if Difference[i] < 0 then 
 SignedRank =SignedRank || -Rank[i]; /*negative rank*/
 else 
 SignedRank = SignedRank || Rank[i]; /*positive rank*/
 end;
 
 
 pr = 0;
 nr = 0;
 do i = idx_1936 to idx_2006;
 if SignedRank[i] < 0 then
 nr = nr + ABS(SignedRank[i]); /*negative rank*/
 else
 pr = pr + ABS(SignedRank[i]); /*positive rank*/
 end;

 W = min(nr,pr); 
 print(W);
 N_r = idx_2006;
 sigma_W= sqrt(N_r * (N_r + 1) * (2*N_r + 1)/24);
mu_W = (N_r*(N_r + 1))/4;
z = (mu_W - W)/sigma_W; /* z score*/
print(z); 
p = probnorm(z);  /*p-Value */

print(p);
 
 create datatable var {Difference, Rank, SignedRank}; /*creating table*/
append;
close;
quit;

proc print data=datatable;
run;



