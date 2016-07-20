library(ptstem)


texts <- c("coma frutas pois elas fazem bem para a sa\u00fade",
           "n\u00e3o coma doces, eles fazem mal para os dentes")
words <- c("bal\u00f5es", "avi\u00f5es", "avi\u00e3o", "gostou", "gosto",
           "gostaram")

# words %>% stringi::stri_escape_unicode() %>% dput()
# ptstem(words, algorithm = "porter") %>% stringi::stri_escape_unicode() %>% dput()

context("Stemming")

test_that("Stemming Hunspell Works", {
  expect_equal(
    ptstem(texts, algorithm = "hunspell"),
    c("comer fruto pois elar fazer bem parir a saudar", "n\u00e3o comer do\u00e7ar, elar fazer mal parir os dentar")
    )
  expect_equal(
    ptstem(words, algorithm = "hunspell"),
    c("bal\u00e3o", "avi\u00e3o", "avi\u00e3o", "gostar", "gostar", "gostar")
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

ptstem(texts = c("ela", "elas", "eles"), algorithm = "hunspell", n_char = 4)

test_that("n_char argument", {
  expect_equal(
    ptstem(texts = c("ela", "elas", "eles"), algorithm = "hunspell", n_char = 4),
    c("ela", "elar", "elar")
    )
  expect_equal(ptstem("abreviado", algorithm = "hunspell", n_char = 10), "abreviado")
})

test_that("ignore argument", {
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = "abreviado"), "abreviado")
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = ".o$"), "abreviado")
  expect_equal(ptstem("abreviado", algorithm = "hunspell", ignore = ".brev"), "abreviado")
})
