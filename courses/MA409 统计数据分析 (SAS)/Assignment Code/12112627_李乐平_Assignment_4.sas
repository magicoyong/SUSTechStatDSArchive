/* 12112627 李乐平 */

/* Assignment 4 Question 3 */

data task3_data;
   input tool $ worker $ value @@;
   datalines;
ToolA Worker1 14
ToolA Worker1 10
ToolA Worker1 12
ToolA Worker2 11
ToolA Worker2 11
ToolA Worker2 10
ToolA Worker3 13
ToolA Worker3 19
ToolA Worker4 10
ToolA Worker4 12
ToolB Worker1 9
ToolB Worker1 7
ToolB Worker2 10
ToolB Worker2 8
ToolB Worker2 9
ToolB Worker3 7
ToolB Worker3 8
ToolB Worker3 11
ToolB Worker4 6
ToolC Worker1 5
ToolC Worker1 11
ToolC Worker1 8
ToolC Worker2 13
ToolC Worker2 14
ToolC Worker2 11
ToolC Worker3 12
ToolC Worker3 13
ToolC Worker4 14
ToolC Worker4 10
ToolC Worker4 12
;
run;

/* Question 3.1 */
proc glm data = task3_data outstat = task3_anova1;
    class worker;
    model value = worker;
run;

/* Question 3.2 & 3.3 */
proc glm data = task3_data outstat = task3_anova2;
    class tool;
    model value = tool;
    means tool / hovtest = bf tukey alpha = 0.1;
run;

/* Question 3.4 */
proc glm data = task3_data outstat = task3_anova4;
    class worker tool;
    model value = worker tool worker * tool;
    output out = task3_reg residual = res;
run;

/* Question 3.5 */
proc univariate data = task3_reg normal;
    var res;
run;

/* Assignment 4 Question 4 */


/* Question 4.1 */

data task4_data1;
    call streaminit(12345);
    do Ind = 1 to 5000;
        do grp = "A", "B", "C";
            do j = 1 to 7;
                Y = rand("normal", 1, 1);
                output;
            end;
        end;
    end;
    drop j;
run;

proc glm data = task4_data1 noprint outstat = task4_anova1;
    class grp;
    model Y = grp;
    by Ind;
run;

proc sql;
    create table task4_st1 as
    select
        sum(case when prob < 0.05 then 1 else 0 end) / count(*) as type_I_err_rate
    from 
        task4_anova1
    where 
        _TYPE_ = "SS1";
run;

/* Question 4.2 */

data task4_data2;
    call streaminit(12345);
    do Ind = 1 to 5000;
        do grp = "A", "B", "C";
            do j = 1 to 7;
                if grp = "A" then
                    Y = rand("normal", 1, 0.5);
                else if grp = "B" then
                    Y = rand("normal", 1, 1);
                else 
                    Y = rand("normal", 1, 2);
                output;
            end;
        end;
    end;
    drop j;
run;

proc glm data = task4_data2 noprint outstat = task4_anova2;
    class grp;
    model Y = grp;
    by Ind;
run;

proc sql;
    create table task4_st2 as
    select
        sum(case when prob < 0.05 then 1 else 0 end) / count(*) as type_I_err_rate
    from 
        task4_anova2
    where 
        _TYPE_ = "SS1";
run;
    
    
    
    
    
    
    
    


