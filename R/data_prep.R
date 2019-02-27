
#' Clean the raw NOAA earquake data
#' 
#' This function performs two task: merge YEAR, MONTH, DAY into one DATE column
#' and convert LONGITUDE AND LATITUDE into numeric.
#' 
#' @param df an input dataframe
#' 
#' return a clean dataframe
#' 
#' @export

eq_clean_data <- function(df) {
  dates <- paste0(df$YEAR, "-", df$MONTH, "-", df$DAY)
  dates <- gsub("NA", "01", dates)
  DATE <- integer(length=length(dates))
  class(DATE) <- "Date" # change class type
  
  for (i in 1:length(dates)) {
    if (startsWith(dates[i], "-")) {
      # tricky for dealing with negative year
      DATE0 <- gsub("^-", "", dates[i])
      dif <- as.numeric(difftime("0000-01-01", DATE0))
      DATE[i] <- as.Date(dif, origin="0000-01-01")
      #print(DATE[i])
    } else {
      DATE[i] <- as.Date(dates[i])
    }
    
  }
  df$DATE <- DATE
  df$LATITUDE <- as.numeric(df$LATITUDE)
  df$LONGITUDE <- as.numeric(df$LONGITUDE)
  df$LOCATION_NAME <- eq_location_clean(df$LOCATION_NAME)
  df
}


#' Help function for cleanind raw data
#' 
#' This function speciallly extracts location information from
#' LOCATION_NAME column
#' 
#' @param loc LOCATION_NAME vector
#' 
#' return cleaned LOCATION_NAME
#' 
#' @export
eq_location_clean <- function(loc) {
  loc <- gsub(".*: *", "", loc)
  loc <- tolower(loc)
  re_from <- "\\b([[:lower:]])([[:lower:]]+)"
  loc <- gsub(re_from, "\\U\\1\\L\\2", loc, perl = TRUE)
  loc
}
