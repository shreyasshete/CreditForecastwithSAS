%INCLUDE '/home/u63524115/CreditLossForecast/FetchData.sas'; /* Include the FetchData SAS CODEc */

/* GET "cleaned_credit_data" from that code */
DATA credit_data;
    SET cleaned_credit_data;
RUN;


/* Divide the given data to training dataset */
DATA train valid;
    SET credit_data;
    IF _N_ <= 800 THEN OUTPUT train;
    ELSE OUTPUT valid;
RUN;

/* Build Probability of Default Model */
PROC LOGISTIC DATA=train;
    CLASS Gender EmploymentStatus CreditHistory PaymentHistory; 
    MODEL Default(Event='Yes') = Age Income Gender EmploymentStatus CreditHistory PaymentHistory;
RUN;

/* Score the PD Model on the validation datase */
DATA validation_scored;
    SET valid;
    DROP _NAME_;
    RENAME P_1_ = PD_Score;
RUN;

/* Change the PaymentHistory from character to 0 and 1  */
DATA credit_data_encoded;
    SET credit_data;
    IF PaymentHistory = "On-time" THEN Payment_OnTime = 1;
    ELSE Payment_OnTime = 0;
    
    IF PaymentHistory = "Defaulted" THEN Payment_Defaulted = 1;
    ELSE Payment_Defaulted = 0;
    
    IF PaymentHistory = "Missed" THEN Payment_Missed = 1;
    ELSE Payment_Missed = 0;
RUN;

/* Build Loss Given Default Model */
PROC REG DATA=credit_data_encoded; /* Use the encoded dataset */
    MODEL LoanAmount = Age Income InterestRate Payment_OnTime Payment_Defaulted Payment_Missed;
RUN;

/* Score the LGD Model on validation dataset */
DATA validation_scored_lgd;
    SET valid;
    DROP _NAME_;
    RENAME PREDICTED = LGD_Estimate;
RUN;

/* Save validation_scored & validation_scored_lgd datasets */
PROC EXPORT DATA=validation_scored
            OUTFILE="/home/u63524115/CreditLossForecast/validation_scored.csv"
            DBMS=CSV REPLACE;
RUN;

PROC EXPORT DATA=validation_scored_lgd
            OUTFILE="/home/u63524115/CreditLossForecast/validation_scored_lgd.csv"
            DBMS=CSV REPLACE;
RUN;



/* Visualization */

/* Open PDF file to write into it */
ODS PDF FILE="/home/u63524115/CreditLossForecast/VisualizationsOutput.pdf";

/* Bar Plot of Default Status */
PROC SGPLOT DATA=credit_data;
    TITLE "Bar Plot of Default Status";
    VBAR Default / GROUP=Default LEGENDLABEL="Default Status" GROUPDISPLAY=CLUSTER;
RUN;

/* Histogram of Age */
PROC SGPLOT DATA=credit_data;
    TITLE "Histogram of Age";
    HISTOGRAM Age / BINWIDTH=5;
RUN;

/* Scatter Plot of Age vs. Income */
PROC SGPLOT DATA=credit_data;
    TITLE "Scatter Plot of Age vs. Income";
    SCATTER x=Age y=Income / MARKERATTRS=(SYMBOL=CIRCLEFILLED SIZE=7);
RUN;

/* Close the PDF file */
ODS PDF CLOSE;

