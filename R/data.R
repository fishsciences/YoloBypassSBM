#' Simulation parameters
#'
#' Parameters used in `run_simulation()`.
#'
#' @format A named list containing the following parameters:
#' \describe{
#'   \item{name}{Simulation name. Used for naming output files.}
#'   \item{sim_type}{Simulation type: "stochastic" or "deterministic".}
#'   \item{reps}{Vector of replicate numbers, e.g., 1:50, 51:100, etc.}
#'   \item{water_years}{Numeric vector of water years (1997-2011) to include in a simulation. Default is 1997:2011.}
#'   \item{chinook_runs}{Chinook runs to include in a simulation. Default is c("Fall", "LateFall", "Spring", "Winter").}
#'   \item{ocean_year_type_probability}{Probability of ocean survival being based on fork length relationship.}
#' }
#'
"simulation_parameters"

#' Length-weight parameters
#'
#' Parameters for an allometric relationship from Tiffan et al. (2014) for converting
#' between weight (g) and length (mm).
#'
#' @format A named vector:
#' \describe{
#'   \item{a}{Constant}
#'   \item{b}{Scaling exponent}
#' }
#'
"length_weight_parameters"

#' Water year type
#'
#' Water year classifications for the Sacramento River from http://cdec.water.ca.gov/reportapp/javareports?name=WSIHIST.
#'
#' @format A data frame with 2 columns and 15 rows:
#' \describe{
#'   \item{WaterYear}{Water year: 1997-2011}
#'   \item{WaterYearType}{Water year classification. Above Normal and Below Normal include newline characters for nicer display when plotting.}
#' }
#'
"water_year_type"

#' Ocean survival parameters
#'
#' Parameters for two beta-binomial regression models. The "length" model includes fork length as a predictor.
#' The "intercept" model is an intercept-only model with slope equal to zero.
#'
#' @format A named list ("intercept" or "length") of named vectors:
#' \describe{
#'   \item{inter}{Intercept}
#'   \item{slope}{Slope}
#'   \item{phi}{Dispersion}
#' }
#'
"ocean_survival_parameters"

#' Rearing time parameters
#'
#' Parameters for negative-binomial regression models for the Delta and Yolo Bypass.
#'
#' @format A named list ("Delta" or "Yolo") of named vectors:
#' \describe{
#'   \item{inter}{Intercept}
#'   \item{slope}{Slope for flood duration predictor (Yolo)}
#'   \item{flow}{Coefficient for flow predictor (Delta)}
#'   \item{fork_length}{Coefficient for fork length predictor (Delta)}
#'   \item{theta}{Dispersion}
#'   \item{passage_days}{Number of passage days to subtract from overall residence time (Yolo)}
#'   \item{theta}{Temperature threshold (ºC) at which fish stop rearing.}
#' }
#'
"rearing_time_parameters"

#' Rearing survival parameters
#'
#' Parameters that determine daily rearing survival for the Delta and Yolo Bypass.
#'
#' @format A named list ("Delta" or "Yolo") of named vectors:
#' \describe{
#'   \item{survival}{Daily survival for deterministic simulation (Delta)}
#'   \item{min}{Minimum daily survival drawm from uniform distribution (Delta). Minimum daily survival parameter in logistic function (Yolo).}
#'   \item{max}{Maximum daily survival drawm from uniform distribution (Delta). Maximum daily survival parameter in logistic function (Yolo).}
#'   \item{inflection}{Inflection parameter in logistic function (Yolo)}
#'   \item{steepness}{Steepness parameter in logistic function (Yolo)}
#' }
#'
"rearing_survival_parameters"

#' Rearing proportion parameters
#'
#' Parameters for a logistic function to determine the proportion of an entrained cohort that rears on the Yolo Bypass as a function of fork length.
#'
#' @format A named vector:
#' \describe{
#'   \item{min}{Minimum rearing proportion parameter in logistic function}
#'   \item{max}{Maximum rearing proportion parameter in logistic function}
#'   \item{inflection}{Inflection parameter in logistic function}
#'   \item{steepness}{Steepness parameter in logistic function}
#' }
#'
"rearing_proportion_parameters"

#' Growth parameters
#'
#' Parameters for Perry et al. 2015 growth model
#'
#' @format A named vector:
#' \describe{
#'   \item{b}{Allometric growth exponent}
#'   \item{d,g}{Shape parameters for the Ratkowsky growth model}
#'   \item{TL,TU}{Lower and upper temperature (ºC) limits for growth}
#' }
#'
"growth_parameters"

