% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{rearing_survival_parameters}
\alias{rearing_survival_parameters}
\title{Rearing survival parameters}
\format{
A named list ("Delta" or "Yolo") of named vectors:
\describe{
  \item{survival}{Daily survival for deterministic simulation (Delta)}
  \item{min}{Minimum daily survival drawm from uniform distribution (Delta). Minimum daily survival parameter in logistic function (Yolo).}
  \item{max}{Maximum daily survival drawm from uniform distribution (Delta). Maximum daily survival parameter in logistic function (Yolo).}
  \item{inflection}{Inflection parameter in logistic function (Yolo)}
  \item{steepness}{Steepness parameter in logistic function (Yolo)}
}
}
\usage{
rearing_survival_parameters
}
\description{
Parameters that determine daily rearing survival for the Delta and Yolo Bypass.
}
\keyword{datasets}
