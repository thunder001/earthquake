
library(testthat)
library(earthquake)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
context("Test functions in the package")

fname <- system.file("extdata", "signif.txt.tsv", package = "earthquake")
eq_dat_raw <- as.data.frame(read_tsv(fname)) 
eq_dat_clean <- eq_clean_data(eq_dat_raw)

test_that("eq_clean_data", {
  
  expect_that(eq_dat_clean, is_a("data.frame"))
  expect_that(eq_dat_clean$DATE, is_a("Date"))
})



test_that("eq_location_clean", {
  loc <- eq_location_clean(eq_dat_raw$LOCATION_NAME)
  expect_that(!grepl("\\:",loc[1]), is_true())
})


test_that("geom_timeline", {
  
  dat <- select(eq_dat_clean, DATE, COUNTRY, LOCATION_NAME, LONGITUDE, LATITUDE,
                EQ_MAG_MS, EQ_PRIMARY, TOTAL_DEATHS) %>%
    filter(COUNTRY %in% c("USA", "CHINA"))
  
  p <- ggplot(dat, aes(x=DATE, 
                       size=as.numeric(EQ_PRIMARY),
                       fill=as.numeric(TOTAL_DEATHS),
                       y=COUNTRY)) +
    geom_timeline(xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01")) +
    scale_fill_gradient(name="# Total deaths") +
    scale_size_continuous(name="Richter scale value") +
    theme_timeline
  
  expect_that(p$layers[[1]]$geom, is_a("GeomTimeline"))
})


test_that("geom_timeline_label", {
  
  dat <- select(eq_dat_clean, DATE, COUNTRY, LOCATION_NAME, LONGITUDE, LATITUDE, 
                EQ_MAG_MS, EQ_PRIMARY, TOTAL_DEATHS) %>%
    filter(COUNTRY %in% c("USA", "CHINA"))
  
  
  p <- ggplot(data = dat, aes(x=DATE, 
                              size=as.numeric(EQ_PRIMARY),
                              fill=as.numeric(TOTAL_DEATHS),
                              y=COUNTRY)) +
    geom_timeline(xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01"), stat="Timeline") +
    geom_timeline_label(aes(label = LOCATION_NAME),n_max=5, xmin=as.Date("2000-01-01"), xmax=as.Date("2017-01-01")) +
    scale_fill_gradient(name="# Total deaths") +
    scale_size_continuous(name="Richter scale value") +
    theme_timeline
  
  expect_that(p$layers[[2]]$geom, is_a("GeomTimelineLabel"))
  
  
})


test_that("theme_timeline", {
  
  dat <- data.frame(x=1:100, y=rnorm(100))
  p <- ggplot(data=dat, aes(x, y)) +
    geom_point() +
    theme_timeline
  expect_that(p$theme, is_a("theme"))
})


test_that("eq_map", {
  m <- eq_dat_clean %>% 
    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>% 
    eq_map(annot_col = "DATE")
  expect_that(m, is_a("leaflet"))
})


test_that("eq_create_label", {
    popup_text = eq_create_label(eq_dat_clean)
    expect_that(popup_text, is_a("character"))
    #expect_that(popup_text, matches("Location|Magnitude|Total deaths")
})

