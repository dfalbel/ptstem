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
#' @param complete wheter words must be completed or not (T)
#'
#' @examples
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' ptstem:::stem_hunspell(words)
#'
stem_hunspell <- function(words, complete = TRUE){

  stems <- hunspell::hunspell_stem(
    words,
    dict = system.file("dict/Portuguese_Brazilian.dic", package = "ptstem")
  )

  word_stem <- unify_stems(words, stems) %>%
    dplyr::right_join(dplyr::data_frame(words = words), by = "words") %>%
    dplyr::mutate(stems = stems)

  if (complete == FALSE) {
    return(word_stem$stems)
  } else {

    stem_word <- complete_stems(word_stem$words, word_stem$stems)
    word_stem <-  word_stem %>%
      dplyr::left_join(stem_word, by = "stems")

    return(word_stem$new_stems)
  }

}

#' Unify stems by mean position
#'
#' Hunspell can suggest a list of stems for a word. This function
#' tries to aggregate all stems into one. Consider the folowing:
#'
#' a c(1,2)
#' b c(2,3)
#' c c(3)
#'
#' You want that a, b and c to have the same stem.
#'
#' @param words character vector of words
#' @param stems character vector of stems
#'
unify_stems <- function(words, stems){

  stem_df <- dplyr::data_frame(
    words = words,
    stems = stems
  )

  word_stem <- stem_df %>%
    tidyr::unnest(stems) %>%
    dplyr::group_by(stems) %>%
    dplyr::mutate(n_stem = dplyr::n()) %>%
    dplyr::ungroup()

  stem_stem <- dplyr::left_join(
    word_stem %>% dplyr::select(-n_stem),
    word_stem %>% dplyr::rename(new_stems = stems),
    by = "words"
    ) %>%
    dplyr::group_by(stems) %>%
    dplyr::summarise(new_stems = dplyr::last(new_stems, order_by = n_stem))

  word_stem <- word_stem %>%
    dplyr::left_join(stem_stem, by = "stems") %>%
    dplyr::group_by(words) %>%
    dplyr::summarise(stems = dplyr::first(new_stems))

  return(word_stem)
}

