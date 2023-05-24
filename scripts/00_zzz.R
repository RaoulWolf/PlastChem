# setup the necessary folders

dir.create("data")
dir.create("data/input")
dir.create("data/input/raw")
dir.create("data/input/raw/Aurisano")
dir.create("data/input/raw/CPPdb")
dir.create("data/input/raw/ECHA_db")
dir.create("data/input/raw/FCCdb")
dir.create("data/input/raw/FCCmigex") # confidential
dir.create("data/input/raw/PlasticMAP")
dir.create("data/input/raw/PlasticMAP_2") # confidential

dir.create("data/input/clean")
dir.create("data/input/clean/Aurisano")
dir.create("data/input/clean/CPPdb")
dir.create("data/input/clean/ECHA_db")
dir.create("data/input/clean/FCCdb")
dir.create("data/input/clean/FCCmigex") # confidential
dir.create("data/input/clean/PlasticMAP")
dir.create("data/input/clean/PlasticMAP_2") # confidential

# check if necessary packages are installed

if(any(!(c("openxlsx", "pbapply", "skimr") %in% installed.packages()))) {
  install.packages(
    c("openxlsx", "pbapply", "skimr")[
      !(c("openxlsx", "pbapply", "skimr") %in% installed.packages())
    ]
  )
}

if(any(!(c("cleanventory", "pcapi") %in% installed.packages()))) {
  if(!("remotes" %in% installed.packages())) {
    install.packages("remotes")
  }
  remotes::install_github("RaoulWolf/cleanventory")
  remotes::install_github("RaoulWolf/pcapi")
}
