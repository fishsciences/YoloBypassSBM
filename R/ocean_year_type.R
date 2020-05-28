#' Ocean year type
#'
#' Determine whether ocean year type is length or intercept; used in ocean survival relationship
#'
#' @md
#'
#' @export
#'
#'

ocean_year_type <- function(){

  prob <-simulation_parameters[["ocean_year_probability"]]

  if (simulation_parameters[["sim_type"]] == "stochastic"){
    oyt <- ifelse(runif(1) < prob, "length", "intercept")
  } else {
    if (!(prob %in% 0:1)){
      prob <- round(prob)
      warning("sim_type set as deterministic; ocean_year_probability rounded to ", prob)
    }
    oyt <- ifelse(prob == 1, "length", "intercept")
  }
  oyt
}
