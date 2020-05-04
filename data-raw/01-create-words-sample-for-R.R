library(magrittr)
library(stringr)
library(dplyr)
library(tidyr)
words_sample <- readLines("data-raw/words_sample/words_sample.txt") %>%
  paste(collapse = " ") %>%
  str_split(fixed("*")) %>%
  unlist() %>%
  tibble(word = .) %>%
  mutate(
    word = trimws(word),
    word = str_split(word, "\\s"),
    group = row_number()
    ) %>%
  unnest(word) %>%
  filter(word != "")

saveRDS(words_sample, file = "inst/words_sample.rda")

