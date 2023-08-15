# Credit Loss Forecast Project

This project aims to develop a credit loss forecasting model using SAS Studio University Edition. The project is divided into the following sections:

Dataset is generated using python code and saved as credit_transaction_data.csv for this project.


**1. Data Preparation (FetchData.sas):**
   - Read the credit transaction data from 'credit_transaction_data.csv'.
   - Clean the data by handling missing values and excluding records with Age < 18.
   - Output the cleaned dataset as 'cleaned_credit_data'.

**2. Model Building and visualization (ModelAndVisualization.sas):**
   - Build a Probability of Default (PD) model using logistic regression.
   - Score the PD model on the validation dataset and create 'validation_scored.csv'.
   - Encode PaymentHistory into binary variables.
   - Build a Loss Given Default (LGD) model using regression analysis.
   - Score the LGD model on the validation dataset and create 'validation_scored_lgd.csv'.
   - Generate visualizations and save them in 'VisualizationsOutput.pdf'.
     - Bar Plot of Default Status
     - Histogram of Age
     - Scatter Plot of Age vs. Income

**4. README:**
   - Project description and overview.


Note: This project was completed using SAS Studio University Edition.

For any questions, please contact Shreyas Jagadeep Shete at shreyasshete@outlook.com.
