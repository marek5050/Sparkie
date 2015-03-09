.First <- function() {
  projecHome <- Sys.getenv("PROJECT_HOME")
  Sys.setenv(NOAWT=1)
  .libPaths(c(paste(projecHome,"/lib", sep=""), .libPaths()))
  require(SparkR)
  sc <- sparkR.init(Sys.getenv("MASTER", unset = ""))
  assign("sc", sc, envir=.GlobalEnv)
  cat("\n Welcome to SparkR!")
  cat("\n Spark context is available as sc\n")
}