#' Annual abundance of outmigrants
#'
#' Annual outmigrant abundance that enters the model in the Sacramento River at Knights Landing
#' for each juvenile Chinook Salmon run in each year of the 15-yr model period.
#'
#' @format A named list of four named vectors:
#' \describe{
#'   \item{List names}{"Fall", "LateFall", "Spring", "Winter"}
#'   \item{Vector names}{"1997", "1998", ..., "2011"}
#' }
#' @examples
#' annual_abundance[["Fall"]][["2000"]]
#'
"annual_abundance"

#' Freeport temperature
#'
#' Daily temperature (ºC) in the Sacramento River at Freeport
#'
#' @format A list of 15 vectors of daily temperature values. One list element for each water year (1997-2011).
#' @examples
#' freeport_temperature[["2000"]][100:110]
#'
"freeport_temperature"

#' Toe Drain temperature
#'
#' Daily temperature (ºC) in the Toe Drain at the screw trap
#'
#' @format A list of 15 vectors of daily temperature values. One list element for each water year (1997-2011).
#' @examples
#' toe_drain_temperature[["2000"]][100:110]
#'
"toe_drain_temperature"


#' Floodplain temperature
#'
#' Daily temperature (ºC) on the floodplain (where floodplain is inclusive of any off-channel rearing habitat)
#'
#' @format A nested named list of 15 vectors of daily temperature values. One list element for each location (Delta, Yolo) and one sub-list element for each water year (1997-2011).
#' @examples
#' floodplain_temperature[["Delta"]][["2000"]][100:110]
#'
"floodplain_temperature"

#' Floodplain temperature difference
#'
#' Difference between in temperature between main channel and floodplain (where floodplain is inclusive of any off-channel rearing habitat)
#'
#' @format A nested named list of 15 vectors of daily temperature values. One list element for each location (Delta, Yolo) and one sub-list element for each water year (1997-2011).
#' @examples
#' floodplain_temperature_difference[["Yolo"]][["2000"]][200:210]
#'
"floodplain_temperature_difference"

#' Proportion of fish entrained onto the Yolo Bypass at Fremont Weir
#'
#' Proportion of fish entering the Yolo Bypass for each day of the 15-yr model period.
#'
#' @format A list of 15 vectors of daily entrainment proportions. One list element for each water year (1997-2011).
#' @examples
#' fremont_weir_proportion[["1998"]][105:115]
#'
"fremont_weir_proportion"

#' Flood duration
#'
#' Number of days where Yolo Bypass flows exceeded 4,000 cfs in a window of 120 days
#' from the date that cohort entered the Yolo Bypass.
#'
#' @format A list of 15 vectors of flood durations. One list element for each water year (1997-2011).
#' @examples
#' flood_duration[["1998"]][105:115]
#'
"flood_duration"

#' Freeport Flow
#'
#' Flow (cfs) in the Sacramento River at Freeport.
#'
#' @format A list of 15 vectors of flow values. One list element for each water year (1997-2011).
#' @examples
#' freeport_flow[["1998"]][105:115]
#'
"freeport_flow"

#' Inundated area
#'
#' Area (sq. km) inundated (depth > 0) on the Yolo Bypass for each day of the 15-yr model period.
#'
#' @format A list of 15 vectors of flow values. One list element for each water year (1997-2011).
#' @examples
#' inundated_sqkm[["1998"]][105:115]
#'
"inundated_sqkm"

#' Knights Landing entry timing
#'
#' Proportion of the population that enters the model in the Sacramento River at Knights Landing on each day of the 15-yr model period.
#'
#' @format Nested, named lists of vectors of daily values. One list element for each Chinook run (Fall, LateFall, Spring, Winter) and one sub-list element for each water year (1997-2011):
#' @examples
#' knights_landing_timing[["Spring"]][["1998"]][105:115]
#'
"knights_landing_timing"


#' Knights Landing fork length parameters
#'
#' Parameters used to draw fork lengths from lognormal distribution for cohorts entering the model
#' in the Sacramento River at Knights Landing on each day of the 15-yr model period.
#'
#' @format Nested, named lists of vectors of daily values. One list element for each Chinook run (Fall, LateFall, Spring, Winter),
#' one sub-list element for each water year (1997-2011), and one sub-sub-list for each parameter (MeanLog, SDLog):
#' @examples
#' knights_landing_fl_params[["Spring"]][["1998"]][["SDLog"]][105:115]
#'
"knights_landing_fl_params"


