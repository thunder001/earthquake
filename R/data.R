
#' NOAA earthquake information
#' 
#' Information about 5,933 earthquakes over an approximately 4,000 year time span.
#'
#' @source The U.S. National Oceanographic and Atmospheric Administration (NOAA). 
#'   \url{https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1}
#' @format A data frame with 48 columns, 
#' note: only describe several important colunms used in these packages
#' \describe{
#' 
#' \item{YEAR}{A value between B.C. 2150 and 2017.}
#' \item{MONTH}{A value between 1 and 12.}
#' \item{DAY}{A value between 1 and 31.}
#' \item{EQ_PRIMARY}{Earthquake magnitude expressed as Richter scale value}
#' \item{TOTAL_DEATHS}{Total number of deaths during that earthquake.}
#' \item{COUNTRY}{Abbreviation for country name.}
#' \item{LOCATION_NAME}{Location for the earthquake.}
#' 
#' }
#' @examples
#' \dontrun{
#' eq_dat_clean
#' }
#' 
#' \dontrun{
#' Raw datfile access:
#' system.file("extdata", "signif.txt.tsv", "earthquake")
#' }
"eq_dat_clean"