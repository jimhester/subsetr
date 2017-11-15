#' @inherit base::subset
#' @importFrom rlang eval_tidy enquo
#' @rawNamespace export(subset.data.frame)
#' @rawNamespace S3method(subset, data.frame)
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
  base$`[.data.frame`(x, r, vars, drop = drop)
}

#' @inherit base::`[.data.frame`
#' @rawNamespace export("[.data.frame")
#' @rawNamespace S3method("[", data.frame)
`[.data.frame` <- local({
  in_call <- FALSE

  function(x, i, j, drop) {
    # Protect against recursive calls
    if (in_call) {
      if (missing(drop)) {
        return(base$`[.data.frame`(x, i, j))
      } else {
        return(base$`[.data.frame`(x, i, j))
      }
    }
    in_call <<- TRUE
    on.exit(in_call <<- FALSE)
    if (!missing(i)) {
      i <- eval_tidy(enquo(i), x)
    }
    if (!missing(j)) {
      nl <- as.list(seq_along(x))
      names(nl) <- names(x)
      j <- eval_tidy(enquo(j), nl)
    }
    res <- base$`[.data.frame`(x, i, j, drop = FALSE)
    if (missing(drop)) {
      drop <- missing(i) || ncol(res) == 1
    }
    base$`[.data.frame`(res, , , drop = drop)
  }
})

base <- new.env(emptyenv())

.onAttach <- function(libname, pkgname) {
  for (f_name in c("[.data.frame", "subset.data.frame")) {
    (get("unlockBinding"))(f_name, env = baseenv())
    base[[f_name]] <- get(f_name, baseenv())
    assign(f_name, envir = baseenv(), get(f_name))
    lockBinding(f_name, env = baseenv())
  }
}

.onDetach <- function(libname) {
  for (f_name in c("[.data.frame", "subset.data.frame")) {
    (get("unlockBinding"))(f_name, env = baseenv())
    assign(f_name, envir = baseenv(), base[[f_name]])
    lockBinding(f_name, env = baseenv())
  }
}
