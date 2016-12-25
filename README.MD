Johns Hopkins (Coursera) Gettting & Cleaning Data Course Project

This README file explains details around the elements necessary for this project

Original Data Source:  Data for analysis is downloaded from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Original Data files used in this project: 
   subject_train.txt
   X_train.txt
   y_train.txt
   subject_test.txt
   X_test.txt
   y_test.txt
   features.txt

Project Files Included in this Repository: 
   run_analysis.R
    R script to create a subset of the initial dataset that includes the mean of each variable 
    for each activity and each subject

   codebook.rmd
    This is an R Markdown document used by Rstudio to create HTML project documentation. Markdown  
    is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. A codebook is a 
    technical description of the data that was collected for a particular purpose. It describes how 
    the data are arranged in the computer file or files, what the various numbers and letters mean, 
    and any special instructions on how to use the data properly

   codebook.md - text version of codebook.html

   readme.md

   codeBook.html 
    Created using the R Markdown document codebook.rmd. The HTML version of codebook.rmd

   tidydata.txt
    Tidy data set created by run_analysis.R. This text file contains 180 observations and 68 columns
    (subjectID, activity, and 66 columns for measurement variables)

Environment: 
    R version 3.3.2
    Rstudio version 1.0.136

Running the script:
  Download the original files listed above as well as run_analysis.R and codebook.rmd to the working directory.
  Set the working directory in Rstudio. At the Rstudio prompt, type source(run_analysis.R).

  The codebook.html file and tidydata.txt files are created.