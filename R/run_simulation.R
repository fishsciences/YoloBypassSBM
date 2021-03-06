#' Run simulation
#'
#' Run simulation based on simulation parameters. They typical workflow for running simulation is to reset_model_inputs(),
#' set (in the global environment) model input data and parameter for a simulation, and then use run_simulation().
#'
#' @md
#'
#' @export
#'
#'

run_simulation <- function(){

  params <- simulation_parameters
  set.seed(params[["random_seed"]])
  water_year_string <- as.character(params[["water_years"]])
  cat(params[["name"]], "\n")

  process_list <- function(input_list, col_name){
    list("Sac" = dplyr::bind_rows(lapply(input_list, "[[", "Sac"), .id = col_name),
         "Yolo" = dplyr::bind_rows(lapply(input_list, "[[", "Yolo"), .id = col_name))
  }

  # keeping Sac and Yolo separate because different number of columns
  rep_list <- list()
  for (i in params[["reps"]]){
    wy_list <- list()
    for (j in water_year_string){
      oyt <- draw_ocean_year_type()
      run_list <- list()
      for (k in params[["chinook_runs"]]){
        run_list[[k]] <- run_one_rep(water_year_string = j,
                                     chinook_run = k,
                                     ocean_year_type = oyt)
      }
      wy_list[[j]] <- process_list(run_list, "Run")
    }
    rep_list[[as.character(i)]] <- process_list(wy_list, "WaterYear")
    # carriage return, \r, allows for rewriting on same line
    cat("\r", "Rep", i, "of", max(params[["reps"]]))
  }
  cat("\n")  # expectation is that cursor will generally be placed on next line, but this is insurance
  if (!dir.exists("results")) dir.create("results")

  saveRDS(process_list(rep_list, "Rep"),
          file.path("results", paste0(params[["name"]],
                                      "-Reps-",
                                      min(params[["reps"]]),
                                      "-",
                                      max(params[["reps"]]),
                                      ".rds")))
}


