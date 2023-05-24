# PlasticMAP_2

pmap2_litrev <- openxlsx::read.xlsx(
  xlsxFile = "data/input/raw/PlasticMAP_2/LitRev_Chemicals_221122.xlsx",
  cols = c(4:5),
  na.strings = c("", " ", "nan")
)
colnames(pmap2_litrev) <- c("casrn", "substance")
pmap2_litrev <- cbind("pmap2_litrev_id" = 1:nrow(pmap2_litrev), pmap2_litrev)
pmap2_litrev <- transform(
  pmap2_litrev,
  "casrn" = trimws(gsub("'", "", casrn))
)

skimr::skim(pmap2_litrev) # 3550

pmap2_litrev <- transform(
  pmap2_litrev,
  "casrn" = ifelse(
    test = cleanventory:::.check_cas(casrn),
    yes = casrn,
    no = NA_character_
  )
)

skimr::skim(pmap2_litrev) # 3549

saveRDS(pmap2_litrev, "data/input/clean/PlasticMAP_2/pmap2_litrev.rds")

##

pmap2_litrev_cas <- subset(pmap2_litrev, subset = !is.na(casrn))
pmap2_litrev_no_cas <- subset(pmap2_litrev, subset = is.na(casrn))

# pmap2_litrev_cas_split <- split(pmap2_litrev_cas, f = ~ casrn)
pmap2_litrev_no_cas_split <- split(pmap2_litrev_no_cas, f = ~ substance)

pmap2_litrev_no_cas_clean <- do.call(
  what = "rbind",
  args = c(
    pbapply::pblapply(
      pmap2_litrev_no_cas_split,
      FUN = function(x) {
        res <- data.frame(
          "pmap2_litrev_id" = paste(x$pmap2_litrev_id, collapse = ";"),
          "casrn" = NA_character_,
          "substance" = unique(x$substance)
        )
        res
      }
    ),
    make.row.names = FALSE
  )
)

pmap2_litrev_clean <- rbind(pmap2_litrev_cas, pmap2_litrev_no_cas_clean)
row.names(pmap2_litrev_clean) <- NULL

skimr::skim(pmap2_litrev_clean)

saveRDS(pmap2_litrev_clean, "data/input/clean/PlasticMAP_2/pmap2_litrev_clean.rds")

rm(pmap2_litrev_cas, pmap2_litrev_cas_split, pmap2_litrev_no_cas, pmap2_litrev_no_cas_clean, pmap2_litrev_no_cas_split)

rm(pmap2_litrev)

##

pmap2_s10_raw <- openxlsx::read.xlsx(
  xlsxFile = "data/input/raw/PlasticMAP_2/PlasticMAP_Chemicals_220704.xlsx", 
  sheet = "S10 - all Substances",
  startRow = 8,
  cols = c(3:4, 12:18, 43:79),
  na.strings = c("", " ", "-", "NULL")
)
colnames(pmap2_s10_raw) <- c(
  "casrn", "name", "uvcb", "organic", "contains_metal", 
  "contains_silicon", "contains_phosphorus", "contains_sulfur", 
  "contains_halogen", "regulated", "relevant_regulations", "montreal", "us_ozone_depleting_substances",
  "eu_controlled_substances_montreal", "stockholm", "eu_pop_directive", "rotterdam",
  "eu_priority_informed_content", "reach_restriction", "reach_authorisation", 
  "reach_svhc", "rohs_directive", "toys_directive", "california_proposition_65",
  "cscl_class_i_restriction", "cscl_class_ii_authorization", "isha_restriction",
  "isha_authorization", "kr_reach_restriction", "kr_reach_authorisation", 
  "relevant_food_contact_positive_lists", "food_contact_positive_list",
  "eu_food_contact_materials_list", "usa_generally_recognized_as_safe", 
  "japan_food_contact_materials_list", 
  "use_function", "polymer", "industrial_sector", 
  "industrial_sector_food_contact", "number_of_regions", "regions", 
  "tonnage_eu", "tonnage_nordic_countries_spin", "tonnage_usa", "tonnage_oecd", 
  "tonnage_total"
)
pmap2_s10_raw <- cbind("pmap2_s10_id" = 1:nrow(pmap2_s10_raw), pmap2_s10_raw)
pmap2_s10_raw <- transform(
  pmap2_s10_raw,
  "casrn" = trimws(gsub("'", "", casrn))
)

skimr::skim(pmap2_s10_raw) # 10547

sapply(pmap2_s10_raw, \(x) sum(grepl(",", x))) # relevant_regulations, relevant_food_contact_positive_lists, use_function, polymer, industrial_sector, regions
sapply(pmap2_s10_raw, \(x) sum(grepl(";", x)))
sapply(pmap2_s10_raw, \(x) sum(grepl("\n", x)))
sapply(pmap2_s10_raw, \(x) sum(grepl("0.5", x)))

pmap2_s10_split <- split(pmap2_s10_raw, f = ~ pmap2_s10_id)

