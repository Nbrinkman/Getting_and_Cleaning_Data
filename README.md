Getting_and_Cleaning_Data
=========================

Coursera course  
Getting and Cleaning Data  
Course Project  
2014-10-26  

Purpose: 
-------- 
This repo was created as part of a course to demonstrate ability to collect, work with and clean a data set.

The run_analysis.R script will do the following tasks:
------------------------------------------------------
	1. Loads the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip into RStudio
	2. Applies descriptive variable names to the data  
	3. Merges the training and test sets to create one data set  
	4. Extracts only the measurements on the mean and standard deviation for each measurement.
	5. Uses descriptive activity names to name the activities in the data set.
	6. Creates a second, independent tidy data set with the average of each variable for each acitivity and each subject and writes the tidy data to the directory.


This repository contains:
-------------------------
	1. A Code Book reiterating the variables from the downloaded data, taken from the authors Readme file.  Also included is a description of the subset of data used here.
	2. A R script containing the code used to format the downloaded data.
	3. The tidy data set organized by subject, activity, and values of each measurment.
