#' Stemming using RSLP
#'
#' This function uses the RSLP algorithm to stem a vector of words.
#' By default, the RSLP algorithm leaves words cutted. As this makes
#' reading stemmed texts very difficult, this function provides an option
#' to complete the stemmed words. By default it completes with the most used
#' word in the text that has the same stem.
#'
#' @param words character vector of words to be stemmed
#' @param complete wheter words must be completed or not (T)
#'
#' @references
#' V. Orengo, C. Huyck, "A Stemming Algorithmm for the Portuguese Language", SPIRE, 2001, String Processing and Information Retrieval, International Symposium on, String Processing and Information Retrieval, International Symposium on 2001, pp. 0186, doi:10.1109/SPIRE.2001.10024
#'
#' @examples
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' ptstem:::stem_rslp(words)
#'
stem_rslp <- function(words, complete = TRUE){

  stems <- rslp::rslp(words)

  if (complete == FALSE) {
    return(stems)
  } else {

    stem_word <- complete_stems(words, stems)
    word_stem <- tibble::tibble(words = words, stems = stems) %>%
      dplyr::left_join(stem_word, by = "stems")

    return(word_stem$new_stems)
  }
}
