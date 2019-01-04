
/*
 /brief 8 Processing text Homework
 /author Thomas Pattara
 /date July 20, 2018.


/* options macrogen symbolgen mprint mlogic; */

/*
 * General Instructions.
 * There are not unit tests for this exercise. This file defines the data
 * you will need for this homework, except where you will be importing data.
 * 
 * You can delete the data for exercises you do not attempt in SAS.
 */







title 'Exercise 5';
/* Optional - see R Markdown  */

proc iml;      
%web_drop_table(zeroTo60);                             
filename zeroto60 "/home/thomaspattara0/sasuser.v94/SELFINTRO/zero.to.60.csv";


/* to import a data file*/

proc import datafile=zeroto60   
  dbms=csv                       
  out= zeroTo60;
  getnames=yes;
run;

data WORK.ZEROTO60    ;
            %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
            infile ZEROTO60 delimiter = ',' MISSOVER DSD  firstobs=2 ;
               informat Make_and_model $21. ;
               informat Year best32. ;
               informat Time best32. ;
               format Make_and_model $21. ;
               format Year best12. ;
               format Time best12. ;
            input
                        Make_and_model  $
                        Year
                        Time
            ;
            if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
            run;



/* using proc sql */
proc sql ;
/* Part-a  */
/* To list BMW motorcycles only */
create table bmw as
select * from zeroTo60 where Make_and_model contains 'BMW';


/* Part-b */
/* To list only Ninja models  */
create table ninja as
select * from zeroTo60 where Make_and_model contains 'Ninja';

/* Part-c */
/*  motorcycle model names ending with 'R' */
create table endingR as select Make_and_Model from zeroTo60 where Make_and_model like '%R';

/* Part-d */
/* less than 1000 cc motorcycles*/

create table cc as select * from zeroTo60 where Make_and_model not like '%1%';

create table CC as select Make_and_model from cc where Make_and_model like '%2%' or  Make_and_model like '%3%' or
Make_and_model like '%4%' or Make_and_model like '%5%' or Make_and_model like '%6%' or 
Make_and_model like '%7%' or Make_and_model like '%8%' or Make_and_model like '%9%' ;


quit;

/* to display the tables created */

proc report data= bmw;
run;
proc report data= ninja;
run;
proc report data = endingR;
run;

proc report data = CC;
run;