# ==============================================================================
# Script: 08_maps.R
# Purpose: Create poverty maps by region and year
# Inputs: table2_poverty_regional.csv, adm1.geojson
# Outputs: Poverty maps (PNG files)
# ==============================================================================

library(sf)
library(dplyr)
library(ggplot2)

# Set paths
root <- "c:/Users/wb532966/eb-local/seminar-coding-with-ai-demo-prep"
tables <- file.path(root, "Output/Tables")
raw <- file.path(root, "Data/Raw")
figures <- file.path(root, "Output/Figures")

# Import poverty data
poverty_data <- read.csv(file.path(tables, "table2_poverty_regional.csv"))

# Import geospatial boundaries
geo_boundaries <- st_read(file.path(raw, "adm1.geojson"))

# Examine structure to identify matching variables
names(poverty_data)
names(geo_boundaries)
head(poverty_data$region)
head(geo_boundaries)

# Clean region names for matching
poverty_data <- poverty_data |>
  mutate(region = trimws(toupper(region)))

# Standardize region names in geo_boundaries
geo_boundaries <- geo_boundaries |>
  mutate(region_clean = trimws(toupper(region)))

# Merge poverty data with geospatial boundaries
poverty_map_data <- geo_boundaries |>
  left_join(poverty_data, by = c("region_clean" = "region"))

# Create poverty rate maps for each year
years <- c(2018, 2021)

for (yr in years) {
  map_data <- poverty_map_data |>
    filter(year == yr)

  p <- ggplot(map_data) +
    geom_sf(aes(fill = pov_rate * 100), color = "white", size = 0.3) +
    scale_fill_viridis_c(
      name = "Poverty Rate (%)",
      option = "plasma",
      na.value = "grey90"
    ) +
    labs(
      title = paste("Poverty Rate by Region -", yr),
      subtitle = "Poverty line: 40% of national median welfare"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(face = "bold", size = 14),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    )

  ggsave(
    filename = file.path(figures, paste0("map_poverty_rate_", yr, ".png")),
    plot = p,
    width = 8,
    height = 6,
    dpi = 300
  )
}

# Create Gini coefficient maps
for (yr in years) {
  map_data <- poverty_map_data |>
    filter(year == yr)

  p <- ggplot(map_data) +
    geom_sf(aes(fill = gini_index), color = "white", size = 0.3) +
    scale_fill_viridis_c(
      name = "Gini Index",
      option = "viridis",
      na.value = "grey90"
    ) +
    labs(
      title = paste("Inequality (Gini Index) by Region -", yr),
      subtitle = "Higher values indicate greater inequality"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.title = element_text(face = "bold", size = 14),
      axis.text = element_blank(),
      axis.ticks = element_blank()
    )

  ggsave(
    filename = file.path(figures, paste0("map_gini_index_", yr, ".png")),
    plot = p,
    width = 8,
    height = 6,
    dpi = 300
  )
}

# Create side-by-side comparison map
p_comparison <- ggplot(poverty_map_data) +
  geom_sf(aes(fill = pov_rate * 100), color = "white", size = 0.3) +
  scale_fill_viridis_c(
    name = "Poverty Rate (%)",
    option = "plasma",
    na.value = "grey90"
  ) +
  facet_wrap(~ year) +
  labs(
    title = "Poverty Rate by Region: 2018 vs 2021",
    subtitle = "Poverty line: 40% of national median welfare"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )

ggsave(
  filename = file.path(figures, "map_poverty_comparison.png"),
  plot = p_comparison,
  width = 12,
  height = 5,
  dpi = 300
)
