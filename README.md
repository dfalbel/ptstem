
<!-- README.md is generated from README.Rmd. Please edit that file -->
ptstem
======

> Stemming Algorithms for the Portuguese Language

[![Travis-CI Build Status](https://travis-ci.org/dfalbel/ptstem.svg?branch=master)](https://travis-ci.org/dfalbel/ptstem) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dfalbel/ptstem?branch=master&svg=true)](https://ci.appveyor.com/project/dfalbel/ptstem) 
[![Coverage Status](https://img.shields.io/codecov/c/github/dfalbel/ptstem/master.svg)](https://codecov.io/github/dfalbel/ptstem?branch=master)

This packages wraps 3 stemming algorithms for the portuguese language available in R. It unifies the API for the stemmers and provides easy stemming completion.

Installing
----------

`ptstem` is not yet available in CRAN. You can install directly from Github using:

``` r
devtools::install_github("dfalbel/ptstem")
```

Using
-----

Consider the following text, extracted from [Stemming in Wikipedia](https://pt.wikipedia.org/wiki/Stemiza%C3%A7%C3%A3o)

``` r
text <- "Em morfologia linguística e recuperação de informação a stemização (do inglês, stemming) é
o processo de reduzir palavras flexionadas (ou às vezes derivadas) ao seu tronco (stem), base ou
raiz, geralmente uma forma da palavra escrita. O tronco não precisa ser idêntico à raiz morfológica
da palavra; ele geralmente é suficiente que palavras relacionadas sejam mapeadas para o mesmo
tronco, mesmo se este tronco não for ele próprio uma raiz válida. O estudo de algoritmos para
stemização tem sido realizado em ciência da computação desde a década de 60. Vários motores de
buscas tratam palavras com o mesmo tronco como sinônimos como um tipo de expansão de consulta, em
um processo de combinação."
```

This will use the [`rslp`](https://github.com/dfalbel/rslp) algorithm to stem the text.

``` r
library(ptstem)
ptstem(text, algorithm = "rslp", complete = FALSE)
#> [1] "Em morfolog linguis e recuper de inform a stemiz (do ingl, stemming) é\no process de reduz palavr flexion (ou às vez deriv) ao seu tronc (st), bas ou\nraiz, geral uma form da palavr escrit. O tronc nao precis ser ident à raiz morfolog\nda palavr; ele geral é sufici que palavr relacion sej mape par o mesm\ntronc, mesm se est tronc nao for ele propri uma raiz val. O estud de algoritm par\nstemiz tem sid realiz em cienc da comput desd a dec de 60. Vari motor de\nbusc trat palavr com o mesm tronc com sinon com um tip de expans de consult, em\num process de combin."
```

You can complete stemmed words using the argument `complete = T`.

``` r
ptstem(text, algorithm = "rslp", complete = TRUE)
```

The other implemented algorithms are:

-   hunspell: the same algorithm used in OpenOffice corrector. (available via [hunspell](https://github.com/ropensci/hunspell) package)
-   porter: available via SnowballC package.

You can stem using those algorithms by changing the `algorithm` argument in `ptstem` function.

``` r
library(ptstem)
ptstem(text, algorithm = "hunspell")
#> [1] "Em morfologia linguística e recuperação de informação a stemização (do inglês, stemização) é\no processo de reduzir palavras flexionadas (ou às vezes derivadas) ao seu tronco (stemização), base ou\nraiz, geralmente uma forma da palavras escrita. O tronco não precisa ser idêntico à raiz morfologia\nda palavras; ele geralmente é suficiente que palavras relacionadas ser mapeadas para o mesmo\ntronco, mesmo se este tronco não for ele próprio uma raiz válida. O estudo de algoritmos para\nstemização tem ser realizado em ciência da computação desde a década de 60. Vários motores de\nbuscas tratam palavras com o mesmo tronco como sinônimos como um tipo de expansão de consulta, em\num processo de combinação."
ptstem(text, algorithm = "porter")
#> [1] "Em morfologia linguística e recuperação de informação a stemização (do inglês, stemming) é\no processo de reduzir palavras flexionadas (ou às vezes derivadas) ao seu tronco (stem), base ou\nraiz, geralmente uma forma da palavras escrita. O tronco não precisa ser idêntico à raiz morfológica\nda palavras; ele geralmente é suficiente que palavras relacionadas sejam mapeadas para o mesmo\ntronco, mesmo se este tronco não for ele próprio uma raiz válida. O estudo de algoritmos para\nstemização tem sido realizado em ciência da computação desde a década de 60. Vários motores de\nbuscas tratam palavras com o mesmo tronco com sinônimos com um tipo de expansão de consulta, em\num processo de combinação."
```
