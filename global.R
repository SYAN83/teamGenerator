source("./helpers.R")

options(stringsAsFactors = FALSE)
NYCICON <- "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"

dataDir <- "./data/"
dataPath <- "./data/bc10_students.csv"

header <- c("Name", "Github", "Avatar")
studentdf <- read.csv(dataPath)

missingAvatar = "https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png"
# if(setdiff(header, colnames(studentdf)) == "Avatar") {
#   studentdf$Avatar <- missingAvatar
# }

# for(i in 1:nrow(studentdf)) {
#   if(!grepl(pattern = "https://avatars2.githubusercontent.com/",
#             x = studentdf$Avatar[i])) {
#     avatar <- get_avatar(studentdf$Github[i])
#     print(avatar)
#     if(grepl(pattern = "https://avatars2.githubusercontent.com/",
#              x = avatar)) {
#       data$studentdf$Avatar[i] = avatar
#     }
#     break
#   }
# }
# 

