% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wnba_pbp.R
\name{load_wnba_player_box}
\alias{load_wnba_player_box}
\title{\strong{Load wehoop WNBA player box scores}}
\usage{
load_wnba_player_box(seasons, ..., qs = FALSE)
}
\arguments{
\item{seasons}{A vector of 4-digit years associated with given WNBA seasons.}

\item{...}{Additional arguments passed to an underlying function that writes
the season data into a database (used by \code{update_wnba_db()}).}

\item{qs}{Wheter to use the function \code{\link[qs:qdeserialize]{qs::qdeserialize()}} for more efficient loading.}
}
\description{
helper that loads multiple seasons from the data repo either into memory
or writes it into a db using some forwarded arguments in the dots
}
\examples{
\dontrun{
future::plan("multisession")
load_wnba_player_box(2002:2021)
}
}
