*
 * Author: Thomas Pattara
 * Date  : 06/08/2018
 */

proc iml;

  /* Calories per Serving */
 m1 = 268.1; /* Mean in the year 1936 */
 m2 = 384.4; /* Mean in the year 2006 */
 s1 = 124.8; /* Standard Deviation in the year 1936 */
 s2 = 168.3; /* Standard Deviation in the year 2006 */

 d12 = (abs(m1-m2))/(sqrt((s1**2 + s2**2)/2));
 print(d12);
 
/*Serving per Recipe*/

   s1 = 13.3;  /* Standard Deviation in the year 1936 */
   s2 = 13.0;  /* Standard Deviation in the year 2006 */
   m1 = 12.9;  /* Mean in the year 1936 */
   m2 = 12.7;  /* Mean in the year 2006 */
   d12 = (abs(m1-m2))/sqrt((s1**2 + s2**2)/2); 
   print(d12); 
   
   /*Calories per Recipe*/
  
  s1 = 1050.0; /* Standard Deviation of of 1936 */ 
  s2 = 1496.2; /* Standard Deviation of 2006 */
  m1 = 2123.8; /* Mean of of 1936 */
  m2 = 3051.9; /* Mean of of 2006 */
  d12 = (abs(m1-m2))/sqrt((s1**2 + s2**2)/2);
  print(d12);


  /* Exercise 1 unit test, IML code */
  if(abs(d12-0.7181)<0.0001) then
    do;
      local_unit_test_points = &unit_test_points + 8;
      print(local_unit_test_points);
      call symput("unit_test_points", char(local_unit_test_points));
    end;
   else
    do;
      print 'd_12 is not assigned the correct value';
    end;
    
quit;

