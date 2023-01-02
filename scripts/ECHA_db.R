# ECHA db

echa <- openxlsx::read.xlsx(
  xlsxFile = "data/raw/ECHA_db/fcm-and-articles-regulation--annex-i---authorised-substances-export.xlsx",
  sheet = "results",
  startRow = 5,
  cols = c(1, 3:5),
  na.strings = c(" ", "-")
)
colnames(echa) <- c("substance_name", "cas_no", "name", "cas")
echa <- cbind("echa_id" = 1:nrow(echa), echa)
echa <- transform(
  echa,
  "substance_name" = ifelse(
    test = nchar(substance_name) == 0L | substance_name == "-",
    yes = NA_character_,
    no = substance_name
  ),
  "cas_no" = ifelse(
    test = nchar(cas_no) == 0L | cas_no == "-",
    yes = NA_character_,
    no = cas_no
  ),
  "name" = ifelse(
    test = nchar(name) == 0L | name == "-",
    yes = NA_character_,
    no = name
  ),
  "cas" = ifelse(
    test = nchar(cas) == 0L | cas == "-",
    yes = NA_character_,
    no = cas
  )
)

echa <- transform(
  echa,
  "substance_name" = ifelse(
    grepl("&gt;", substance_name),
    gsub("&gt;", ">", substance_name),
    substance_name
  )
)
echa <- transform(
  echa,
  "name" = ifelse(
    grepl("&amp;#39;", name),
    gsub("&amp;#39;", "'", name),
    name
  )
)
echa <- transform(
  echa,
  "name" = ifelse(
    grepl("&amp;gt;", name),
    gsub("&amp;gt;", ">", name),
    name
  )
)

echa_cas <- subset(echa, select = c(echa_id, cas_no, cas))
echa_name <- subset(echa, select = c(echa_id, substance_name, name))

## ECHA CAS

echa_cas_split <- split(echa_cas, f = ~ echa_id)

echa_cas <- do.call(
  what = "rbind",
  args = c(
    lapply(
      echa_cas_split,
      FUN = function(x) {
        res <- data.frame(
          "echa_id" = unique(x$echa_id),
          "cas_no_and_cas" = c(
            trimws(unlist(strsplit(x$cas_no, split = ";"), use.names = FALSE)),
            trimws(unlist(strsplit(x$cas, split = ";"), use.names = FALSE))
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

echa_cas <- transform(
  echa_cas,
  cas_no_and_cas = ifelse(
    cleanventory:::.check_cas(trimws(cas_no_and_cas)),
    trimws(cas_no_and_cas),
    NA_character_
  )
)

echa_cas <- unique(subset(echa_cas, subset = !is.na(cas_no_and_cas)))
row.names(echa_cas) <- NULL

## ECHA Name

echa_name_split <- split(echa_name, f = ~ echa_id)

echa_name <- do.call(
  what = "rbind",
  args = c(
    lapply(
      echa_name_split,
      FUN = function(x) {
        res <- data.frame(
          "echa_id" = unique(x$echa_id),
          "substance_name_and_name" = c(
            trimws(unlist(strsplit(x$substance_name, split = ";"), use.names = FALSE)),
            trimws(unlist(strsplit(x$name, split = ";"), use.names = FALSE))
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

echa_name <- unique(echa_name)
row.names(echa_name) <- NULL

## Combining

echa <- merge(
  echa_cas,
  echa_name,
  by.x = "echa_id",
  by.y = "echa_id",
  all.x = TRUE,
  all.y = TRUE
)

saveRDS(echa, "data/clean/ECHA_db/ECHA_db_results.rds")
