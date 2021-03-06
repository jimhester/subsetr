
<!-- README.md is generated from README.Rmd. Please edit that file -->
subsetr
=======

[![Travis build status](https://travis-ci.org/jimhester/subsetr.svg?branch=master)](https://travis-ci.org/jimhester/subsetr)

subsetr uses tidy evaluation principles developed in rlang to provide `subset.data.frame()` and `[.data.frame()` methods which use tidy non-standard evaluation.

For most cases they provide drop in replacements for the existing methods, but can also avoid repetitive subsetting code. Because rlang provides robust lexical scoping they are suitable for use in top level scripts, functions and packages.

Examples
--------

``` r
# Most existing code will work identically
mtcars[mtcars$hp > 250, "mpg"]
#> [1] 15.8 15.0

# But you can also use NSE to make things simpler
mtcars[hp > 250, mpg]
#> [1] 15.8 15.0

# The `j` argument works the same as the `select` argument in `base::subset()`.
mtcars[hp > 250, mpg:disp]
#>                 mpg cyl disp
#> Ford Pantera L 15.8   8  351
#> Maserati Bora  15.0   8  301

mtcars[hp > 250, -mpg]
#>                cyl disp  hp drat   wt qsec vs am gear carb
#> Ford Pantera L   8  351 264 4.22 3.17 14.5  0  1    5    4
#> Maserati Bora    8  301 335 3.54 3.57 14.6  0  1    5    8
```

The `subset()` interface is identical, but it now can also work properly inside all functions.

``` r
detach(package:subsetr)
val <<- 400
f <- function(x, val) {
  lapply(x, subset, hp > val)
}
f(list(mtcars), 250)
#> [[1]]
#>  [1] mpg  cyl  disp hp   drat wt   qsec vs   am   gear carb
#> <0 rows> (or 0-length row.names)

library(subsetr)
f <- function(x, val) {
  lapply(x, subset, hp > val)
}
f(list(mtcars), 250)
#> [[1]]
#>                 mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Ford Pantera L 15.8   8  351 264 4.22 3.17 14.5  0  1    5    4
#> Maserati Bora  15.0   8  301 335 3.54 3.57 14.6  0  1    5    8
```
