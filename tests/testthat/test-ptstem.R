library(ptstem)


texts <- c("coma frutas pois elas fazem bem para a sa\u00fade",
           "n\u00e3o coma doces, eles fazem mal para os dentes")
words <- c("bal\u00f5es", "avi\u00f5es", "avi\u00e3o", "gostou", "gosto",
           "gostaram")

# words %>% stringi::stri_escape_unicode() %>% dput()
# ptstem(words, algorithm = "hunspell") %>% stringi::stri_escape_unicode() %>% dput()

context("Stemming")

test_that("Stemming Hunspell Works", {
  expect_equal(
    ptstem(texts, algorithm = "hunspell"),
    c("coma frutas pois elas fazem bem para a sa\u00fade", "n\u00e3o coma doces, elas fazem mal para os dentes")
  )
  expect_equal(
    ptstem(words, algorithm = "hunspell"),
    c("bal\u00f5es", "avi\u00f5es", "avi\u00f5es", "gostou", "gostou", "gostou")
  )
})

test_that("Stemming RSLP Works", {
  expect_equal(
    ptstem(texts, algorithm = "rslp"),
    c("coma frutas pois elas fazem bem para a sa\u00fade", "n\u00e3o coma doces, eles fazem mal para os dentes")
  )
  expect_equal(
    ptstem(words, algorithm = "rslp"),
    c("bal\u00f5es", "avi\u00f5es", "avi\u00f5es", "gostou", "gostou", "gostou")
  )
})

test_that("Stemming Porter Works", {
  expect_equal(
    ptstem(texts, algorithm = "porter"),
    c("coma frutas pois elas fazem bem para a sa\u00fade", "n\u00e3o coma doces, eles fazem mal para os dentes")
  )
  expect_equal(
    ptstem(words, algorithm = "porter"),
    c("bal\u00f5es", "avi\u00f5es", "avi\u00e3o", "gostou", "gostou", "gostou")
  )
})

context("Arguments")

test_that("n_char argument", {
  expect_equal(
    ptstem(texts = c("ela", "elas", "eles"), algorithm = "hunspell", n_char = 4),
    c("ela", "elas", "elas")
  )
  expect_equal(ptstem("abreviado", algorithm = "hunspell", n_char = 10), "abreviado")
})

test_that("ignore argument", {
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = "abreviado"), "abreviado")
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = ".o$"), "abreviado")
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = ".brev"), "abreviado")
})

test_that("error wrong algorithm", {
  expect_error(ptstem("oi, tudo bem?", algorithm = "saka"))
  expect_error(ptstem_words("oi, tudo bem?", algorithm = "saka"))
  expect_error(ptstem_words("oi, tudo bem?", algorithm = NA))
  expect_error(ptstem_words("oi, tudo bem?", algorithm = 1))
})

test_that("complete is logical", {
  expect_error(ptstem("oi, tudo bem?", complete = NA))
  expect_error(ptstem_words("oi, tudo bem?", complete = "aja"))
  expect_error(ptstem_words("oi, tudo bem?", complete = 1))
})

test_that("error when ignore is NA", {
  expect_error(ptstem("oi, tudo bem?", ignore = NA))
})

