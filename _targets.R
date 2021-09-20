library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

parameter_code = '00010'
start_date = "2014-05-01"
end_date = "2015-05-01"

p1_targets_list <- list(
  tar_target(
    site_data_01427207,
    download_nwis_site_data("01427207", parameterCd = parameter_code, startDate=start_date, endDate=end_date),
  ),
  tar_target(
    site_data_01432160,
    download_nwis_site_data("01432160", parameterCd = parameter_code, startDate=start_date, endDate=end_date),
  ),
  tar_target(
    site_data_01435000,
    download_nwis_site_data("01435000", parameterCd = parameter_code, startDate=start_date, endDate=end_date),
  ),
  tar_target(
    site_data_01436690,
    download_nwis_site_data("01436690", parameterCd = parameter_code, startDate=start_date, endDate=end_date),
  ),
  tar_target(
    site_data_01466500,
    download_nwis_site_data("01466500", parameterCd = parameter_code, startDate=start_date, endDate=end_date),
  ),
  tar_target(
    site_data,
    concat_data(data_in = list(site_data_01427207, site_data_01432160, site_data_01435000, site_data_01436690, site_data_01466500)),
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_styled, 
    process_data(site_data, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
