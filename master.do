/*==============================================================================
MASTER SCRIPT: Poverty and Welfare Analysis 2018-2021
==============================================================================*/

version 16
clear all
set more off
set varabbrev off

// Set random seed for reproducibility
set seed 12345

// Define project paths
global root "c:\Users\wb532966\eb-local\seminar-coding-with-ai-demo-prep"
global code "${root}/code"
global data_raw "${root}/data/raw"
global data_clean "${root}/data-clean"
global output_tables "${root}/output/tables"
global output_figures "${root}/output/figures"

// Create output directories if they don't exist
capture mkdir "${root}/data-clean"
capture mkdir "${root}/output"
capture mkdir "${root}/output/tables"
capture mkdir "${root}/output/figures"

// Set working directory
cd "${root}"

// Run analysis scripts in sequence
do "${code}/01_prepare_data.do"
do "${code}/02_clean_data.do"
do "${code}/03_descriptive_stats.do"
do "${code}/04_poverty_inequality.do"
do "${code}/05_regressions.do"
do "${code}/06_visualizations.do"

// Run R script for spatial mapping
shell Rscript "${code}/07_spatial_maps.R"

// End of master script
