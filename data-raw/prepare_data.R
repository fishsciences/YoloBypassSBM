## code to prepare datasets in this package
library(tidyverse)
library(cfs.misc)
library(lubridate)

# Simulation parameters ----------------------------------------------

simulation_parameters <- list(name = "demo",
                              sim_type = "deterministic",
                              reps = 1:1,
                              random_seed = 1,
                              water_years = 1997:2011,
                              chinook_runs = c("Fall", "LateFall", "Spring", "Winter"),
                              ocean_year_probability = 1)
usethis::use_data(simulation_parameters, overwrite = TRUE)

# Length-weight parameters ----------------------------------------------
# Tiffan et al 2014

length_weight_parameters <- c("a" = 0.000004, "b" = 3.2252)
usethis::use_data(length_weight_parameters, overwrite = TRUE)

# Water year type ----------------------------------------------

water_year_type <- tibble(WaterYear = 1997:2011,
                          WaterYearType = get_water_year_type(WaterYear))
usethis::use_data(water_year_type, overwrite = TRUE)

# Ocean survival parameters ----------------------------------------------

ocean_survival_parameters <- readRDS("data-raw/OceanSurvivalParameters.rds")
usethis::use_data(ocean_survival_parameters, overwrite = TRUE)

# Telemetry model parameters ----------------------------------------------
# not documented in data.R; maybe ask Von to do that?

telemetry_parameters <- readRDS("data-raw/TelemetryModelParameters.rds")
usethis::use_data(telemetry_parameters, overwrite = TRUE)

# Rearing time parameters ----------------------------------------------

rt_delta <- readRDS("data-raw/RearingTimeParameters_Delta.rds")
rt_yolo <- readRDS("data-raw/RearingTimeParameters_Yolo.rds")
# thresh is the temperature threshold (ºC); fish stop rearing on first day with mean temp > thresh
rt_delta[["thresh"]] <- 22
rt_yolo[["thresh"]] <- 22
rearing_time_parameters <- list("Delta" = rt_delta, "Yolo" = rt_yolo)
usethis::use_data(rearing_time_parameters, overwrite = TRUE)

# Rearing survival parameters ----------------------------------------------

# default value of daily rearing survival (under deterministic simulation) and
# lower and upper limits of uniform distribution of daily survival values
rs_delta <- c("survival" = 0.99, "min" = 0.98, "max" = 1)
rs_yolo <- c("min" = 0, "max" = 1, "inflection" = 74, "steepness" = -6)
rearing_survival_parameters <- list("Delta" = rs_delta, "Yolo" = rs_yolo)
usethis::use_data(rearing_survival_parameters, overwrite = TRUE)

# Rearing abundance ----------------------------------------------

rearing_proportion_parameters <- c("min" = 0, "max" = 1,
                                   "inflection" = 100, "steepness" = 15)
usethis::use_data(rearing_proportion_parameters, overwrite = TRUE)

# Growth parameters ----------------------------------------------
# from Perry et al 2015
# b = allometric growth exponent
# d and g = shape parameters of the Ratkowsky model
# TL = lower temperature limit for growth
# TU = upper temperature limit for growth

growth_parameters <- c("b" = 0.338, "d" = 0.415, "g" = 0.315,
                       "TL" = 1.833, "TU" = 24.918)
usethis::use_data(growth_parameters, overwrite = TRUE)

# Annual abundance ----------------------------------------------

aa <- read_csv("data-raw/AnnualAbundance.csv") %>%
  select(Run, WaterYear, Abundance) %>%
  mutate(Abundance = round(Abundance)) %>%
  spread(key = Run, value = Abundance)

annual_abundance <- list()
for (i in c("Fall", "LateFall", "Spring", "Winter")){
  annual_abundance[[i]] <- aa[[i]]
  names(annual_abundance[[i]]) <- as.character(aa[["WaterYear"]])
}
usethis::use_data(annual_abundance, overwrite = TRUE)

# Water year dates and model days ---------------------------------------------
# the model day is simply a count from first date (1996-10-02) to last date (1997-09-30)

dates_df <- tibble(Date = seq(ymd("1996-10-02"), ymd("2011-09-30"), by = "days"),
                   ModelDay = 1:length(Date),
                   WaterYear = water_year(Date))

wy_model_days <- list()
wy_dates <- list()
for (i in unique(dates_df$WaterYear)){
  tmp <- filter(dates_df, WaterYear == i)
  wy_char <- as.character(i)
  wy_model_days[[wy_char]] <- tmp[["ModelDay"]]
  wy_dates[[wy_char]] <- tmp[["Date"]]
}
usethis::use_data(wy_model_days, overwrite = TRUE)
usethis::use_data(wy_dates, overwrite = TRUE)

# Flood duration ----------------------------------------------

fd <- read_csv("data-raw/FloodDuration.csv")
# model simulates one water-year/run combination at a time
# changing input data to make value lookups based on water years
flood_duration <- list()
for (i in names(wy_model_days)){
  indices <- wy_model_days[[i]]
  flood_duration[[i]] <- fd[["FloodDuration"]][indices]
}
usethis::use_data(flood_duration, overwrite = TRUE)

# Floodplain temperature difference ----------------------------------------------