pmap2_s10 <- do.call(
  what = "rbind",
  args = c(
    pbapply::pblapply(
      pmap2_s10_split,
      FUN = function(x) {
        res <- x
        res <- transform(
          res,
          "uvcb" = as.integer(uvcb),
          "organic" = ifelse(organic == 0.5, NA_integer_, as.integer(organic)),
          "contains_metal" = as.integer(contains_metal),
          "contains_silicon" = as.integer(contains_silicon),
          "contains_phosphorus" = as.integer(contains_phosphorus),
          "contains_sulfur" = as.integer(contains_sulfur),
          "contains_halogen" = as.integer(contains_halogen),
          "regulated" = as.integer(regulated),
          "relevant_regulations" = ifelse(is.na(relevant_regulations), NA_character_, paste(trimws(unlist(strsplit(relevant_regulations, split = ","))), collapse = ";")),
          "montreal" = as.integer(montreal),
          "us_ozone_depleting_substances" = as.integer(us_ozone_depleting_substances),
          "eu_controlled_substances_montreal" = as.integer(eu_controlled_substances_montreal),
          "stockholm" = as.integer(stockholm),
          "eu_pop_directive" = as.integer(eu_pop_directive),
          "rotterdam" = as.integer(rotterdam),
          "eu_priority_informed_content" = as.integer(eu_priority_informed_content), 
          "reach_restriction" = as.integer(reach_restriction), 
          "reach_authorisation" = as.integer(reach_authorisation), 
          "reach_svhc" = as.integer(reach_svhc), 
          "rohs_directive" = as.integer(rohs_directive), 
          "toys_directive" = as.integer(toys_directive), 
          "california_proposition_65" = as.integer(california_proposition_65),
          "cscl_class_i_restriction" = as.integer(cscl_class_i_restriction), 
          "cscl_class_ii_authorization" = as.integer(cscl_class_ii_authorization), 
          "isha_restriction" = as.integer(isha_restriction),
          "isha_authorization" = as.integer(isha_authorization), 
          "kr_reach_restriction" = as.integer(kr_reach_restriction), 
          "kr_reach_authorisation" = as.integer(kr_reach_authorisation),
          "relevant_food_contact_positive_lists" = ifelse(is.na(relevant_food_contact_positive_lists), NA_character_, paste(trimws(unlist(strsplit(relevant_food_contact_positive_lists, split = ","))), collapse = ";")),
          "food_contact_positive_list" = as.integer(food_contact_positive_list),
          "eu_food_contact_materials_list" = as.integer(eu_food_contact_materials_list), 
          "usa_generally_recognized_as_safe" = as.integer(usa_generally_recognized_as_safe), 
          "japan_food_contact_materials_list" = as.integer(japan_food_contact_materials_list), 
          "use_function" = ifelse(is.na(use_function), NA_character_, paste(trimws(unlist(strsplit(use_function, split = ","))), collapse = ";")), 
          "polymer" = ifelse(is.na(polymer), NA_character_, paste(trimws(unlist(strsplit(polymer, split = ","))), collapse = ";")), 
          "industrial_sector" = ifelse(is.na(industrial_sector), NA_character_, paste(trimws(unlist(strsplit(industrial_sector, split = ","))), collapse = ";")), 
          "industrial_sector_food_contact" = as.integer(industrial_sector_food_contact), 
          "number_of_regions" = as.integer(number_of_regions), 
          "regions" = ifelse(is.na(regions), NA_character_, paste(trimws(unlist(strsplit(regions, split = ","))), collapse = ";")), 
          "tonnage_eu" = ifelse(tonnage_eu == -1, NA_integer_, as.integer(tonnage_eu)), 
          "tonnage_nordic_countries_spin" = ifelse(tonnage_nordic_countries_spin == 0.5, NA_integer_, as.integer(tonnage_nordic_countries_spin)), 
          "tonnage_usa" = ifelse(tonnage_usa == -1, NA_integer_, as.integer(tonnage_usa)), 
          "tonnage_oecd" = ifelse(tonnage_oecd == -1, NA_integer_, as.integer(tonnage_oecd)), 
          "tonnage_total" = ifelse(tonnage_total == -1, NA_integer_, as.integer(tonnage_total))
        )
        res
      }
    ),
    make.row.names = FALSE
  )
)

skimr::skim(pmap2_s10) # 2486

pmap2_s10 <- transform(
  pmap2_s10,
  "casrn" = ifelse(
    test = cleanventory:::.check_cas(casrn),
    yes = casrn,
    no = NA_character_
  )
)

skimr::skim(pmap2_s10) # 

saveRDS(pmap2_s10, "data/input/clean/PlasticMAP_2/pmap2_s10.rds")

rm(pmap2_s10_raw, pmap2_s10_split)

###

pmap2_litrev_sub <- subset(pmap2_litrev_clean, subset = (!is.na(casrn) & !(casrn %in% pmap2_s10$casrn)) | (is.na(casrn) & !(substance %in% pmap2_s10$name)), select = -c(pmap2_litrev_id))
# colnames(pmap2_litrev_sub)[2] <- "name" 

pmap2 <- merge(
  pmap2_s10, 
  pmap2_litrev_sub,
  by.x = c("casrn", "name"),
  by.y = c("casrn", "substance"),
  all.x = TRUE,
  all.y = TRUE
)

saveRDS(pmap2, "data/input/clean/PlasticMAP_2/pmap2.rds")

rm(pmap2_litrev_clean, pmap2_litrev_sub, pmap2_s10)
