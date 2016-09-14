#' Stemming with small modification of Hunspell
#'
#'
#' This function uses Hunspell Stemmer to stem a vector of words.
#' It uses the (Portuguese Brazilian) dictionary by default, and unlike
#' hunspell::hunspell_stem it returns only one stem per word.
#'
#' Then it uses the rslp stemmer in the hunspell stemmed result.
#'
#' As hunspell_stem can return a list of stems for each word, the function
#' takes the stems that appears the most in the vector for each word.
#'
#' @param words character vector of words to be stemmed
#' @param complete wheter words must be completed or not (T)
#'
#' @examples
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' ptstem:::stem_modified_hunspell(words)
#'
stem_modified_hunspell <- function(words, complete = TRUE){

  stems <- hunspell::hunspell_stem(
    words,
    dict = system.file("dict/Portuguese_Brazilian.dic", package = "ptstem")
  )

  stems <- plyr::llply(stems, function(w){
    unique(ptstem(w, algorithm = "rslp", complete = F))
  })

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
