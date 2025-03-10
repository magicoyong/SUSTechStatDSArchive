/* Assignment 2 Question 4 */
data _null_;
    call streaminit(114514);
run;

data A2Q4_sample;
    do grp = 1 to 10000;
        do i = 1 to 20;
            x = rand('normal', 0, 1);
            output;
        end;
        drop i;
    end;
run;

proc means data=A2Q4_sample prt noprint;
    by grp;
    var x;
    output out=A2Q4 prt=prt;
run;

proc sgplot data=A2Q4;
    histogram prt / binwidth=0.05;
    title "Distribution of p-values";
run;


/* Assignment 2 Question 5 */

data A2Q5_sample;
    %let p1 = 0.5;
    %let p2 = 0.5;
    do grp = 1 to 10000;
        do i = 1 to 20;
            x1 = rand("Bernoulli", &p1);
            x2 = rand("Bernoulli", &p2);
            output;
        end;
    end;
    drop i;
run;

proc freq data=A2Q5_sample noprint;
    by grp;
    tables x1 / out=A2Q5_f1 (keep=grp x1 percent);
run;

proc freq data=A2Q5_sample noprint;
    by grp;
    tables x2 / out=A2Q5_f2 (keep=grp x2 percent);
run;

data A2Q5_f1;
    set A2Q5_f1;
    where x1 ne 0;
run;

data A2Q5_f2;
    set A2Q5_f2;
    where x2 ne 0;
run;

data A2Q5_ps;
    merge A2Q5_f1(rename=(percent=p1) in=a) A2Q5_f2(rename=(percent=p2) in=b);
    by grp;
    drop x1 x2;
run;

data A2Q5_ps;
    set A2Q5_ps;
    p1 = p1 / 100.0;
    p2 = p2 / 100.0;
    p = (p1 + p2) / 2;
    se1 = sqrt(p * (1 - p) * (1.0 / 20 + 1.0 / 20));
    se2 = sqrt(p1 * (1 - p1) / 20.0 + p2 * (1 - p2) / 20.0);
    z1 = (p1 - p2) / se1;
    z2 = (p1 - p2) / se2;
    pv1 = 2 * (1 - cdf('normal', abs(z1)));
    pv2 = 2 * (1 - cdf('normal', abs(z2)));
run;

proc sql;
    create table A2Q5 as
    select 
        (sum(case when pv1 < 0.05 then 1 else 0 end) / count(*)) as a_se1,
        (sum(case when pv2 < 0.05 then 1 else 0 end) / count(*)) as a_se2
    from A2Q5_ps;
quit;

/* Assignment 2 Question 6 */

/* Question 6.1 */

data A2Q6_homicide;
input convict_race $ victim_race $ death_penalty cnt;
datalines;
white white 1 18
white white 0 133
white black 1 1
white black 0 10
black white 1 11
black white 0 51
black black 1 6
black black 0 96
;
run;

/* Question 6.2 */

proc freq data = A2Q6_homicide;
    weight cnt;
    tables death_penalty / binomial(level = 2 wald exact) alpha = 0.05;
    exact binomial;
    output out = A2Q6_2 bin;
run;

/* Question 6.3 */

proc freq data = A2Q6_homicide;
    weight cnt;
    tables death_penalty / binomial(level = 2 p = 0.1 wald exact) alpha = 0.05;
    exact binomial;
    output out = A2Q6_3 bin;
run;

/* Question 6.4 */

proc freq data = A2Q6_homicide;
    weight cnt;
    tables convict_race * death_penalty / riskdiff(equal var = null cl = wald norisks) alpha = 0.1;
    output out = A2Q6_4 riskdiff;
run;

/* Question 6.5 */

proc freq data = A2Q6_homicide;
    weight cnt;
    tables victim_race * death_penalty / riskdiff(equal var = null cl = wald norisks) alpha = 0.05;
    output out = A2Q6_5 riskdiff;
run;

    





