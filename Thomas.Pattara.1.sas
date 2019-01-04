/**
 /brief Getting Started
 /author Thomas Pattara
 /date 05/31/2018
 
Instructions
============

This document runs a simple analysis of the Table 1 from Wansink, 
Brian, and Collin Payne. 2009. “The Joy of Cooking Too Much: 70 
Years of Calorie Increases in Classic Recipes” 150 (150): 291–92.
Edit the header information to show your name and the date you 
complete the assignment.

Modify this document to analyze either Calories per Serving or 
Servings per Recipe. Document any changes you make in code comments. 
Comment on your choice of measure to analyze.

Change the name of this file to match your user name on D2L, 
keeping the 'SAS' extension, and include week number in the title 
(for example, `Peter.Claussen.1.sas`). Upload this file to D2L. 

Download the log, rename as above (keeping the html extentions)
and upload to D2L.  Download the results as RTF and add your own 
comments.  Upload the edit file to D2L as well.

## Data
                 Measure  | 1936            |            1946 |            1951 |            1963 |            1975 |            1997 |            2006 
calories per recipe (SD)  | 2123.8 (1050.0) | 2122.3 (1002.3) | 2089.9 (1009.6) | 2250.0 (1078.6) | 2234.2 (1089.2) | 2249.6 (1094.8) | 3051.9 (1496.2)
calories per serving (SD) |   268.1 (124.8) |   271.1 (124.2) |   280.9 (116.2) |   294.7 (117.7) |   285.6 (118.3) |   288.6 (122.0) |   384.4 (168.3)
servings per recipe (SD)  |     12.9 (13.3) |     12.9 (13.3) |     13.0 (14.5) |     12.7 (14.6) |     12.4 (14.3) |     12.4 (14.3) |     12.7 (13.0)
Table: Mean and (SD) for selected recipes from "Joy of Cooking"
*/

title 'Enter Data';
/*
Data from Table 1.
*/
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

title 'Create values for confidence interval plot.';

/*
 Wansink reports that 18 recipes were analyzed.
*/
%let n = 18;

/*
 Assume a significance level $\alpha$ of 5%.
*/
%let alpha = 0.05;

/*
 Use standard formula for standard error $\sigma / \sqrt{n}$ and 
 confidence interval $t_{\alpha/2} \times s.e.$.
 */
%macro StandardError(sigma, n);
  &sigma/sqrt(&n);
%mend;

%macro ConfidenceInterval(sigma, n);
  quantile('T',1-&alpha/2,9999)*%StandardError(&sigma,&n);
%mend;

/*
 Create a temporary table for plotting and calculate upper and lower bounds using confidence intervals.
 */
data PlotCookingTooMuch;
  set CookingTooMuch;
  CaloriesPerServing = CaloriesPerServingMean;
  Lower = CaloriesPerServing-%ConfidenceInterval(CaloriesPerServingSD,&n);
  Upper = CaloriesPerServing+%ConfidenceInterval(CaloriesPerServingSD,&n);
  keep Year CaloriesPerServing Lower Upper;
run;

/*
Examine the values to make sure we've entered correctly.
*/
proc print data=PlotCookingTooMuch;
run;

/*
 We no longer need the original data.
*/
proc delete data=CookingTooMuch;
run;

title 'Check our values';
/*
 Wansink reports 95% confidence intervals for the 1936 and 2006 means as 
 [1638.7, 2608.9] and [2360.7, 3743.1], respectively. We should be equal, 
 to within rounding error.
*/
proc iml;
  use PlotCookingTooMuch;
  read point {1 7} var {Lower Upper} into CompValues;
  ReferenceValues = {1638.7 2608.9, 2360.7 3743.1};
  print(CompValues);
  print(ReferenceValues);
  print(any(abs(CompValues-ReferenceValues)>0.1));
quit;

title 'Plot the table';

proc sgplot data=PlotCookingTooMuch noautolegend;                                                                                                  
   scatter x=Year y=CaloriesPerServing / yerrorlower=Lower                                                                                            
                           yerrorupper=Upper                                                                                            
                           markerattrs=(color=blue symbol=CircleFilled);                                                                
   series x=Year y=CaloriesPerServing / lineattrs=(color=blue pattern=2); 
   yaxis label= "Calories";
   title1 'Calories per Serving';                                                                   
run;

/*
From this plot, it appears that average calories per serving changed 
little from 1936 to 1963, then stagnated upto 1997, then a sudden 
increse between 1997 to 2006. This suggests that the signficant 
increase from 1997 to 2006 reported by Wansink is due to an increase 
in the 1997 serving only. Thus, we only need to compare 1997 and 
2006 serving sets.
 */