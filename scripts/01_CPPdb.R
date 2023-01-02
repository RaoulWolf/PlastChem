# CPPdb List A

cpp_a <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/CPPdb/CPPdb_ListA_ListB_181009_ZenodoV1.xlsx",
  sheet = "CPPdb_ListA",
  cols = c(1, 3:4),
  na.strings = c(" ", "-")
)
colnames(cpp_a) <- c("cas", "name", "synonym")
cpp_a <- cbind("cpp_a_id" = 1:nrow(cpp_a), cpp_a)

cpp_a_split <- split(cpp_a, f = ~ cpp_a_id)

cpp_a <- do.call(
  what = "rbind",
  args = c(
    lapply(
      cpp_a_split,
      FUN = function(x) {
        data.frame(
          "cpp_a_id" = unique(x$cpp_a_id),
          "cas" = ifelse(cleanventory:::.check_cas(x$cas), x$cas, NA_character_),
          "name_and_synonym" = c(
            trimws(unlist(strsplit(x$name, split = ";"), use.names = FALSE)),
            trimws(unlist(strsplit(x$synonym, split = ";"), use.names = FALSE))
          ),
          stringsAsFactors = FALSE
        )
      }
    ),
    make.row.names = FALSE
  )
)
cpp_a <- transform(
  cpp_a,
  "name_and_synonym" = ifelse(
    test = nchar(name_and_synonym) == 0L,
    yes = NA_character_,
    no = name_and_synonym
  )
)
cpp_a <- unique(subset(cpp_a, subset = !is.na(cas) & !is.na(name_and_synonym)))
rownames(cpp_a) <- NULL

saveRDS(cpp_a, "data/clean/CPPdb/CPPdb_ListA.rds")

# CPPdb List B

cpp_b <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/CPPdb/CPPdb_ListA_ListB_181009_ZenodoV1.xlsx",
  sheet = "CPPdb_ListB",
  cols = c(1, 3:4),
  na.strings = c(" ", "-")
)
colnames(cpp_b) <- c("cas", "name", "synonym")
cpp_b <- cbind("cpp_b_id" = 1:nrow(cpp_b), cpp_b)

cpp_b_split <- split(cpp_b, f = ~ cpp_b_id)

cpp_b <- do.call(
  what = "rbind",
  args = c(
    lapply(
      cpp_b_split,
      FUN = function(x) {
        data.frame(
          "cpp_b_id" = unique(x$cpp_b_id),
          "cas" = ifelse(cleanventory:::.check_cas(x$cas), x$cas, NA_character_),
          "name_and_synonym" = c(
            trimws(unlist(strsplit(x$name, split = ";"), use.names = FALSE)),
            trimws(unlist(strsplit(x$synonym, split = ";"), use.names = FALSE))
          ),
          stringsAsFactors = FALSE
        )
      }
    ),
    make.row.names = FALSE
  )
)
cpp_b <- transform(
  cpp_b,
  "name_and_synonym" = ifelse(
    test = nchar(name_and_synonym) == 0L,
    yes = NA_character_,
    no = name_and_synonym
  )
)
cpp_b <- unique(subset(cpp_b, subset = !is.na(cas) & !is.na(name_and_synonym)))
rownames(cpp_b) <- NULL

saveRDS(cpp_b, "data/clean/CPPdb/CPPdb_ListB.rds")
