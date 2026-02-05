/*==============================================================================
Project: Poverty and Welfare Analysis 2018-2021
Purpose: Master script to run entire analysis
Date: February 5, 2026
==============================================================================*/

clear all
set more off
set varabbrev off

// Set project root directory
global root "c:\Users\wb532966\eb-local\seminar-coding-with-ai-demo-prep"

// Set subdirectories
global code     "${root}/Code"
global raw      "${root}/Data/Raw"
global final    "${root}/Data/Final"
global temp     "${root}/Data/Temp"
global tables   "${root}/Output/Tables"
global figures  "${root}/Output/Figures"

// Run all scripts in sequence
do "${code}/01_import.do"
do "${code}/02_clean.do"
do "${code}/03_construct.do"
do "${code}/04_analysis_regional.do"
do "${code}/05_analysis_national.do"
do "${code}/06_regression.do"
do "${code}/07_figures.do"
