/* 12112627 李乐平 */

/* Assignment 1 Question 4 */
data assignment_1_4;
infile "~/my_shared_file_links/u44964922/Assignments/NationalPark.txt";
input 
    @1 ParkName $ 14. 
    @15 State $ 8. 
    @25 EstablishDate mmddyy10. 
    @37 Acerage comma9.;
run;


/* Assignment 1 Question 5 */
proc contents data="~/my_shared_file_links/u44964922/Assignments/sff.sas7bdat" out=contents_data noprint;
run;

/* Question 5.1 */
proc print data=contents_data;
    var varnum name type length label;
run;

proc freq data="~/my_shared_file_links/u44964922/Assignments/sff.sas7bdat";
    tables Continent / out=continent_counts(keep=Continent count);
run;

/* Question 5.2 */
data sff;
    set "~/my_shared_file_links/u44964922/Assignments/sff.sas7bdat";
run;

data sff;
    set sff;
    length Status $ 20;
    if FirstCase > intnx("day", "30APR2009"d, 0) then Status = "No Cases";
    else if FirstCase > 0 then Status = "At Least One Case";
    else Status = "Unknown";
run;

proc freq data=sff;
    tables Continent * Status / nocum nocol norow nopercent;
    title "Number of Countries per Continent by Case Status in April";
run;

/* Question 5.3 */
data sff;
    set "~/my_shared_file_links/u44964922/Assignments/sff.sas7bdat";
run;

data potential_errors;
    set sff;
    format FirstCase FirstDeath date9.;

    if FirstDeath ne . and FirstCase eq . then 
        output;
run;

proc sort data=potential_errors;
    by Continent Country;
run;

proc print data=potential_errors;
    title "Countries Reporting First Death Date but No First Case Date";
    var Continent Country FirstCase Latest FirstDeath;
run;

/* Assignment 1 Question 6 */

libname assign1 "~/my_shared_file_links/u44964922/Assignments";

data visits;
    set assign1.visits;
run;

data txgroup;
    set assign1.txgroup;
run;

/* Question 6.1 */
proc sql;
    title "Duplicate Record in Table Visits";
    select 
        ID, count(*) as count
    from 
        assign1.visits
    group by
        ID
    having
        count > 1;
run;

proc sql;
    title "Duplicate Record in Table TXGroup";
    select 
        ID, count(*) as count
    from 
        assign1.txgroup
    group by
        ID
    having
        count > 1;
run;

/* Question 6.2 */
proc sort data=visits out=visits_nodup nodupkey;
    by ID;
run;

proc sort data=txgroup out=txgroup_nodup nodupkey;
    by ID;
run;

data mg62;
    merge visits_nodup txgroup_nodup;
    by ID;
run;

/* A SQL Version Answer to Question 6.2 */
/* proc sql; */
/* create table mg62 as */
/*     select distinct */
/*         visits.ID, VisitDt, Gender, Visit, B_Cholesterol, TX */
/*     from  */
/*         visits */
/*     inner join  */
/*         txgroup */
/*     on  */
/*         visits.ID = txgroup.ID */
/*     order by */
/*         visits.ID; */
/* quit; */

/* Question 6.3 */

proc sql noprint;
create table mg62_with_Abovemedian as
    select mg62.*,
        case when B_Cholesterol <= MedianValues.Median_B_Cholesterol then 0
            else 1
            end as Abovemedian
    from mg62
    left join (
        select 
            TX,
            median(B_Cholesterol) as Median_B_Cholesterol
        from 
            mg62
        group by 
            TX
    ) as MedianValues
    on 
        mg62.TX = MedianValues.TX
    order by 
        mg62.ID;
quit;

/* Assignment 1 Question 7 */

/* Question 7.1 */

data heart;
    set SASHELP.Heart;
run;

proc tabulate data=SASHelp.Heart;
    class DeathCause Smoking_Status Sex;
    var AgeAtDeath;
    where DeathCause in ("Cancer", "Cerebral Vascular Disease", "Coronary Heart Disease");
    table
        DeathCause * Smoking_Status, 
        (Sex all) * AgeAtDeath * (N Mean Median);
run;

/* Question 7.2 */

proc sgplot data=SASHelp.Heart;
    histogram AgeCHDdiag / group=Chol_Status transparency=0.5;
    density AgeCHDdiag / group=Chol_Status type=kernel;
    where Sex="Female" and Chol_Status in ("High", "Desirable");
    title "Age at CHD Diagnosed by Cholesterol Status for Female";
run;

/* Question 7.3 */

%macro draw_plot(my_var);
    %let td = %sysfunc(today());
    %let wd = %sysfunc(weekday(&td));
    %let wd_name = %sysfunc(putn(&td, downame.)); 
    %put Today is &wd_name.;
    %if (&wd = 2 or &wd = 4) %then %do;
        proc sgplot data=SASHelp.Heart;
            histogram AgeAtDeath / group=&my_var transparency=0.5;
            title "Histogram of Age at Death by &my_var";
        run;
    %end;
    %else %if (&wd = 3 or &wd = 5) %then %do;
        proc sgplot data=SASHelp.Heart;
            vbar AgeAtDeath / group=&my_var groupdisplay=cluster;
            title "Barplot of Age at Death by &my_var";
        run;
    %end;
%mend;

%draw_plot(Sex);







