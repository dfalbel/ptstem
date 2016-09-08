#' Stem using Porter's
#'
#' This function uses the Porters's algorithm to stem a vector of words.
#' By default, the Porter's algorithm leaves words cutted. As this makes
#' reading stemmed texts very difficult, this function provides an option
#' to complete the stemmed words. By default it completes with the most used
#' word in the text that has the same stem.
#'
#' @param words character vector of words to be stemmed
#' @param complete wheter words must be completed or not (T)
#'
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' ptstem:::stem_porter(words)
#'
stem_porter <- function(words, complete = TRUE){
  stems <- SnowballC::wordStem(words, language = "portuguese")

  if (complete == FALSE) {
    return(stems)
  } else {

    stem_word <- complete_stems(words, stems)
    word_stem <- dplyr::data_frame(words = words, stems = stems) %>%
      dplyr::left_join(stem_word, by = "stems")

    return(word_stem$new_stems)
  }
}
