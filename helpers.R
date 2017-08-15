
get_avatar <- function(gitHubUrl, 
                       missingAvatar = "https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png") {
  gitHubApi <- sub(pattern = "github.com", 
                   replacement = "api.github.com/users", 
                   x = gitHubUrl)
  avatars <- character(0)
  for(api in gitHubApi) {
    avatar_url <- tryCatch(expr = {
      con <- gzcon(curl::curl(api))
      profile <- jsonlite::stream_in(con)
      return(profile$avatar_url)
      }, error = function(e) {
        print(e)
        return(missingAvatar)
      })
    # con <- gzcon(curl::curl(api))
    # profile <- jsonlite::stream_in(con)
    # rm(con)
    # avatar_url <- ifelse(grepl(pattern = "https://avatars2.githubusercontent.com/", 
    #                            x = my_profile$avatar_url),
    #                      profile$avatar_url, 
    #                      missingAvatar)
    avatars <- c(avatars, avatar_url)
  }
  return(avatars)
}

teamUp <- function(userDF, teamSize, seedNum) {
  userInfo <- paste0("<img src='", 
                     userDF$Avatar, 
                     "' height='75'></img><br><strong>",
                     userDF$Name,
                     "</strong>")
  teamNum <- floor(nrow(userDF) / teamSize)
  if(seedNum) {
    set.seed(seedNum)
  }
  shuffled <- c(sample(userInfo), 
                rep("", ceiling(nrow(userDF) / teamNum) * teamNum - nrow(userDF)))
  mtx <- as.data.frame(matrix(shuffled, ncol = teamNum, byrow = TRUE))
  names(mtx) <- paste("TEAM", 1:length(mtx))
  return(mtx)
}
