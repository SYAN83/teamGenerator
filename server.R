library(DT)
library(dplyr)
library(shiny)
library(shinyBS)
source("./helpers.R")


shinyServer(function(input, output, session){
  
  data <- reactiveValues("studentdf" = studentdf)
  
  # observe({
  #   invalidateLater(2000, session)
  #   for(i in 1:nrow(data$studentdf)) {
  #     if(!grepl(pattern = "https://avatars2.githubusercontent.com/",
  #                x = data$studentdf$Avatar[i])) {
  #       avatar <- get_avatar(data$studentdf$Github[i])
  #       if(grepl(pattern = "https://avatars2.githubusercontent.com/",
  #                x = avatar)) {
  #         data$studentdf$Avatar[i] = avatar
  #         break
  #       }
  # 
  #     }
  #   }
  # })
  
  # show data using DataTable
  output$table <- DT::renderDataTable({
    validate(
      need(nrow(data$studentdf) > 0, "No user availabe, please add users first!")
    )
    DT::datatable(data$studentdf %>% 
                    mutate(Image = paste0("<a href='", 
                                          Github, 
                                          "' target='_blank'>",
                                          "<img src='", 
                                          Avatar, 
                                          "' height='50'></img></a>")) %>%
                    select(Image, Name, Github),
                  escape = FALSE, 
                  options = list(pageLength = nrow(data$studentdf)))
  })
  
  ## add-user functionality
  observeEvent(input$addUser, {
    if(input$nameToAdd %in% data$studentdf$Name) {
      errorMsg <- paste("Error: user <strong>", input$nameToAdd,
                        "</strong>already exists! Change the name and try again!")
      createAlert(session, 
                  inputId = "alert", 
                  alertId = "existUser", 
                  message = errorMsg, 
                  type = "danger", 
                  append = FALSE)
      return()
    }

    closeAlert(session, alertId = "existUser")
    data$studentdf <- rbind(data$studentdf,
                            data.frame("Name" = input$nameToAdd,
                                       "Github" = input$urlToAdd,
                                       "Avatar" = get_avatar(input$urlToAdd)))
  })
  
  ## edit-user functionality
  observeEvent(input$editUser, {
    data$studentdf$Github[data$studentdf$Name == input$userToEdit] <- input$urlToEdit
    data$studentdf$Avatar[data$studentdf$Name == input$userToEdit] <- get_avatar(input$urlToEdit)
  })
  
  ## del-user functionality
  observeEvent(input$delUser, {
    data$studentdf <- data$studentdf %>% filter(!(Name %in% input$userToDel))
  })
  
  observeEvent(input$saveTbl, {
    tryCatch({
      write.csv(data$studentdf, dataPath, 
                        quote = FALSE, row.names = FALSE)
      createAlert(session, 
                  inputId = "alert", 
                  alertId = "savedData", 
                  message = "Table has been saved!", 
                  type = "success", 
                  append = FALSE)
      },
      error = function(e) {
        createAlert(session, 
                    inputId = "alert", 
                    alertId = "savedData", 
                    message = "Unable to save table! Please try again!", 
                    type = "danger", 
                    append = FALSE)
        
      })
  })
  
  observeEvent(input$reloadTbl, {
    data$studentdf <- read.csv(dataPath)
  })
  
  observe({
    updateSelectizeInput(session, "userToEdit", "Name", 
                         choices = c("", data$studentdf$Name))
    updateSelectizeInput(session, "userToDel", "Name", 
                         choices = c("", data$studentdf$Name))
    updateTextInput(session, "urlToEdit", "GitHub Link", 
                    value = NULL)
  })
  
  observeEvent(input$table_row_last_clicked, {
    updateSelectizeInput(session, "userToEdit", "Name", 
                         selected = data$studentdf$Name[input$table_row_last_clicked])
    updateTextInput(session, "urlToEdit", "GitHub Link", 
                    value = data$studentdf$Github[input$table_row_last_clicked])
  })
  observeEvent(input$table_rows_selected, {
    updateSelectizeInput(session, "userToDel", "Name", 
                         selected = data$studentdf$Name[input$table_rows_selected])
  })
  
  observeEvent(input$sfl, {
    output$teamUp <- DT::renderDataTable(
      isolate(
        DT::datatable(teamUp(data$studentdf, input$teamSize, input$seedNum), 
                      escape = FALSE, 
                      class = 'cell-border stripe',
                      selection = list(target = 'column'),
                      options = list(dom = 't'))
      )
    )
  })
  
})
