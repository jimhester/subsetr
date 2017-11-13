#' @inherit base::subset
#' @importFrom rlang eval_tidy enquo
#' @export
subset.data.frame <- function (x, subset, select, drop = FALSE, ...) {
  r <- if (missing(subset))
    rep_len(TRUE, nrow(x))
  else {
    r <- eval_tidy(enquo(subset), x)
    if (!is.logical(r))
      stop("'subset' must be logical")
    r & !is.na(r)
  }
  vars <- if (missing(select))
    TRUE
  else {
    nl <- as.list(seq_along(x))
    names(nl) <- names(x)
    eval_tidy(enquo(select), nl)
  }
  x[r, vars, drop = drop]
}

#' @inherit base::`[.data.frame`
#' @export
`[.data.frame` <- function(x, i, j, drop) {
  if (!missing(i)) {
    i <- eval_tidy(enquo(i), x)
  }
  if (!missing(j)) {
    nl <- as.list(seq_along(x))
    names(nl) <- names(x)
    j <- eval_tidy(enquo(j), nl)
  }
  res <- base::`[.data.frame`(x, i, j, drop = FALSE)
  if (missing(drop)) {
    drop <- missing(i) || ncol(res) == 1
  }
  base::`[.data.frame`(res, , , drop = drop)
}
