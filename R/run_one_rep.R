#' Run one replicate of the model
#'
#' Run one replicate of the model; a replicate is a water_year/chinook_run combination
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param chinook_run          Run timing classification: Fall, LateFall, Winter, Spring
#'
#' @export
#'
#'

## probably would have take a different approach to storing output data if I was planning to incorporate Delta rearing from beginning
## approach that I'm using in Yolo section is very prone to typos
run_one_rep <- function(water_year_string, chinook_run){

  sim_type <- simulation_parameters[["sim_type"]]
  ocean_year_type <- ifelse(runif(1) < simulation_parameters[["ocean_year_probability"]],
                            "length", "intercept")

  knights_dates <- wy_dates[[water_year_string]]
  knights_dates_index <- 1:length(knights_dates)
  knights_abun <- initial_cohort_abundance(chinook_run, water_year_string, sim_type)
  knights_fl <- initial_cohort_fork_length(chinook_run, water_year_string, knights_dates_index, sim_type)
  knights_ww <- length_weight(knights_fl)

  # no travel time, mortality, or growth from Knights Landing to Fremont Weir
  entrain_list <- entrainment(water_year_string, knights_dates_index, knights_abun, sim_type)

  # Sacramento route
  sac <- data.frame(KnightsDate = knights_dates,
                    KnightsDateIndex = knights_dates_index,
                    KnightsAbun = knights_abun,
                    KnightsFL = knights_fl,
                    KnightsWW = knights_ww,
                    stringsAsFactors = FALSE)

  sac[["FremontAbun"]] <- entrain_list[["Sac"]]
  sac <- sac[sac[["FremontAbun"]] > 0,]

  if (nrow(sac) > 0){

    # Sacramento River passage
    sac_passage_list <- passage(water_year_string, sac[["KnightsDateIndex"]],
                                sac[["FremontAbun"]], sac[["KnightsFL"]],
                                route = "Sac", sim_type)

    sac[["DeltaDateIndex"]] <- sac[["KnightsDateIndex"]] + sac_passage_list[["PassageTime"]]
    sac[["DeltaAbun"]] <- sac_passage_list[["Abundance"]]

    # Delta rearing

    sac[["DeltaRearingTime"]] <- rearing_time_delta(water_year_string, sac[["DeltaDateIndex"]],
                                                    sac_passage_list[["PassageTime"]],
                                                    sac[["KnightsFL"]], sim_type)

    sac[["ChippsAbun"]] <- rearing_survival(water_year_string, sac[["DeltaDateIndex"]],
                                            sac[["DeltaAbun"]], sac[["DeltaRearingTime"]],
                                            location = "Delta", sim_type)

    sac[["ChippsFL"]] <- weight_length(rearing_growth(water_year_string, sac[["DeltaDateIndex"]],
                                                      sac[["DeltaRearingTime"]], "Delta",
                                                      sac[["KnightsWW"]]))

    # Ocean

    sac[["AdultReturns"]] <- ocean_survival(sac[["ChippsAbun"]],
                                            sac[["ChippsFL"]],
                                            ocean_year_type,
                                            sim_type)
  }else{
    sac = data.frame()
  }

  # Yolo route
  yolo <- data.frame(KnightsDate = knights_dates,
                     KnightsDateIndex = knights_dates_index,
                     KnightsAbun = knights_abun,
                     KnightsFL = knights_fl,
                     KnightsWW = knights_ww,
                     stringsAsFactors = FALSE)

  yolo[["FremontAbun"]] <- entrain_list[["Yolo"]]
  yolo <- yolo[yolo[["FremontAbun"]] > 0,]

  if (nrow(yolo) > 0){

    # Yolo Bypass rearing

    # YoloRearingAbun is proportion of cohorts that "decide" to rear on the Yolo Bypass multipled by abundance
    yolo[["YoloRearingAbun"]] <- rearing_abundance(yolo[["FremontAbun"]], yolo[["KnightsFL"]], sim_type)
    yolo[["YoloRearingTime"]] <- rearing_time_yolo(water_year_string, yolo[["KnightsDateIndex"]], sim_type)

    yolo[["PostYoloRearingAbun"]]  <- rearing_survival(water_year_string, yolo[["KnightsDateIndex"]],
                                                       yolo[["YoloRearingAbun"]], yolo[["YoloRearingTime"]],
                                                       location = "Yolo", sim_type)

    yolo[["PostYoloRearingFL"]] <- weight_length(rearing_growth(water_year_string, yolo[["KnightsDateIndex"]],
                                                                yolo[["YoloRearingTime"]], "Yolo",
                                                                yolo[["KnightsWW"]]))

    # Yolo Bypass passage

    # yolo passage for rearing individuals
    yolo_passage_rear <- passage(water_year_string, yolo[["KnightsDateIndex"]] + yolo[["YoloRearingTime"]],
                                 yolo[["PostYoloRearingAbun"]], yolo[["PostYoloRearingFL"]],
                                 route = "Yolo", sim_type)

    # yolo passage for non-rearing individuals
    yolo_passage_no_rear <- passage(water_year_string, yolo[["KnightsDateIndex"]],
                                    yolo[["FremontAbun"]] - yolo[["YoloRearingAbun"]],
                                    yolo[["KnightsFL"]],
                                    route = "Yolo", sim_type)

    yolo[["DeltaAbun_YoloRear"]] <- yolo_passage_rear[["Abundance"]]
    yolo[["DeltaAbun_YoloNoRear"]] <- yolo_passage_no_rear[["Abundance"]]

    yolo[["DeltaDateIndex_YoloRear"]] <- yolo[["KnightsDateIndex"]] + yolo[["YoloRearingTime"]] + yolo_passage_rear[["PassageTime"]]
    yolo[["DeltaDateIndex_YoloNoRear"]] <- yolo[["KnightsDateIndex"]] + yolo_passage_no_rear[["PassageTime"]]

    # Delta rearing
    yolo[["DeltaRearingTime_YoloRear"]] <- rearing_time_delta(water_year_string, yolo[["DeltaDateIndex_YoloRear"]],
                                                              yolo_passage_rear[["PassageTime"]],
                                                              yolo[["PostYoloRearingFL"]], sim_type)
    yolo[["DeltaRearingTime_YoloNoRear"]] <- rearing_time_delta(water_year_string, yolo[["DeltaDateIndex_YoloNoRear"]],
                                                                yolo_passage_no_rear[["PassageTime"]],
                                                                yolo[["KnightsFL"]], sim_type)

    yolo[["ChippsAbun_YoloRear"]] <- rearing_survival(water_year_string, yolo[["DeltaDateIndex_YoloRear"]],
                                                      yolo[["DeltaAbun_YoloRear"]], yolo[["DeltaRearingTime_YoloRear"]],
                                                      location = "Delta", sim_type)
    yolo[["ChippsAbun_YoloNoRear"]] <- rearing_survival(water_year_string, yolo[["DeltaDateIndex_YoloNoRear"]],
                                                      yolo[["DeltaAbun_YoloNoRear"]], yolo[["DeltaRearingTime_YoloNoRear"]],
                                                      location = "Delta", sim_type)

    yolo[["ChippsFL_YoloRear"]] <- weight_length(rearing_growth(water_year_string, yolo[["DeltaDateIndex_YoloRear"]],
                                                                yolo[["DeltaRearingTime_YoloRear"]], "Delta",
                                                                length_weight(yolo[["PostYoloRearingFL"]])))
    yolo[["ChippsFL_YoloNoRear"]] <- weight_length(rearing_growth(water_year_string, yolo[["DeltaDateIndex_YoloNoRear"]],
                                                                  yolo[["DeltaRearingTime_YoloNoRear"]], "Delta",
                                                                  yolo[["KnightsWW"]]))

    # Ocean

    yolo[["AdultReturns_YoloRear"]] <- ocean_survival(yolo[["ChippsAbun_YoloRear"]],
                                                      yolo[["ChippsFL_YoloRear"]],
                                                      ocean_year_type,
                                                      sim_type)
    yolo[["AdultReturns_YoloNoRear"]] <- ocean_survival(yolo[["ChippsAbun_YoloNoRear"]],
                                                        yolo[["ChippsFL_YoloNoRear"]],
                                                        ocean_year_type,
                                                        sim_type)
  }else{
    yolo = data.frame()
  }

  return(list("Sac" = sac, "Yolo" = yolo))
}

