################################################################################
# SCRIPT 07: Spatial Poverty Maps
# Purpose: Create spatial visualizations of poverty rates by region and year
################################################################################

# Load required packages
library(sf)
library(dplyr)
library(ggplot2)
library(patchwork)

# Define paths
root <- "c:/Users/wb532966/eb-local/seminar-coding-with-ai-demo-prep"
data_raw <- file.path(root, "data/raw")
output_tables <- file.path(root, "output/tables")
output_figures <- file.path(root, "output/figures")

#-------------------------------------------------------------------------------
# Import data
#-------------------------------------------------------------------------------

# Import regional poverty and inequality data
poverty_data <- read.csv(
  file.path(output_tables, "table2_poverty_inequality_regional.csv"),
  stringsAsFactors = FALSE
)

# Remove empty region rows
poverty_data <- poverty_data[poverty_data$region != "", ]

# Import geospatial boundaries
geo_data <- st_read(file.path(data_raw, "adm1.geojson"), quiet = TRUE)

#-------------------------------------------------------------------------------
# Merge datasets
#-------------------------------------------------------------------------------

# Standardize region names to uppercase for matching
geo_data$region_upper <- toupper(geo_data$region)

# Join poverty data with spatial boundaries
poverty_map <- geo_data |>
  left_join(poverty_data, by = c("region_upper" = "region"))

#-------------------------------------------------------------------------------
# Create poverty maps by year
#-------------------------------------------------------------------------------

# Filter data for 2018
poverty_2018 <- poverty_map |> filter(year == 2018)

# Create 2018 poverty map
map_2018 <- ggplot(poverty_2018) +
  geom_sf(aes(fill = poverty_rate * 100), color = "white", size = 0.3) +
  scale_fill_gradient(
    low = "#fee5d9",
    high = "#a50f15",
    name = "Poverty Rate (%)",
    limits = c(0, 20)
  ) +
  labs(
    title = "Poverty Rate by Region - 2018",
    subtitle = "Poverty line: 40% of median welfare"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# Save 2018 map
ggsave(
  file.path(output_figures, "map_poverty_2018.png"),
  map_2018,
  width = 10,
  height = 8,
  dpi = 300
)

# Filter data for 2021
poverty_2021 <- poverty_map |> filter(year == 2021)

# Create 2021 poverty map
map_2021 <- ggplot(poverty_2021) +
  geom_sf(aes(fill = poverty_rate * 100), color = "white", size = 0.3) +
  scale_fill_gradient(
    low = "#fee5d9",
    high = "#a50f15",
    name = "Poverty Rate (%)",
    limits = c(0, 20)
  ) +
  labs(
    title = "Poverty Rate by Region - 2021",
    subtitle = "Poverty line: 40% of median welfare"
  ) +
  theme_minimal() +
  theme(legend.position = "right")

# Save 2021 map
ggsave(
  file.path(output_figures, "map_poverty_2021.png"),
  map_2021,
  width = 10,
  height = 8,
  dpi = 300
)

#-------------------------------------------------------------------------------
# Create comparison map (side-by-side)
#-------------------------------------------------------------------------------

map_combined <- map_2018 + map_2021 +
  plot_annotation(
    title = "Regional Poverty Rates: 2018 vs 2021",
    theme = theme(plot.title = element_text(size = 16, face = "bold"))
  )

# Save combined map
ggsave(
  file.path(output_figures, "map_poverty_comparison.png"),
  map_combined,
  width = 16,
  height = 8,
  dpi = 300
)

#-------------------------------------------------------------------------------
# Summary statistics
#-------------------------------------------------------------------------------

poverty_summary <- poverty_data |>
  group_by(year) |>
  summarise(
    mean_poverty_rate = mean(poverty_rate) * 100,
    min_poverty_rate = min(poverty_rate) * 100,
    max_poverty_rate = max(poverty_rate) * 100,
    sd_poverty_rate = sd(poverty_rate) * 100
  )

# Export summary
write.csv(
  poverty_summary,
  file.path(output_tables, "table6_poverty_summary.csv"),
  row.names = FALSE
)
