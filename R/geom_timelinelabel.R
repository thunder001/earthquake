#' TimelineLabel
#' 
#' TimelineLabel geom displays a time series event with labels on it
#' 
#' @import dplyr 
#' @param xmin Stard date
#' @param xmax End date
#' @param n_max number of top n earquakes
#' @inheritParams geom_timeline
#' 
#' @export
#' @examples 
#' dat <- dplyr::select(eq_dat_clean, DATE, COUNTRY, LOCATION_NAME, LONGITUDE, LATITUDE, 
#'               EQ_MAG_MS, EQ_PRIMARY, TOTAL_DEATHS)
#' dat <- dplyr::filter(dat,COUNTRY %in% c("USA", "CHINA"))
#' 
#' 
#' p <- ggplot2::ggplot(data = dat, ggplot2::aes(x=DATE, 
#'                                size=as.numeric(EQ_PRIMARY),
#'                                fill=as.numeric(TOTAL_DEATHS),
#'                               y=COUNTRY)) 
#' p +  geom_timeline(xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01"), stat="Timeline") +
#'   geom_timeline_label(ggplot2::aes(label = LOCATION_NAME),n_max=5, 
#'   xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01")) +
#'   ggplot2::scale_fill_gradient(name="# Total deaths") +
#'   ggplot2::scale_size_continuous(name="Richter scale value") +
#'   theme_timeline


geom_timeline_label <- function(mapping = NULL, data = NULL, n_max =NULL, xmin=NULL, xmax=NULL,geom = "TimelineLabel",
                                position = "identity", stat = "Timeline",show.legend = NA,
                                na.rm = FALSE,  inherit.aes = TRUE, ...) {
  ggplot2::layer(
    
    data = data,
    mapping = mapping,
    geom = geom,
    stat=stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, n_max=n_max, xmin=xmin, xmax=xmax,...)
  )
}


#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomTimelineLabel <- ggplot2::ggproto("GeomTimelineLabel", ggplot2::Geom,
                             required_aes = c("x", "label"),
                             default_aes = ggplot2::aes(color="grey"),
                             draw_key = ggplot2::draw_key_point,
                             #draw_panel = draw_panel_function
                             
                             draw_panel = function(data, panel_scales, coord, n_max, xmin, xmax) {
                               
                               # Step 1: get data
                               #print("label starts ....")
                               #print(head(data))
                               if (!("y" %in% names(data))) {
                                 data$y = 0.5
                               }
                               
                               # if (length(unique(group)) > 1) {
                               #   
                               # }
                               
                               data <- group_by(data, group) %>%
                                 top_n(n_max, size) %>%
                                 ungroup
                               
                               # if (nrow(data) < n_max) {
                               #   n_max <- nrow(data)
                               # }
                               
                               #data <- data[1:n_max, ]
                               coords = coord$transform(data, panel_scales) 
                               
                               #print(head(coords))
                               
                               
                               # Step 2: draw line
                               x <- coords$x
                               x_end <- coords$x
                               y <- coords$y
                               y_end <- coords$y + 0.1
                               segments <- grid::segmentsGrob(
                                 x0=x, x1=x_end, y0=y, y1=y_end
                               )
                               # Step 3: draw label
                               labels <- grid::textGrob(label= coords$label,
                                                  x=x, y=y_end, rot = 45, just = c("left", "bottom"))
                               
                               grid::gList(segments, labels)
                               
                             }
)
