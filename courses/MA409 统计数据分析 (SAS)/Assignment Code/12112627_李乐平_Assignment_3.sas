/* 12112627 李乐平 */

/* Assignment 3 Question 1 */

/* Question 1.1 */
data task1_cohort();
    call streaminit(12321);
    array disease(*) diabetes asthma cancer ms thyroid liver arthritis;
    array factor(*) leo purple time red_hair first_name_C summer;
    do i = 1 to 10000;
        do j = 1 to 7;
            disease(j) = rand("Bernoulli", 0.1);
        end;
        do j = 1 to 6;
            factor(j) = rand("Bernoulli", 0.05);
        end;
        output;
    end;
    drop i j;
run;

/* Question 1.2 */
%macro chi_square_test(disease);
    proc freq data = task1_cohort;
        tables &disease * leo / chisq;
        tables &disease * purple / chisq;
        tables &disease * time / chisq;
        tables &disease * red_hair / chisq;
        tables &disease * first_name_C / chisq;
        tables &disease * summer / chisq;
    run;
%mend;

%chi_square_test(diabetes);
%chi_square_test(asthma);
%chi_square_test(cancer);
%chi_square_test(ms);
%chi_square_test(thyroid);
%chi_square_test(liver);
%chi_square_test(arthritis);

/* Assignment 3 Question 4 */

proc import 
    datafile = "/home/u63790817/my_shared_file_links/u44964922/Assignments/EducationExpenditure.xlsx"
    out = task4_edu
    dbms = xlsx
    replace;
    getnames = yes;
run;

/* Question 4.1 */

proc reg data = task4_edu;
    model Y = X1 X2 X3 / vif; 
    output out = task4_out_residuals p = residual r = fitted;
run;

/* Test for Linearity */
proc reg data = task4_out_residuals;
    model residual = fitted;
    output out = task4_out_linearity p = resid r = fitted;
run;

/* Test for Homoscedasticity */
proc glm data = task4_edu plots = diagnostics(unpack);
    model Y = X1 X2 X3;
    output out = task4_tmp (keep = Y X1 X2 X3 fv) predicted = fv;
run;

proc model data = task4_edu;
    parameters b0 b1 b2 b3;
    y = b0 + b1 * X1 + b2 * X2 + b3 * X3;
    fit y / white pagan = (1 X1 X2 X3);
run;
    
/* Test for Normality of Residuals */
proc univariate data = task4_out_residuals normal;
    var residual;
run;

/* Question 4.2 */

proc reg data = task4_out_residuals outest = task4_out_model;
    model Y = X1 X2 X3 / vif;
    output out = task4_out_diagnostic rstudent = rstudent cookD = cookD h = leverage;
run;

/* Question 4.3 */

data task4_tmp;
    set task4_tmp;
    w = 1 / (fv ** 2);
run;

proc glm data = task4_tmp;
    model Y = X1 X2 X3;
    weight w;
run;

proc sql;
    create table task4_edu_new as
    select *
    from task4_edu
    where State ne 'AK';
quit;

proc reg data = task4_edu_new;
    model Y = X1 X2 X3 / vif; 
    output out = task4_out_residuals_new p = residual r = fitted;
run;

/* Test for Linearity */
proc reg data = task4_out_residuals_new;
    model residual = fitted;
    output out = task4_out_linearity_new p = resid r = fitted;
run;

/* Test for Homoscedasticity */
proc glm data = task4_edu_new plots = diagnostics(unpack);
    model Y = X1 X2 X3;
run;

proc model data = task4_edu_new;
    parameters b0 b1 b2 b3;
    y = b0 + b1 * X1 + b2 * X2 + b3 * X3;
    fit y / white pagan = (1 X1 X2 X3);
run;
    
/* Test for Normality of Residuals */
proc univariate data = task4_out_residuals_new normal;
    var residual;
run;

/* Assignment 3 Question 5 */
proc import 
    datafile = "/home/u63790817/my_shared_file_links/u44964922/Assignments/AirPollution.xlsx"
    out = task5_pollution
    dbms = xlsx
    replace;
    getnames = yes;
run;

/* Question 5.1 */
proc corr data = task5_pollution rank;
   var Y X1-X15;
run;

/* Question 5.2 */
proc reg data = task5_pollution;
   model Y = X1-X15 / tol vif;
run;

/* Question 5.3 */
proc glmselect data = task5_pollution plots=all;
    model Y = X1-X15 / selection = stepwise (choose = sbc) details = all stats = (bic aic adjrsq cp);
    output out = task5_stepwise p = prediction r = residual;
run;

/* Question 5.4 */
proc standard data = task5_pollution mean = 0 std = 1 out = task5_pollution_std;
    var Y X1-X15;
run;

proc reg data = task5_pollution_std outest = task5_ridge ridge = 0 to 1 by 0.05 plots(only) = ridge(unpack);
    model Y = X1 X2 X6 X9 X12 X13 X14;
run;

/* Assignment 3 Question 6 */

/* Question 6.1 */

data task6_data;
    do i = 1 to 1000;
        Xi = rand("Uniform", 0, 5);
        Yi = rand("Exponential", 3 + 5*Xi);
        output;
    end;
run;

proc reg data = task6_data;
    model Yi = Xi / noprint;
    output out = task6_reg p=predicted r=residual;
run;

proc sgplot data = task6_reg;
    scatter x=predicted y=residual / markerattrs=(symbol=circlefilled);
    refline 0 / lineattrs=(color=red);
    xaxis label="Fitted Values";
    yaxis label="Residuals";
    title "Fitted versus Residual Plot";
run;

/* Question 6.2 */

data task6_transformed_data;
    set task6_data;
    log_Yi = log(Yi);
run;

proc reg data = task6_transformed_data;
    model log_Yi = Xi / noprint;
    output out=task6_reg_transformed p=predicted_transformed r=residual_transformed;
run;

proc sgplot data=task6_reg_transformed;
    scatter x=predicted_transformed y=residual_transformed / markerattrs=(symbol=circlefilled);
    refline 0 / lineattrs=(color=red);
    xaxis label="Fitted Values";
    yaxis label="Residuals";
    title "Fitted versus Residual Plot (Transformed)";
run;









