DATA credit_data;  /* New SAS dataset named 'credit_data'*/
    INFILE '/home/u63524115/CreditLossForecast/credit_transaction_data.csv'  /*CSV file Path*/
    DLM=','  /* Delimiter on CSV*/
    FIRSTOBS=2;  /* Skip header row*/
    INPUT CustomerID Age Gender$ EmploymentStatus$ Income CreditHistory$ LoanID LoanAmount InterestRate LoanTerm$ PaymentHistory$ Default$ Year DefaultRate; /* Input Data Column Name */
/*     INFORMAT TransactionDate YYMMDD10. ; */
/*     FORMAT TransactionDate MMDDYY10.; */

RUN;


/* Data Cleaning and Preprocessing */
DATA cleaned_credit_data;
    SET credit_data;

    /* Handling missing values */
    IF missing(CreditHistory) OR missing(PaymentHistory) OR missing(Default) OR missing(Year) OR missing(DefaultRate) THEN DELETE;

    /* Exclude records with Age < 18 */
    IF Age >= 18;

RUN;

/* Display cleaned dataset */
PROC PRINT DATA=cleaned_credit_data; 
RUN;