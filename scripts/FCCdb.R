# FCCdb

fcc <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/FCCdb/FCCdb_190607_v1_zenodo.xlsx",
  sheet = "FCCdb v1.0",
  cols = 2:4,
  na.strings = c(" ", "-", "0")
)
colnames(fcc) <- c("cas", "name", "synonym")
fcc <- cbind("fcc_id" = 1:nrow(fcc), fcc)

fcc_split <- split(fcc, f = ~ fcc_id)

fcc <- do.call(
  what = "rbind",
  args = c(
    lapply(
      fcc_split,
      FUN = function(x) {
        res <- data.frame(
          "fcc_id" = unique(x$fcc_id),
          "cas" = ifelse(cleanventory:::.check_cas(trimws(x$cas)), trimws(x$cas), NA_character_),
          "name_and_synonym" = c(
            trimws(unlist(strsplit(x$name, split = ";"), use.names = FALSE)),
            trimws(unlist(strsplit(x$synonym, split = ";"), use.names = FALSE))
          ),
          stringsAsFactors = FALSE
        )
        res <- unique(res)
        res
      }
    ),
    make.row.names = FALSE
  )
)
fcc <- transform(
  fcc,
  "name_and_synonym" = ifelse(
    test = nchar(name_and_synonym) == 0L,
    yes = NA_character_,
    no = name_and_synonym
  )
)
fcc <- transform(
  fcc,
  "name_and_synonym" = ifelse(
    test = name_and_synonym == "2)",
    yes = NA_character_,
    no = name_and_synonym
  )
)
fcc <- transform(
  fcc,
  "name_and_synonym" = ifelse(
    test = name_and_synonym == "1)",
    yes = NA_character_,
    no = name_and_synonym
  )
)
fcc <- transform(
  fcc,
  "name_and_synonym" = ifelse(
    test = name_and_synonym == "0",
    yes = NA_character_,
    no = name_and_synonym
  )
)
fcc <- transform(
  fcc,
  "name_and_synonym" = ifelse(
    test = name_and_synonym == "-",
    yes = NA_character_,
    no = name_and_synonym
  )
)

fcc <- unique(subset(fcc, subset = !is.na(cas) & !is.na(name_and_synonym)))
rownames(fcc) <- NULL

saveRDS(fcc, "data/clean/FCCdb/FCCdb_v1_0.rds")
