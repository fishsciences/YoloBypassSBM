% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ocean_survival.R
\name{ocean_survival}
\alias{ocean_survival}
\title{Number of adults returning from ocean}
\usage{
ocean_survival(
  abundance,
  fork_length,
  ocean_year_type = c("length", "intercept")
)
}
\arguments{
\item{abundance}{Abundance of cohort at esturary entry}

\item{fork_length}{Average fork length (mm) of cohort at estuary entry (Chipps Island)}

\item{ocean_year_type}{Type of ocean survival relationship used for that year: length or intercept}
}
\description{
Number of adults returning from ocean after three years
}