dates_diff <- tibble(Date = seq(ymd("1996-10-02"), ymd("2011-09-30"), by = "days"),
                     DOY = yday(Date),
                     WaterYear = water_year(Date)) %>%
  left_join(readRDS("data-raw/FloodplainTemperatureDifference.rds"))

ftd <- list()
for (i in unique(dates_diff$WaterYear)){
  tmp <- filter(dates_diff, WaterYear == i)
  ftd[[as.character(i)]] <- tmp[["Diff"]]
}

# default is to use the same temperature difference for Yolo and Delta
floodplain_temperature_difference <- list("Yolo" = ftd,
                                          "Delta" = ftd)
usethis::use_data(floodplain_temperature_difference, overwrite = TRUE)

# Toe Drain temperature ----------------------------------------------

td <- readRDS("data-raw/ToeDrainTemp.rds") %>%
  arrange(date) %>%
  mutate(WaterYear = water_year(date))

toe_drain_temperature <- list()
for (i in unique(td$WaterYear)){
  tmp <- filter(td, WaterYear == i)
  toe_drain_temperature[[as.character(i)]] <- tmp[["temp"]]
}
usethis::use_data(toe_drain_temperature, overwrite = TRUE)

# Freeport temperature ----------------------------------------------

fpt <- readRDS("data-raw/FreeportTemp.rds") %>%
  arrange(date) %>%
  mutate(WaterYear = water_year(date))

freeport_temperature <- list()
for (i in unique(fpt$WaterYear)){
  tmp <- filter(fpt, WaterYear == i)
  freeport_temperature[[as.character(i)]] <- tmp[["temp"]]
}
usethis::use_data(freeport_temperature, overwrite = TRUE)

# Floodplain temperature ----------------------------------------------

load("data/floodplain_temperature_difference.rda")
load("data/freeport_temperature.rda")
load("data/toe_drain_temperature.rda")

floodplain_temperature <- list("Yolo" = Map(function(x, y) x + y,
                                            toe_drain_temperature, floodplain_temperature_difference[["Yolo"]]),
                               "Delta" = Map(function(x, y) x + y,
                                             freeport_temperature, floodplain_temperature_difference[["Delta"]]))
usethis::use_data(floodplain_temperature, overwrite = TRUE)

# Entry timing ----------------------------------------------

klt <- readRDS("data-raw/KnightsLandingTiming.rds")

knights_landing_timing <- list()
for (i in unique(klt$WaterYear)){
  tmp <- filter(klt, WaterYear == i)
  for (j in c("Fall", "LateFall", "Spring", "Winter")){
    knights_landing_timing[[j]][[as.character(i)]] <- tmp[[j]]
  }
}
usethis::use_data(knights_landing_timing, overwrite = TRUE)

# Fork length ----------------------------------------------

klfl <- readRDS("data-raw/KnightsLandingFLParams.rds")

knights_landing_fl_params <- list()
for (i in unique(klfl$WaterYear)){
  wy_char <- as.character(i)
  for (j in c("Fall", "LateFall", "Spring", "Winter")){
    tmp <- filter(klfl, WaterYear == i & Run == j)
    knights_landing_fl_params[[j]][[wy_char]][["MeanLog"]] <- tmp[["ImputeMeanLog"]]
    knights_landing_fl_params[[j]][[wy_char]][["SDLog"]] <- tmp[["ImputeSDLog"]]
  }
}
usethis::use_data(knights_landing_fl_params, overwrite = TRUE)

# Freeport flow and Proportion entrained at Fremont Weir ----------------------------------------------

exg_flow <- read_csv(file.path("data-raw", "ExgFlow.csv")) %>%
  filter(Date > ymd("1996-10-01") & Date < ymd("2011-10-01")) %>%
  arrange(Date) %>%
  mutate(WaterYear = water_year(Date))

fremont_weir_proportion <- list()
freeport_flow <- list()
for (i in unique(exg_flow$WaterYear)){
  tmp <- filter(exg_flow, WaterYear == i)
  wy_char <- as.character(i)
  fremont_weir_proportion[[wy_char]] <- tmp$PropFremont
  freeport_flow[[wy_char]] <- tmp$Freeport
}
usethis::use_data(fremont_weir_proportion, overwrite = TRUE)
usethis::use_data(freeport_flow, overwrite = TRUE)

# Inundated area ----------------------------------------------

flooded <- read_csv("data-raw/Inundated_sqkm_long.csv") %>%
  filter(Scenario == "Exg" & Date < ymd("2011-10-01")) %>%
  arrange(Date)

inundated_sqkm <- list()
for (i in unique(flooded$WaterYear)){
  tmp <- filter(flooded, WaterYear == i)
  inundated_sqkm[[as.character(i)]] <- tmp$Inundated_sqkm
}
# loooking at the inundated area
str(inundated_sqkm)
# the thing that jumps out is how there is no inundated on Oct 1st of any year
# I distinctly remember that the model started on Oct 2nd in WY1997
# but it's fuzzy whether this strange choice Oct 2nd was used for every year
# nonetheless, I'm moving forward b/c there is very little (no?) entrainment at this time of year
usethis::use_data(inundated_sqkm, overwrite = TRUE)

