#' Passage survival and time from Fremont Weir to Chipps Island
#'
#' Passage survival and time (days) from Fremont Weir to Chipps Island based on fork length, flow, and route
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year that cohort begins passage; in all years except WY1997, equivalent to day of water year
#' @param abundance            Abundance of cohort on day route entered
#' @param fork_length          Fork length (mm) at Fremont Weir
#' @param route                Route: Sacramento River (Sac) or Yolo Bypass (Yolo)
#'
#' @export
#'
#'

passage <- function(water_year_string, date_index, abundance, fork_length, route = c("Sac", "Yolo")){

  flow <- freeport_flow[[water_year_string]][date_index]
  list("Abundance" = passage_survival(abundance, fork_length, flow, route),
       "PassageTime" = passage_time(fork_length, flow, route))
}



