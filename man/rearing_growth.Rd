% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rearing_growth.R
\name{rearing_growth}
\alias{rearing_growth}
\title{Rearing growth}
\usage{
rearing_growth(water_year_string, date_index, duration, location, wet_weight)
}
\arguments{
\item{water_year_string}{Water year (1997-2011) as a string}

\item{date_index}{Index of date in a water year at start of rearing period; in all years except WY1997, equivalent to day of water year}

\item{duration}{Duration (days) of rearing period}

\item{location}{Rearing location: Yolo or Delta}

\item{wet_weight}{Wet weight (g) at start of rearing period}
}
\description{
Returns final wet_weight given initial wet_weight, model day, and duration
}
