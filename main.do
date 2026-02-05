/*==============================================================================
WELFARE ANALYSIS 2018-2021
------------------------------------------------------------------------------
Purpose: Analyze household welfare trends with PPP adjustments
         Calculate poverty and inequality metrics by region and year

Author: [Your name]
Date: February 4, 2026

Inputs:
  data/survey-2018-2021.dta       Main household survey
  data/cpi_ppp.csv                CPI deflators by year
  data/icp2021.csv                ICP spatial deflators by year-region
  data/spat_def.csv               Spatial deflators by year-region

Outputs:
  output/descriptives.csv         Mean/SD for age, literacy, welfare
  output/poverty_inequality.csv   Poverty rate, gap, Gini, Theil
  output/national_summary.csv     Country-level aggregates
  output/graphs/                  Distribution histograms

Notes:
  - Welfare PPP = welfare / cpi2021 / icp2021 * spat_def
  - Poverty line = 40% of within-year median welfare_ppp
==============================================================================*/

clear all
set more off
version 16

// ============================================================================
// Project setup
// ============================================================================

// Project paths
global root "c:/Users/wb532966/eb-local/seminar-coding-with-ai-demo-prep"
global data "${root}/data"
global code "${root}/code"
global output "${root}/output"

// Parameters
global poverty_threshold 0.4
global base_year 2021

// ============================================================================
// Setup and validation
// ============================================================================

do "${code}/00_setup.do"

// ============================================================================
// Run analysis scripts
// ============================================================================

do "${code}/01_import_data.do"
do "${code}/02_clean_data.do"
do "${code}/03_descriptive_stats.do"
do "${code}/04_poverty_inequality.do"
do "${code}/05_national_aggregates.do"
do "${code}/06_visualizations.do"

// ============================================================================
// Completion
// ============================================================================
