# ============================================================================ #
# SPATIAL ANALYSIS SCRIPT
# Purpose: Import poverty/inequality data and match with geospatial boundaries
# Author: Generated for reproducibility project
# Date: 2026-02-04
# ============================================================================ #

# Load required packages
library(haven)      # For reading Stata .dta files
library(sf)         # For spatial data handling
library(dplyr)      # For data manipulation
library(readr)      # For reading CSV files

# Set working directory (adjust as needed)
setwd("c:/Users/wb532966/eb-local/seminar-coding-with-ai-demo-prep")

# ============================================================================ #
# 1. IMPORT POVERTY AND INEQUALITY DATA
# ============================================================================ #

# Option A: Import from Stata format
poverty_data <- read_dta("data/processed/subnational_poverty_inequality.dta")

# Option B: Import from CSV (alternative if Stata file unavailable)
# poverty_data <- read_csv("output/tables/poverty_inequality.csv")

# Examine the structure of poverty data
print("Poverty Data Structure:")
str(poverty_data)
print("\nFirst few rows:")
head(poverty_data)
print("\nUnique regions:")
unique(poverty_data$region)

# ============================================================================ #
# 2. IMPORT GEOSPATIAL BOUNDARIES
# ============================================================================ #

# Read GeoJSON file with administrative boundaries
boundaries <- st_read("data/raw/adm1.geojson", quiet = FALSE)

# Examine the structure of boundaries data
print("\nBoundaries Data Structure:")
str(boundaries)
print("\nUnique regions in boundaries:")
unique(boundaries$region)

# View coordinate reference system
print("\nCoordinate Reference System:")
st_crs(boundaries)

# ============================================================================ #
# 3. MATCHING STRATEGY
# ============================================================================ #

# Both datasets have a "region" variable that serves as the linking key
# The poverty data contains: region, year, poverty_rate, poverty_gap,
#                             gini_index, theil_index
# The boundaries data contains: region, id_adm, geometry

# Check for matching issues
poverty_regions <- unique(poverty_data$region)
boundary_regions <- unique(boundaries$region)

print("\nRegion Matching Analysis:")
print("Regions in poverty data but not in boundaries:")
setdiff(poverty_regions, boundary_regions)

print("\nRegions in boundaries but not in poverty data:")
setdiff(boundary_regions, poverty_regions)

# ============================================================================ #
# 4. COMBINE DATASETS
# ============================================================================ #

# Join poverty data with spatial boundaries
# This creates a spatial dataframe with poverty indicators attached to polygons
combined_data <- boundaries |>
  left_join(poverty_data, by = "region")

# Examine combined dataset
print("\nCombined Dataset Structure:")
str(combined_data)
print("\nSummary statistics:")
summary(combined_data)

# Check for missing matches
missing_matches <- combined_data |>
  filter(is.na(year)) |>
  select(region, id_adm)

if (nrow(missing_matches) > 0) {
  print("\nRegions with missing poverty data:")
  print(missing_matches)
} else {
  print("\nAll regions successfully matched!")
}

# ============================================================================ #
# 5. SAVE COMBINED DATASET
# ============================================================================ #

# Save as GeoPackage (modern spatial format)
st_write(combined_data,
         "data/processed/poverty_spatial.gpkg",
         delete_dsn = TRUE)

# Save as Shapefile (for compatibility)
st_write(combined_data,
         "data/processed/poverty_spatial.shp",
         delete_dsn = TRUE)

# Save attribute data as CSV (non-spatial)
combined_data |>
  st_drop_geometry() |>
  write_csv("output/tables/poverty_spatial_attributes.csv")

print("\n=== Spatial Analysis Complete ===")
print("Output files created:")
print("  - data/processed/poverty_spatial.gpkg (GeoPackage)")
print("  - data/processed/poverty_spatial.shp (Shapefile)")
print("  - output/tables/poverty_spatial_attributes.csv (CSV)")

# ============================================================================ #
# 6. BASIC VISUALIZATION EXAMPLE
# ============================================================================ #

# Optional: Create a simple map for one year
library(ggplot2)

# Filter for most recent year
latest_year <- max(combined_data$year, na.rm = TRUE)
map_data <- combined_data |>
  filter(year == latest_year)

# Create poverty rate map
poverty_map <- ggplot(map_data) +
  geom_sf(aes(fill = poverty_rate), color = "white", size = 0.2) +
  scale_fill_viridis_c(
    name = "Poverty Rate",
    labels = scales::percent_format(accuracy = 0.1),
    option = "plasma"
  ) +
  labs(
    title = paste("Subnational Poverty Rates,", latest_year),
    subtitle = "Percentage of population below poverty line",
    caption = "Source: Survey data with PPP adjustments"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11)
  )

# Save map
ggsave("output/figures/poverty_map.png",
       plot = poverty_map,
       width = 10,
       height = 8,
       dpi = 300)

print("\nMap saved: output/figures/poverty_map.png")

# ============================================================================ #
# NOTES ON DATA MATCHING
# ============================================================================ #

# The matching key is "region" which appears in both datasets:
#
# Poverty data regions:
#   - Contains subnational administrative units with poverty estimates by year
#   - Multiple observations per region (one per year: 2018, 2019, 2020, 2021)
#
# Boundary data regions:
#   - Contains polygon geometries for each administrative unit
#   - One observation per region with spatial coordinates
#
# The join creates a many-to-one relationship where each boundary polygon
# is matched with multiple years of poverty data. For mapping purposes,
# you typically filter to a specific year.
#
# Key variables in combined dataset:
#   - region: Administrative unit name (linking key)
#   - year: Survey year (2018-2021)
#   - poverty_rate: Proportion below poverty line
#   - poverty_gap: Average poverty depth
#   - gini_index: Income inequality measure (0-1)
#   - theil_index: Alternative inequality measure
#   - geometry: Spatial polygon coordinates
#
# ============================================================================ #
