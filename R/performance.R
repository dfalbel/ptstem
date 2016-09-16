#' Overstemming Index (OI)
#'
#' It calculates the proportion of unrelated words that were combined.
#'
#' @param words is a data.frame containing a column word a a column group
#' so the function can identify groups of words.
#' @param stems is a character vector with the stemming result for each word
#'
overstemming_index <- function(words, stems){
  words$stems <- stems
  aux <- words %>%
    dplyr::group_by(stems, group) %>%
    dplyr::summarise(n_group_stem = n()) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(stems) %>%
    dplyr::filter(dplyr::row_number(dplyr::desc(n_group_stem)) > 1) %>%
    dplyr::summarise(misclassified = sum(n_group_stem))
  sum(aux$misclassified)/nrow(words)
}

#' Understemming Index (UI)
#'
#' It calculates the proportion of related words that had different stems.
#'
#' @param words is a data.frame containing a column word a a column group
#' so the function can identify groups of words.
#' @param stems is a character vector with the stemming result for each word
#'
understemming_index <- function(words, stems){
  words$stems <- stems
  aux <- words %>%
    dplyr::group_by(group, stems) %>%
    dplyr::summarise(n_word_stem = n()) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(group) %>%
    dplyr::filter(dplyr::row_number(dplyr::desc(n_word_stem)) > 1) %>%
    dplyr::summarise(misclassified = sum(n_word_stem))
  sum(aux$misclassified)/nrow(words)
}

#' Performance
#'
#' @param stemmers a character vector with names of stemming algorithms.
#' In the near future, functions will also be accepted.
#'
#' @return a data.frame with the following measures calculated for each stemmer:
#' \item{UI}{Understemming Index}
#' \item{OI}{Overstemming Index}
#'
#' @examples
#' \dontrun{perf <- performance()}
#'
#' @export
performance <- function(stemmers = c("rslp", "hunspell", "porter", "modified-hunspell")){
  names(stemmers) <- stemmers
  words <- readRDS(system.file("words_sample.rda", package = "ptstem"))
  plyr::ldply(stemmers, function(stem, words){
    stems <- ptstem(words$word, algorithm = stem)
    data.frame(
      UI = understemming_index(words, stems),
      OI = overstemming_index(words, stems)
    )
  },words = words)
}



