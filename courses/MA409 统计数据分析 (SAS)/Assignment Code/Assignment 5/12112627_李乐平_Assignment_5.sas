/* 12112627 李乐平 */

/* Assignment 5 Question 2 */

proc import 
    datafile = "/home/u63790817/my_shared_file_links/u44964922/Assignments/HRdata.csv"
    out = task2_data
    dbms = csv
    replace;
    getnames = yes;
run;

proc sgplot data = task2_data;
    histogram satisfaction_level / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram last_evaluation / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram number_project / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram average_monthly_hours / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram time_spent_company / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram work_accident / group = left transparency = 0.5;
run;

proc sgplot data = task2_data;
    histogram promotion_last_5years / group = left transparency = 0.5;
run;

data task2_data;
    set task2_data;
    salary_order = put(salary, $8.);
    if salary = 'low' then salary_order = 1;
    else if salary = 'medium' then salary_order = 2;
    else if salary = 'high' then salary_order = 3;
run;

proc sort data=task2_data;
    by descending left salary_order;
run;

proc sgplot data=task2_data;
    vbar salary / group=left transparency=0.5 grouporder=descending categoryorder=respasc;
    xaxis discreteorder=data;
run;

proc logistic data = task2_data plots = roc;
    class work_accident(ref = "0") promotion_last_5years(ref = "0") salary(ref = "low") / param = ref;
    model left(event = "1") = 
        satisfaction_level
        last_evaluation
        number_project
        average_monthly_hours
        time_spent_company
        work_accident
        promotion_last_5years
        salary
    ;
run;

data task2_disc_data;
    set task2_data;
    
    if satisfaction_level < 0.1 then
        c_satisfaction_level = "low";
    else if satisfaction_level < 0.5 then
        c_satisfaction_level = "medium";
    else if satisfaction_level < 0.7 then
        c_satisfaction_level = "high";
    else 
        c_satisfaction_level = "彻底疯狂！！！";
    
    if last_evaluation < 0.6 then
        c_last_evaluation = "low";
    else if last_evaluation < 0.82 then
        c_last_evaluation = "medium";
    else 
        c_last_evaluation = "high";
        
    if number_project < 3 then
        c_number_project = "low";
    else if number_project < 4 then
        c_number_project = "medium";
    else 
        c_number_project = "high";
        
    if average_monthly_hours < 160 then
        c_average_monthly_hours = "low";
    else if average_monthly_hours < 260 then
        c_average_monthly_hours = "medium";
    else 
        c_average_monthly_hours = "high";
run;
    
proc logistic data = task2_disc_data plots = roc;
    class 
        c_satisfaction_level(ref = "low")
        c_last_evaluation(ref = "low")
        c_number_project(ref = "low")
        c_average_monthly_hours(ref = "low")
        work_accident(ref = "0") 
        promotion_last_5years(ref = "0") 
        salary(ref = "low") / param = ref;
    model left(event = "1") = 
        c_satisfaction_level
        c_last_evaluation
        c_number_project
        c_average_monthly_hours
        time_spent_company
        work_accident
        promotion_last_5years
        salary
    ;
run;

/* Assignment 5 Question 3 */
proc import 
    datafile = "/home/u63790817/Assignment/car.xlsx"
    out = task3_data
    dbms = xlsx
    replace;
    getnames = yes;
run;

data task3_data;
    set task3_data;
    ln = log(n);
run;

proc genmod data = task3_data;
    class car(ref = '1') age(ref = '1') dist(ref = '0') / param = ref;
    model y = car age dist / dist = poisson link = log offset = ln type1 type3;
run;

proc genmod data = task3_data;
    class car(ref = '1') age(ref = '1') dist(ref = '0') / param = ref;
    model y = car age dist / dist = negbin link = log offset = ln type3;
run;

/* Assignment 5 Question 4 */
proc import 
    datafile = "/home/u63790817/Assignment/disease.xlsx"
    out = task4_data
    dbms = xlsx
    replace;
    getnames = yes;
run;

proc logistic data = task4_data order = data plots = effect(polybar x = air_pollution*job_exposure*smoking_status);
    freq count;
    class air_pollution job_exposure smoking_status / param = ref;
    model level = air_pollution job_exposure smoking_status / scale = none aggregate;
run;
    
    
    
    
    
    