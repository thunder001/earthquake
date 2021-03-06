% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_timelinelabel.R
\name{geom_timeline_label}
\alias{geom_timeline_label}
\title{TimelineLabel}
\usage{
geom_timeline_label(mapping = NULL, data = NULL, n_max = NULL,
  xmin = NULL, xmax = NULL, geom = "TimelineLabel",
  position = "identity", stat = "Timeline", show.legend = NA,
  na.rm = FALSE, inherit.aes = TRUE, ...)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by [aes()] or
[aes_()]. If specified and `inherit.aes = TRUE` (the
default), it is combined with the default mapping at the top level of the
plot. You must supply `mapping` if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
   options:

   If `NULL`, the default, the data is inherited from the plot
   data as specified in the call to [ggplot()].

   A `data.frame`, or other object, will override the plot
   data. All objects will be fortified to produce a data frame. See
   [fortify()] for which variables will be created.

   A `function` will be called with a single argument,
   the plot data. The return value must be a `data.frame`, and
   will be used as the layer data.}

\item{n_max}{number of top n earquakes}

\item{xmin}{Stard date}

\item{xmax}{End date}

\item{geom}{The geometric object to use display the data}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{stat}{The statistical transformation to use on the data for this
layer, as a string.}

\item{show.legend}{logical. Should this layer be included in the legends?
`NA`, the default, includes if any aesthetics are mapped.
`FALSE` never includes, and `TRUE` always includes.
It can also be a named logical vector to finely select the aesthetics to
display.}

\item{na.rm}{If `FALSE`, the default, missing values are removed with
a warning. If `TRUE`, missing values are silently removed.}

\item{inherit.aes}{If `FALSE`, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. [borders()].}

\item{...}{Additional parameters to the `geom` and `stat`.}
}
\description{
TimelineLabel geom displays a time series event with labels on it
}
\examples{
fname <- system.file("extdata", "signif.txt.tsv", package = "earthquake")
eq_dat_raw <- as.data.frame(readr::read_tsv(fname)) 
eq_dat_clean <- eq_clean_data(eq_dat_raw)
dat <- dplyr::select(eq_dat_clean, DATE, COUNTRY, LOCATION_NAME, LONGITUDE, LATITUDE, 
              EQ_MAG_MS, EQ_PRIMARY, TOTAL_DEATHS)
dat <- dplyr::filter(dat,COUNTRY \%in\% c("USA", "CHINA"))


p <- ggplot2::ggplot(data = dat, ggplot2::aes(x=DATE, 
                               size=as.numeric(EQ_PRIMARY),
                               fill=as.numeric(TOTAL_DEATHS),
                              y=COUNTRY)) 
p +  geom_timeline(xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01"), stat="Timeline") +
  geom_timeline_label(ggplot2::aes(label = LOCATION_NAME),n_max=5, 
  xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01")) +
  ggplot2::scale_fill_gradient(name="# Total deaths") +
  ggplot2::scale_size_continuous(name="Richter scale value") +
  theme_timeline
}
