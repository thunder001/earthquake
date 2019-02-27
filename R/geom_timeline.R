#' Timeline
#'
#' The Timeline geom is used to display time series events ranging from one
#' time point to another time point
#' 
#' @import ggplot2
#' @import dplyr
#' 
#' @param mapping Set of aesthetic mappings created by [aes()] or
#'   [aes_()]. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to [ggplot()].
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    [fortify()] for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame`, and
#'    will be used as the layer data.
#' @param geom The geometric object to use display the data
#' @param stat The statistical transformation to use on the data for this
#'    layer, as a string.
#' @param position Position adjustment, either as a string, or the result of
#'  a call to a position adjustment function.
#' @param show.legend logical. Should this layer be included in the legends?
#'   `NA`, the default, includes if any aesthetics are mapped.
#'   `FALSE` never includes, and `TRUE` always includes.
#'   It can also be a named logical vector to finely select the aesthetics to
#'   display.
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param inherit.aes If `FALSE`, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behaviour from
#'   the default plot specification, e.g. [borders()].
#' @param ... Additional parameters to the `geom` and `stat`.
#' @
#' 
#' @export
#' @examples
#' dat <- dplyr::select(eq_dat_clean, DATE, COUNTRY, LOCATION_NAME, LONGITUDE, LATITUDE,
#'               EQ_MAG_MS, EQ_PRIMARY, TOTAL_DEATHS) 
#' dat <- dplyr::filter(dat, COUNTRY %in% c("USA", "CHINA"))
#'  
#' p <- ggplot2::ggplot(dat, ggplot2::aes(x=DATE, 
#'                      size=as.numeric(EQ_PRIMARY),
#'                      fill=as.numeric(TOTAL_DEATHS),
#'                      y=COUNTRY))
#' p + geom_timeline(xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01")) +
#' ggplot2::scale_fill_gradient(name="# Total deaths") +
#' ggplot2::scale_size_continuous(name="Richter scale value") +
#'  theme_timeline

geom_timeline <- function(mapping = NULL, data = NULL, geom = "Timeline",
                          position = "identity", stat = "Timeline",show.legend = NA,
                          na.rm = FALSE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    
    data = data,
    mapping = mapping,
    geom = geom,
    stat=stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}


#' @rdname ggplot2-ggproto
#' @import ggplot2
#' @format NULL
#' @usage NULL
#' @export
GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::Geom,
                        required_aes = c("x"),
                        default_aes = ggplot2::aes(fill ="grey", size=3, color="grey",
                                                   alpha = 0.3, shape = 21, stroke=0.5),
                        # default_aes = ggplot2::aes(fill = "grey", size = 1.5, color="grey",
                        #                            alpha = 0.5, shape = 21,  stroke=0.5),
                        draw_key = ggplot2::draw_key_point,
                        #draw_panel = draw_panel_function
                        
                        draw_panel = function(data, panel_scales, coord) {
                          #print(data)
                          if (!("y" %in% names(data))) {
                            data$y = 0.5
                          }
                          
                          coords = coord$transform(data, panel_scales)
                          
                          #print(head(coords))
                          
                          points <- grid::pointsGrob(x=coords$x,
                                                     y=coords$y,
                                                     pch=coords$shape,
                                                     size=unit(coords$size/3, "char"),
                                                     gp=grid::gpar(col=coords$fill,
                                                             fill = coords$fill,
                                                             alpha = coords$alpha
                                                     )
                          )
                          
                          
                          
                          y_lines <- unique(coords$y)
                          
                          lines <- grid::polylineGrob(
                            x = unit(rep(c(0, 1), each = length(y_lines)), "npc"),
                            y = unit(c(y_lines, y_lines), "npc"),
                            id = rep(seq_along(y_lines), 2),
                            gp = grid::gpar(col = "grey",
                                            lwd = .pt)
                          )
                          
                          grid::gList(points, lines)
                          
                        }
)


#' Timeline theme
#' 
#' New theme for earthquake  timeline
#' 
#' @export
theme_timeline <- ggplot2::theme(plot.background = ggplot2::element_blank(),
                        panel.background = ggplot2::element_blank(),
                        axis.title.x = ggplot2::element_text(size = 20),   
                        axis.text = ggplot2::element_text(size = 15),
                        
                        axis.line.x = ggplot2::element_line(size = 1),
                        axis.title.y = ggplot2::element_blank(),
                        axis.ticks.y = ggplot2::element_blank(),
                        axis.line.y = ggplot2::element_blank(),
                        
                        legend.position = "bottom")
