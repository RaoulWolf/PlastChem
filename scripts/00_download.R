# CPPdb
## https://zenodo.org/record/1287773

cpp_url <- paste(
  "https://zenodo.org/record/1287773/files",
  "CPPdb_ListA_ListB_181009_ZenodoV1.xlsx?download=1",
  sep = "/"
)

download.file(
  url = cpp_url,
  destfile = "data/raw/CPPdb/CPPdb_ListA_ListB_181009_ZenodoV1.xlsx",
  mode = "wb"
)

# FCCdb
## https://zenodo.org/record/3240109

fcc_url <- paste(
  "https://zenodo.org/record/3240109/files",
  "FCCdb_190607_v1_zenodo.xlsx?download=1",
  sep = "/"
)

download.file(
  url = fcc_url,
  destfile = "data/raw/FCCdb/FCCdb_190607_v1_zenodo.xlsx",
  mode = "wb"
)

# PlasticMAP
## https://pubs.acs.org/doi/full/10.1021/acs.est.1c00976

pmap_url <- paste(
  "https://pubs.acs.org/doi/suppl/10.1021/acs.est.1c00976",
  "suppl_file/es1c00976_si_001.zip",
  sep = "/"
)

download.file(
  url = pmap_url,
  destfile = "data/raw/PlasticMAP/es1c00976_si_001.zip",
  mode = "wb"
)

unzip(
  zipfile = "data/raw/PlasticMAP/es1c00976_si_001.zip",
  exdir = "data/raw/PlasticMAP"
)

# ECHA db
## https://echa.europa.eu/plastic-material-food-contact
## the file needs to be manually downloaded :(
## the .xlsx file is _much_ better formatted than the .csv file
