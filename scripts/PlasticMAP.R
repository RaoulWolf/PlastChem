# PlasticMAP

pmap_s8 <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/PlasticMAP/PlasticMAP_S1_210611.xlsx",
  sheet = "S8 - PlasticMAP",
  startRow = 6,
  cols = 2:4,
  na.strings = c(" ", "-")
)
colnames(pmap_s8) <- c("pmap_s8_id", "casrn", "name")

pmap_s8 <- transform(
  pmap_s8,
  pmap_s8_id = as.integer(pmap_s8_id),
  casrn = ifelse(
    cleanventory:::.check_cas(trimws(gsub("'", "", casrn))),
    trimws(gsub("'", "", casrn)),
    NA_character_
  )
)

saveRDS(pmap_s8, "data/clean/PlasticMAP/PlasticMAP.rds")

# CPPdb List B

pmap_s9 <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/PlasticMAP/PlasticMAP_S1_210611.xlsx",
  sheet = "S9 - SopC",
  startRow = 8,
  cols = 2:4,
  na.strings = c(" ", "-")
)
colnames(pmap_s9) <- c("pmap_s9_id", "casrn", "name")

pmap_s9 <- transform(
  pmap_s9,
  pmap_s9_id = as.integer(pmap_s9_id),
  casrn = ifelse(
    cleanventory:::.check_cas(trimws(casrn)),
    trimws(casrn),
    NA_character_
  )
)

saveRDS(pmap_s9, "data/clean/PlasticMAP/SopC.rds")
