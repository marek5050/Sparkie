.First <- function() {
  projecHome <- Sys.getenv("PROJECT_HOME")
  .libPaths(c(paste(projecHome,"/lib", sep=""), .libPaths()))
  Sys.setenv(NOAWT=1)
}
