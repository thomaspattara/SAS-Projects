/*
 /Brief Control Structures
 /Author: Thomas Pattara
 /Date: 07/08/2018
 */
/* options macrogen symbolgen mprint mlogic; */

/*
 * General Instructions.
 * There are not unit tests for this exercise. This file defines the data
 * you will need for this homework.
 * 
 * 
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
  hundredth_increment = 0.100;
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

title 'Exercise 1';

proc iml;
%Homework4Data;
k = idx_2006;
Mean_1 = {};
Mean_2 = {};
SD_1 = {}; 
SD_2 = {};
Year_1 = {};
Year_2 = {};
CohenD = {};
start CohenD(Mean_1,Mean_2,SD_1,SD_2);   /* Function for Cohen's D*/         
Cohen_D=(ABS(Mean_1-Mean_2)/sqrt((SD_1**2 + SD_2**2)/2));   /* Cohen's D is calculated */
return(Cohen_D);      /* Returns calculated value */                               
finish CohenD;        /* end of function */                             
do i = 1 to (k-1);    /* nested loop */
do j = i+1 to k;
Year_1 = Year_1 || Year[j]; 
Year_2 = Year_2 || Year[i];
Mean_1 = Mean_1 || CaloriesPerRecipeMean[j];
Mean_2 = Mean_2 || CaloriesPerRecipeSD[i];
SD_1 = SD_1 || CaloriesPerRecipeSD[j];
SD_2 = SD_2 || CaloriesPerRecipeSD[i];
CohenD = CohenD || CohenD(CaloriesPerRecipeMean[j],CaloriesPerRecipeMean[i],CaloriesPerRecipeSD[j],CaloriesPerRecipeSD[i]);
end;
end;
create datatable var {Year_1,Year_2,Mean_1,Mean_2, SD_1,SD_2, CohenD}; 
append; 
close;
quit;
proc print data=datatable;
run;

