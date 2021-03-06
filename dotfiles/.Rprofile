.First <- function() {

  cat("\n# Welcome Manos! Today is ", date(), "\n")
  cat("\n# Loading .Rprofile from", path.expand("~"))

  googleCloudStorageR::gcs_first(bucket = Sys.getenv("GCS_SESSION_BUCKET"))
  # don't do anything for revolution R
  if (exists("Revo.version"))
    return()

  # only run in interactive mode
  if (!interactive())
    return()

  # bail in Docker environments
  if (!is.na(Sys.getenv("DOCKER", unset = NA)))
    return()

  # create .Rprofile env
  .__Rprofile.env__. <- attach(NULL, name = "local:rprofile")

  # helpers for setting things in .__Rprofile.env__.
  set <- function(name, value)
    assign(name, value, envir = .__Rprofile.env__.)

  set(".Start.time", as.numeric(Sys.time()))

  NAME <- intToUtf8(
    c(75L, 101L, 118L, 105L, 110L, 32L, 85L, 115L, 104L, 101L, 121L)
  )

  EMAIL <- intToUtf8(
    c(107L, 101L, 118L, 105L, 110L, 117L, 115L, 104L,
      101L, 121L, 64L, 103L, 109L, 97L, 105L, 108L,
      46L, 99L, 111L, 109L)
  )

  # Ensure that the user library exists and is set, so that we don't install to
  # the system library by default (e.g. on OS X)
  local({
    userLibs <- strsplit(Sys.getenv("R_LIBS_USER"), .Platform$path.sep)[[1]]
    if (length(userLibs) && is.character(userLibs)) {
      lapply(userLibs, function(lib) {
        if (!file.exists(lib)) {
          if (!dir.create(lib, recursive = TRUE)) {
            warning("failed to create user library '", lib, "'")
          }
        }
      })
    }
    .libPaths(userLibs)
  })

  # Set TZ for macOS High Sierra
  if (identical(Sys.info()[["sysname"]], "Darwin"))
    Sys.setenv(TZ = "Europe/Athens")

  # Don't use a user library if we have a site library on OS X
  # (ie, don't die when we're using homebrew R)
  isHomebrew <-
    identical(Sys.info()[["sysname"]], "Darwin") &&
    length(.Library.site)

  if (isHomebrew) {
    .libPaths("")
    Sys.setenv(R_LIBS_USER = .Library.site)
  }

  # Ensure TAR is set (for e.g. Snow Leopard builds of R)
  TAR <- Sys.which("tar")
  if (nzchar(TAR)) Sys.setenv(TAR = TAR)

  # ensure Rtools on PATH for Windows
  isWindows <- Sys.info()[["sysname"]] == "Windows"
  if (isWindows) {
    PATH <- Sys.getenv("PATH", unset = "")
    paths <- strsplit(PATH, .Platform$path.sep, fixed = TRUE)[[1]]
    hasRtools <- any(file.exists(file.path(paths, "Rtools.txt")))
    if (!hasRtools) {
      candidates <- c("C:\\Rtools")
      discovered <- FALSE
      for (candidate in candidates) {
        if (file.exists(file.path(candidate, "Rtools.txt"))) {
          new <- c(file.path(candidate, "bin", fsep = "\\"),
                   file.path(candidate, "gcc-4.6.3\\bin", fsep = "\\"))
          PATH <- paste(
            paste(new, collapse = ";"),
            PATH,
            sep = ";"
          )
          Sys.setenv(PATH = PATH)
          discovered <- TRUE
          break
        }
      }

      if (!discovered)
        warning("Failed to discover Rtools on the PATH")
    }
  }

  # Ensure /usr/local/bin is first on the PATH
  if (!isWindows) {
    PATH <- strsplit(Sys.getenv("PATH"), .Platform$path.sep, fixed = TRUE)[[1]]
    PATH <- unique(c("/usr/local/bin", PATH))
    Sys.setenv(PATH = paste(PATH, collapse = .Platform$path.sep))
  }

  # prefer source packages for older versions of R
  pkgType <- getOption("pkgType")
  if (getRversion() < "3.3")
    pkgType <- "source"

  options(
    # CRAN
    repos = c(CRAN = "https://cran.rstudio.org"),

    # source packages for older R
    pkgType = pkgType,

    # no tcltk
    menu.graphics = FALSE,

    # don't treate newlines as synonym to 'n' in browser
    browserNLdisabled = TRUE,

    # keep source code as-is for package installs
    keep.source = TRUE,
    keep.source.pkgs = TRUE,

    # no fancy quotes (makes copy + paste a pain)
    useFancyQuotes = FALSE,

    # warn on partial matches
    # warnPartialMatchArgs = TRUE ## too disruptive
    warnPartialMatchAttr = TRUE,
    warnPartialMatchDollar = TRUE,

    # warn right away
    warn = 1,

    # devtools related options
    devtools.desc = list(
      Author = NAME,
      Maintainer = paste(NAME, " <", EMAIL, ">", sep = ""),
      License = "MIT + file LICENSE",
      Version = "0.0.1"
    ),

    devtools.name = NAME
  )

  # if using 'curl' with RStudio, ensure stderr redirected
  method <- getOption("download.file.method")
  if (is.null(method)) {
     if (getRversion() >= "3.4.0" && capabilities("libcurl")) {
        options(
           download.file.method = "libcurl",
           download.file.extra  = NULL
        )
     } else if (nzchar(Sys.which("curl"))) {
        options(
           download.file.method = "curl",
           download.file.extra = "-L -f -s --stderr -"
        )
     }
  }

  # always run Rcpp tests
  Sys.setenv(RunAllRcppTests = "yes")

  # attempt to set JAVA_HOME if not already set
  if (is.na(Sys.getenv("JAVA_HOME", unset = NA)) &&
      file.exists("/usr/libexec/java_home"))
  {
    JAVA_HOME <- tryCatch(
      system("/usr/libexec/java_home", intern = TRUE),
      error = function(e) ""
    )

    if (nzchar(JAVA_HOME))
      Sys.setenv(JAVA_HOME = JAVA_HOME)
  }

  # auto-completion of package names in `require`, `library`
  utils::rc.settings(ipck = TRUE)

  # generate some useful aliases, for editing common files
  alias <- function(name, action) {
    placeholder <- structure(list(), class = sprintf("__%s__", name))
    assign(name, placeholder, envir = .__Rprofile.env__.)
    assign(sprintf("print.__%s__", name), action, envir = .__Rprofile.env__.)
  }

  # open .Rprofile for editing
  alias(".Rprofile", function(...) file.edit("~/.Rprofile"))
  alias(".Renviron", function(...) file.edit("~/.Renviron"))

  # open Makevars for editing
  alias("Makevars", function(...) {
    if (!utils::file_test("-d", "~/.R"))
      dir.create("~/.R")
    file.edit("~/.R/Makevars")
  })

  # simple CLI to git
  git <- new.env(parent = emptyenv())
  commands <- c("clone", "init", "add", "mv", "reset", "rm",
                "bisect", "grep", "log", "show", "status", "stash",
                "branch", "checkout", "commit", "diff", "merge",
                "rebase", "tag", "fetch", "pull", "push", "clean")

  for (command in commands) {

    code <- substitute(
      system(paste(path, "-c color.status=false", command, ...)),
      list(path = quote(shQuote(normalizePath(Sys.which("git")))),
           command = command)
    )

    fn <- eval(call("function", pairlist(... = quote(expr = )), code))

    assign(command, fn, envir = git)

  }

  assign("git", git, envir = .__Rprofile.env__.)

  # tools for munging the PATH
  PATH <- (function() {

    read <- function() {
      strsplit(Sys.getenv("PATH"), .Platform$path.sep, TRUE)[[1]]
    }

    write <- function(path) {
      Sys.setenv(PATH = paste(path, collapse = .Platform$path.sep))
      invisible(path)
    }

    prepend <- function(dir) {
      dir <- normalizePath(dir, mustWork = TRUE)
      path <- c(dir, setdiff(read(), dir))
      write(path)
    }

    append <- function(dir) {
      dir <- normalizePath(dir, mustWork = TRUE)
      path <- c(setdiff(read(), dir), dir)
      write(path)
    }

    remove <- function(dir) {
      path <- setdiff(read(), dir)
      write(path)
    }

    list(
      read = read,
      write = write,
      prepend = prepend,
      append = append,
      remove = remove
    )

  })()
  assign("PATH", PATH, envir = .__Rprofile.env__.)


  # ensure commonly-used packages are installed, loaded
  quietly <- function(expr) {
    status <- FALSE
    suppressWarnings(suppressMessages(
      utils::capture.output(status <- expr)
    ))
    status
  }

  install <- function(package) {

    code <- sprintf(
      "utils::install.packages(%s, lib = %s, repos = %s)",
      shQuote(package),
      shQuote(.libPaths()[[1]]),
      shQuote(getOption("repos")[["CRAN"]])
    )

    R <- file.path(
      R.home("bin"),
      if (Sys.info()[["sysname"]] == "Windows") "R.exe" else "R"
    )
    
    con <- tempfile(fileext = ".R")
    writeLines(code, con = con)
    on.exit(unlink(con), add = TRUE)

    cmd <- paste(shQuote(R), "-f", shQuote(con))
    system(cmd, ignore.stdout = TRUE, ignore.stderr = TRUE)
  }

  packages <- c("devtools", "roxygen2", "knitr", "rmarkdown", "testthat")
  invisible(lapply(packages, function(package) {

    if (quietly(require(package, character.only = TRUE, quietly = TRUE)))
      return()

    message("Installing '", package, "' ... ", appendLF = FALSE)
    install(package)

    success <- quietly(require(package, character.only = TRUE, quietly = TRUE))
    message(if (success) "OK" else "FAIL")

  }))

  # clean up extra attached envs
  addTaskCallback(function(...) {
    count <- sum(search() == "local:rprofile")
    if (count == 0)
      return(FALSE)

    for (i in seq_len(count - 1))
      detach("local:rprofile")

    return(FALSE)
  })

  # display startup message(s)
  msg <- if (length(.libPaths()) > 1)
    "Using libraries at paths:\n"
  else
    "Using library at path:\n"
  libs <- paste("-", .libPaths(), collapse = "\n")
  message(msg, libs, sep = "")
}

.Last <- function(){
  # will only upload if a _gcssave.yaml in directory with bucketname
  googleCloudStorageR::gcs_last(bucket = Sys.getenv("GCS_SESSION_BUCKET"))
  message("\nGoodbye Manos at ", date(), "\n")
}
