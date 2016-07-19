#' Stemming using Hunspell
#'
#' This function uses Hunspell Stemmer to stem a vector of words.
#' It uses the (Portuguese Brazilian) dictionary by default, and unlike
#' hunspell::hunspell_stem it returns only one stem per word.
#'
#' As hunspell_stem can return a list of stems for each word, the function
#' takes the stems that appears the most in the vector for each word.
#'
#' @param words character vector of words to be stemmed
#'
#' @examples
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' stem_hunspell(words)
#'
stem_hunspell <- function(words){
  stems <- hunspell::hunspell_stem(
    words,
    dict = system.file("Portuguese (Brazilian).dic", package = "ptstem")
  )

  stem_df <- dplyr::data_frame(
    words = words,
    stems = stems
  ) %>%
    tidyr::unnest(stems) %>%
    dplyr::group_by(stems) %>%
    dplyr::mutate(n_stem = n())

  word_stem <- stem_df %>%
    dplyr::group_by(words) %>%
    dplyr::summarise(stems = dplyr::first(stems, order_by = -n_stem)) %>%
    dplyr::right_join(dplyr::data_frame(words = words), by = "words")

  return(word_stem$stems)
}
