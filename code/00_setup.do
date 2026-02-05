// ============================================================================
// Environment setup and validation
// ============================================================================
// Verify project directory structure and create missing folders

// Check and create required directories
capture mkdir "${data}/raw"
capture mkdir "${data}/temp"
capture mkdir "${data}/processed"
capture mkdir "${output}/tables"
capture mkdir "${output}/figures"

// Verify raw data files exist
local required_files "survey-2018-2021.dta cpi_ppp.csv icp2021.csv spat_def.csv"
foreach file of local required_files {
    capture confirm file "${data}/raw/`file'"
    if _rc {
        di as error "ERROR: Required file not found: ${data}/raw/`file'"
        exit 601
    }
}

// ============================================================================
// Setup complete
// ============================================================================
