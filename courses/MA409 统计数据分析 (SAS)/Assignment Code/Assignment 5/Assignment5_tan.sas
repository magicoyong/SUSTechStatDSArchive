

* Question 2;

PROC IMPORT 
	DATAFILE = "~/sasuser.v94/HRdata.csv"
	OUT = hrdata
	DBMS = CSV
	REPLACE;
RUN;

* (a);
/* Exploring differences using histograms with different colors for 'left' */

/* Satisfaction Level by Leave */
proc sgplot data=hrdata;
    histogram satisfaction_level / group=left transparency=0.5;
    keylegend / title="Left";
    title "Satisfaction Level by Leave";
run;

/* Latest Evaluation by Leave */
proc sgplot data=hrdata;
    histogram last_evaluation / group=left transparency=0.5;
    keylegend / title="Left";
    title "Latest Evaluation by Leave";
run;

/* Number of Projects by Leave */
proc sgplot data=hrdata;
    histogram number_project / group=left transparency=0.5;
    keylegend / title="Left";
    title "Number of Projects by Leave";
run;

/* Average Monthly Hours by Leave */
proc sgplot data=hrdata;
    histogram average_monthly_hours / group=left transparency=0.5;
    keylegend / title="Left";
    title "Average Monthly Hours by Leave";
run;

/* Time Spent in Company by Leave */
proc sgplot data=hrdata;
    histogram time_spent_company / group=left transparency=0.5;
    keylegend / title="Left";
    title "Time Spent in Company by Leave";
run;

/* Work Accident by Leave */
proc sgplot data=hrdata;
    histogram work_accident / group=left transparency=0.5;
    keylegend / title="Left";
    title "Work Accident by Leave";
run;

/* Promotion in Last 5 Years by Leave */
proc sgplot data=hrdata;
    histogram promotion_last_5years / group=left transparency=0.5;
    keylegend / title="Left";
    title "Promotion in Last 5 Years by Leave";
run;

/* Salary Level by Leave */
proc sgplot data=hrdata;
    histogram salary / group=left transparency=0.5;
    keylegend / title="Left";
    title "Salary Level by Leave";
run;


* (b);
/* Logistic Regression Model */
proc logistic data=hrdata;
	
    class work_accident (param=ref ref='0') 
          promotion_last_5years (param=ref ref='0') 
          salary (param=ref ref='low');
    model left(event='1') = satisfaction_level last_evaluation number_project
                            average_monthly_hours time_spent_company
                            work_accident promotion_last_5years
                            salary;
    *output out=pred p=prob;
run;

/* ROC Curve and AUC */
proc logistic data=hrdata plots(only)=(roc);
    class work_accident (param=ref ref='0') 
          promotion_last_5years (param=ref ref='0') 
          salary (param=ref ref='low');
    model left(event='1') = satisfaction_level last_evaluation number_project
                            average_monthly_hours time_spent_company
                            work_accident promotion_last_5years
                            salary;
    roc;
run;



* (c);

data new;
set hrdata;
if satisfaction_level <= 0.1 THEN satisfaction_level_new = "too low";
else if satisfaction_level > 0.1  and  satisfaction_level < 0.48 THEN satisfaction_level_new = "low";
else if satisfaction_level >= 0.48  and  satisfaction_level <= 0.7 THEN satisfaction_level_new = "median";
else if satisfaction_level > 0.7 THEN satisfaction_level_new = "high";


if last_evaluation < 0.46 THEN last_evaluation_new = "too low";
else if last_evaluation >= 0.46  and  last_evaluation < 0.6 THEN last_evaluation_new = "low";
else if last_evaluation >= 0.6  and  last_evaluation <= 0.78 THEN last_evaluation_new = "median";
else if last_evaluation > 0.78 THEN last_evaluation_new = "high";

if time_spent_company <= 2 THEN time_spent_company_new = "low";
else if time_spent_company >= 3 and  time_spent_company <= 6 THEN time_spent_company_new = "medium";
else if time_spent_company >=7 THEN time_spent_company_new = "high";

if average_monthly_hours < 165 THEN average_monthly_hours_new = "low";
else if average_monthly_hours >= 165 and average_monthly_hours <= 218 THEN average_monthly_hours_new = "medium";
else if average_monthly_hours > 218 and average_monthly_hours <= 280 THEN average_monthly_hours_new = "high";
else if average_monthly_hours > 280  THEN average_monthly_hours_new = "extreme";
run;


proc logistic data=new plots(only)=(roc);
    class work_accident (param=ref ref='0') 
          promotion_last_5years (param=ref ref='0') 
          salary (param=ref ref='low')
          satisfaction_level_new (param=ref ref='low')
          last_evaluation_new (param=ref ref='too low')
          time_spent_company_new (param=ref ref='low')
          average_monthly_hours_new (param=ref ref='low');
    model left(event='1') = satisfaction_level_new last_evaluation_new number_project
                            average_monthly_hours_new time_spent_company_new
                            work_accident promotion_last_5years
                            salary;
    roc;
run;




* Question 3;

* (a);
PROC IMPORT 
	DATAFILE = "~/sasuser.v94/car.xlsx"
	OUT = car
	DBMS = XLSX
	REPLACE;
RUN;

data car;
set car;
ln = log(n);
run;

* (b);

PROC GENMOD DATA = car;
	CLASS CAR (REF = '1') AGE (REF = '1') LONDON (REF = '0')/ PARAM = ref;
	MODEL y = car age london / DIST = POISSON LINK = LOG offset=ln TYPE1 TYPE3;
RUN;


* (c);
PROC GENMOD DATA = car;
	CLASS CAR (REF = '1') AGE (REF = '1') LONDON (REF = '0')/ PARAM = ref;
	MODEL y = car age london / DIST = NEGBIN offset=ln TYPE3;
RUN;


* Question 4;

* (b);
PROC IMPORT 
	DATAFILE = "~/sasuser.v94/disease.xlsx"
	OUT = disease
	DBMS = XLSX
	REPLACE;
RUN;

* (c);
PROC LOGISTIC DATA = disease ORDER = DATA;
	FREQ count;
	CLASS Air_pollution Job_exposure Smoking_status / PARAM = REF;
	MODEL level = Air_pollution Job_exposure Smoking_status / SCALE = NONE AGGREGATE;
RUN;

/* Plot the predicted probabilities by subgroups */
PROC LOGISTIC DATA = disease ORDER = DATA PLOTS = EFFECT(POLYBAR x = Air_pollution* Job_exposure* Smoking_status);
	FREQ count;
	CLASS Air_pollution Job_exposure Smoking_status / PARAM = REF;
	MODEL level = Air_pollution Job_exposure Smoking_status / SCALE = NONE AGGREGATE;
RUN;



