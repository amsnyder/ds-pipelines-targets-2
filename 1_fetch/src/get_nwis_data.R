
download_nwis_data <- function(site_nums = c("01427207", "01432160", "01435000", "01436690", "01466500")){
  
  # create the file names that are needed for download_nwis_site_data
  # tempdir() creates a temporary directory that is wiped out when you start a new R session; 
  # replace tempdir() with "1_fetch/out" or another desired folder if you want to retain the download
  download_files <- file.path(tempdir(), paste0('nwis_', site_nums, '_data.csv'))
  data_out <- data.frame()
  # loop through files to download 
  for (download_file in download_files){
    download_nwis_site_data(download_file, parameterCd = '00010')
    # read the downloaded data and append it to the existing data.frame
    these_data <- read_csv(download_file, col_types = 'ccTdcc')
    data_out <- bind_rows(data_out, these_data)
  }
  return(data_out)
}

nwis_site_info <- function(fileout, site_data_csv){
  site_data <- read_csv(site_data_csv, col_types = 'ccTdcc')
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}


download_nwis_site_data <- function(site_num, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){
  
  # Create tmp data directory
  tmp_output_dir =  file.path('1_fetch', 'tmp')
  dir.create(tmp_output_dir, showWarnings = FALSE)
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  return(data_out)
}

concat_data <- function(data_in, out_file){
  data_out <- data.frame()
  # loop through files to download 
  for (these_data in data_in){
    # read the downloaded data and append it to the existing data.frame
    data_out <- bind_rows(data_out, these_data)
  }
  write_csv(data_out, file=out_file)
  return(out_file)
}