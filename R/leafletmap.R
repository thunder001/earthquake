

#' leaflet map to show column informtion
#' 
#' This interactive map can show earquake information on popup
#'  accoring to given column 
#' 
#' @import leaflet
#' @param dat an imput dataframe
#' @param annot_col a string representing colume
#' 
#' @return An interactive map with information shown
#'  on popup
#'  
#' @export


eq_map <- function(dat, annot_col) {
  leaflet::leaflet() %>%
    leaflet::addProviderTiles("OpenStreetMap.Mapnik") %>%
    leaflet::addCircleMarkers(data=dat, lng=~LONGITUDE, 
                     lat=~LATITUDE, radius=~EQ_PRIMARY,
                     popup=~paste(get(annot_col)) )
  
}



#' Create popup information
#' 
#' This function generates html formated earthquake information by conbination 
#' three types of data, including location, magnitude and number of total deaths.
#' 
#' @import tidyr
#' @import dplyr
#' @param dat an imput dataframe
#' 
#' @return an interactive map with three types of information on popup if existing.
#' 
#' @export
#' 


eq_create_label <- function(dat) {
  
  popup_info <- character(length=nrow(dat))
  
  for (i in 1:nrow(dat)) {
    location <- dat$LOCATION_NAME[i]
    magnitude <- dat$EQ_PRIMARY[i]
    deaths <- dat$TOTAL_DEATHS[i]
    
    if (!is.na(location)) {
      info1 <- paste("<b>Location:</b>", location, "<br />")
      popup_info[i] <- paste(popup_info[i], info1)
    }
    if (!is.na(magnitude)) {
      info2 <- paste("<b>Magnitude:</b>", magnitude, "<br />")
      popup_info[i] <- paste(popup_info[i], info2)
    }
    if (!is.na(deaths)) {
      info3 <- paste("<b>Total deaths:</b>", deaths, "<br />")
      popup_info[i] <- paste(popup_info[i], info3)
    }
    
  }
  
  popup_info
  
}

