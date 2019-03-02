
#' Compute subset of data
#' 
#' The timeline statistic subsets the data
#' 
#' @param xmin Start date
#' @param xmax End date
#' @inheritParams geom_timeline

#' @export
stat_timeline <- function(mapping = NULL, data = NULL, xmin=NULL, xmax=NULL, geom = "Timeline",
                          position = "identity", show.legend = NA, 
                          na.rm=FALSE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatTimeline,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm=na.rm, xmin=xmin, xmax=xmax,...)
  )
}


#' Timeline Stat
#'
#' @importFrom ggplot2 ggproto 
#' @importFrom dplyr filter
#'
#' @export

StatTimeline <- ggplot2::ggproto("StatTimeline", ggplot2::Stat,
                        compute_panel = function(data, scales, xmin, xmax) {
                          #print(head(data))
                          #print(xmin)
                          out <- dplyr::filter(data, x > xmin & x < xmax)
                          #str(out)
                          #print(head(out))
                          out
                          
                        },
                        required_aes = c("x")
)