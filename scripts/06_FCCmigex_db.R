# Fccmigex_db

fccmigex_raw <- openxlsx::read.xlsx(
  xlsxFile = "data/input/raw/FCCmigex_db/2023.01.30_FCCmigex_FCCs from plastics_PlastChem.xlsx",
  cols = c(1, 4:7, 9, 14),
  na.strings = c("", "-", " ")
)
colnames(fccmigex_raw) <- c(
  "fcc_main", "fcm_main", "fcm_focus", "experiment", "detected", "cas_id_final", 
  "fcm_content"
)
fccmigex_raw <- cbind("fccmigex_id" = 1:nrow(fccmigex_raw), fccmigex_raw)
fccmigex_raw <- transform(
  fccmigex_raw,
  "detected" = ifelse(
    test = grepl("Yes", detected), 
    yes = 1L, 
    no = ifelse(
      test = grepl("No", detected),
      yes = 0L,
      no = NA_integer_
    )
  ),
  "cas_id_final" = gsub("'", "", cas_id_final)
)
sapply(fccmigex_raw, \(x) sum(grepl(";", x))) # 11 ";" in fcc_main, 10 in fcc_synonym, 6 in common_name, 8 in common_syn
sapply(fccmigex_raw, \(x) sum(grepl(",", x))) # 9 "," in cas_id_final

skimr::skim(fccmigex_raw)

fccmigex_split <- split(fccmigex_raw, f = ~ fccmigex_id)

fccmigex <- do.call(
  what = "rbind",
  args = c(
    pbapply::pblapply(
      fccmigex_split,
      FUN = function(x) {
        if(is.na(x$cas_id_final)) {
          n_cas_id_final <- NA_character_
        } else {
          n_cas_id_final <- trimws(na.omit(unlist(strsplit(x$cas_id_final, split = ","))))
          if(any(nchar(n_cas_id_final) == 0L)) {
            n_cas_id_final <- NA_character_
          }
        }
        res <- data.frame(
          "fccmigex_id" = x$fccmigex_id,
          "fcc_main" = paste(trimws(unlist(strsplit(x$fcc_main, split = ";"))), collapse = ";"),
          "fcm_main" = x$fcm_main,
          "fcm_focus" = x$fcm_focus,
          "experiment" = x$experiment,
          "detected" = x$detected,
          "cas_id_final" = n_cas_id_final,
          "fcm_content" = x$fcm_content,
          stringsAsFactors = FALSE
        )
        res
      }
    ),
    make.row.names = FALSE
  )
)

# m-, p-Xylene
# SD
# dechlorane plus isomers
# p,m-Xylene

# subset(fccmigex, fcc_main == "m-, p-Xylene")
# subset(fccmigex_new, fcc_main == "m-, p-Xylene")

skimr::skim(fccmigex) # 1348 CAS missing # 3241

fccmigex <- transform(
  fccmigex,
  "cas_id_final" = ifelse(
    test = cleanventory:::.check_cas(cas_id_final),
    yes = cas_id_final,
    no = NA_character_
  )
)

skimr::skim(fccmigex)

# 15'249 entries
#  1'348 entries with missing CAS Registry Numbers ( 9%)
#     62 entries with invalid CAS Registry Numbers (<1%)


rm(fccmigex_raw, fccmigex_split)

saveRDS(fccmigex, "data/input/clean/FCCmigex_db/fccmigex.rds")

fccmigex_cas <- subset(fccmigex, subset = !is.na(cas_id_final))
fccmigex_no_cas <- subset(fccmigex, subset = is.na(cas_id_final))

fccmigex_cas_split <- split(fccmigex_cas, f = ~ cas_id_final)
fccmigex_no_cas_split <- split(fccmigex_no_cas, f = ~ fcc_main)

fccmigex_cas_clean <- do.call(
  what = "rbind",
  args = c(
    pbapply::pblapply(
      fccmigex_cas_split,
      FUN = function(x) {
        if(sum(is.na(x$fcm_focus)) == nrow(x)) {
          n_fcm_focus <- NA_character_
        } else {
          n_fcm_focus <- paste(unique(na.omit(x$fcm_focus)), collapse = ";")
        }
        if(sum(is.na(x$detected)) == nrow(x)) {
          n_detected <- NA_integer_
        } else {
          n_detected <- max(na.omit(x$detected))
        }
        if(sum(is.na(x$fcm_content)) == nrow(x)) {
          n_fcm_content <- NA_character_
        } else {
          n_fcm_content <- paste(unique(na.omit(x$fcm_content)), collapse = ";")
        }
        
        res <- data.frame(
          "fccmigex_id" = paste(x$fccmigex_id, collapse = ";"),
          "fcc_main" = paste(unique(x$fcc_main), collapse = ";"),
          "fcm_main" = paste(unique(x$fcm_main), collapse = ";"),
          "fcm_focus" = n_fcm_focus,
          "experiment" = paste(unique(x$experiment), collapse = ";"),
          "detected" = n_detected,
          "cas_id_final" = unique(x$cas_id_final),
          "fcm_content" = n_fcm_content,
          stringsAsFactors = FALSE
        )
        res
      }
    ),
    make.row.names = FALSE
  )
)

fccmigex_no_cas_clean <- do.call(
  what = "rbind",
  args = c(
    pbapply::pblapply(
      fccmigex_no_cas_split,
      FUN = function(x) {
        if(sum(is.na(x$fcm_focus)) == nrow(x)) {
          n_fcm_focus <- NA_character_
        } else {
          n_fcm_focus <- paste(unique(na.omit(x$fcm_focus)), collapse = ";")
        }
        if(sum(is.na(x$detected)) == nrow(x)) {
          n_detected <- NA_integer_
        } else {
          n_detected <- max(na.omit(x$detected))
        }
        if(sum(is.na(x$fcm_content)) == nrow(x)) {
          n_fcm_content <- NA_character_
        } else {
          n_fcm_content <- paste(unique(na.omit(x$fcm_content)), collapse = ";")
        }
        
        res <- data.frame(
          "fccmigex_id" = paste(x$fccmigex_id, collapse = ";"),
          "fcc_main" = unique(x$fcc_main),
          "fcm_main" = paste(unique(x$fcm_main), collapse = ";"),
          "fcm_focus" = n_fcm_focus,
          "experiment" = paste(unique(x$experiment), collapse = ";"),
          "detected" = n_detected,
          "cas_id_final" = NA_character_,
          "fcm_content" = n_fcm_content,
          stringsAsFactors = FALSE
        )
        res
      }
    ),
    make.row.names = FALSE
  )
)

fccmigex_clean <- rbind(fccmigex_cas_clean, fccmigex_no_cas_clean)
row.names(fccmigex_clean) <- NULL

saveRDS(fccmigex_clean, "data/input/clean/FCCmigex_db/fccmigex_clean.rds")

rm(fccmigex_cas, fccmigex_cas_clean, fccmigex_cas_split, fccmigex_no_cas, fccmigex_no_cas_clean, fccmigex_no_cas_split)

rm(fccmigex)
