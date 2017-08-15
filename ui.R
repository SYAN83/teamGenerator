library(DT)
library(shiny)
library(shinyBS)
library(shinydashboard)

actionButtonRow <- function (inputId, label, icon = NULL, width = NULL, ...) {
  div(style="display:inline-block", 
      actionButton(inputId, label, icon = icon, width = width, ...))
}

shinyUI(dashboardPage(
    dashboardHeader(title = "TEAMUP"),
    dashboardSidebar(

        sidebarUserPanel("NYC DSA",
                         image = NYCICON),
        sidebarMenu(
            menuItem("Team Generator", tabName = "team_generator", icon = icon("group")),
            menuItem("Group Manager", tabName = "group_manager", icon = icon("cog"))
        )
    ),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "team_generator",
                    fluidRow(
                      box(title = h4("TEAMS"), status = "info",
                          DT::dataTableOutput("teamUp"),
                          width = 12)
                    ),
                    fluidRow(
                      box(
                        fluidRow(
                          column(4, 
                                 numericInput("teamSize", 
                                              "Team Size",
                                              value = 3,
                                              min = 2, max = ceiling(nrow(studentdf)/2))),
                          column(4, numericInput("seedNum", "Random Seed (0 for NONE)", value = 0)),
                          column(4, br(), actionButton("sfl", "Shuffle", icon = icon("random"))))
                      )
                    )
            ),
            tabItem(tabName = "group_manager",
                    fluidRow(
                      
                      box(title = "Add User", status = "success", 
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          collapsed = TRUE,
                          fluidRow(
                            column(9, 
                                   textInput("nameToAdd", "Name",
                                                placeholder = "Add to group..."),
                                   textInput("urlToAdd", "GitHub Link",
                                             placeholder = "GitHub link...")),
                            column(3, br(), 
                                   actionButton("addUser", "", 
                                                icon = icon("user-plus")))
                            ), 
                          width = 4),
                      
                      box(title = "Edit User", status = "warning", 
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          collapsed = TRUE,
                          fluidRow(
                            column(9, selectizeInput("userToEdit", "Name",
                                                     choice = c("", studentdf$NAME)),
                                   textInput("urlToEdit", "GitHub Link",
                                             placeholder = "GitHub link...")),
                            column(3, br(), 
                                   actionButton("editUser", "", 
                                                icon = icon("user-md")))
                          ), 
                          width = 4),
                      
                      box(title = "Delete User", status = "danger", 
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          collapsed = TRUE,
                          fluidRow(
                            column(9, selectizeInput("userToDel", "Name",
                                                     choice = c("", studentdf$NAME),
                                                     multiple = TRUE)),
                            column(3, br(),
                                   actionButton("delUser", "", 
                                                icon = icon("user-times")))
                            ), 
                          width = 4)
                      ),
                    fluidRow(box(title = "User List", status = "info", 
                                 solidHeader = TRUE,
                                 collapsible = TRUE,
                                 bsAlert(inputId = "alert"),
                                 DT::dataTableOutput("table"), 
                                 column(4,
                                        actionButtonRow("reloadTbl", "Reload", 
                                                        icon = icon("repeat")),
                                        actionButtonRow("saveTbl", "Save", 
                                                        icon = icon("save"))),
                                 width = 12))
                    )
        )
    )
))
