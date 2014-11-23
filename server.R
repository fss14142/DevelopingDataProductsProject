library(shiny)
library(rCharts)
library(jsonlite)
require(httr)

source("global.R")

getData = function(stateCode, species, daysBack=7){
  require(jsonlite)
  str01 = "http://ebird.org/ws1.1/data/obs/region_spp/recent?rtype=subnational1&r=US-"
  str02="&sci="
  str03="&back="
  str04="&maxResults=100&locale=en_US&fmt=json&includeProvisional=true"
  
  (url = paste0(str01, stateCode,str02,species,str03,daysBack,str04)  )
  stateData = fromJSON(url)
  return(stateData)
}

plotMap = function(stateCode, species, daysBack=7){
  require(rCharts)
  stateData = getData(stateCode, species, daysBack)
  stateMap <- Leaflet$new()
  (stateLat = states$lat[which(states$code == stateCode)])
  (stateLon = states$lon[which(states$code == stateCode)])
  stateMap$setView(c(stateLat, stateLon), zoom=7)
  stateMap$set(width=800, height=600)  
  if(length(stateData)>0){
    for(i in 1:nrow(stateData)){  
      siteCoords = c(stateData$lat[i], stateData$lng[i])    
      siteName = stateData$locName[i]
      siteNumber = stateData$howMany[i]
      siteDate = stateData$obsDt[i]
      sitePopup = paste0("<p> Site name: ",siteName,"<br>", collapse = "")
      sitePopup = paste0(sitePopup, "Coordinates (lat, long): ", 
                         signif(siteCoords[1],4), ",", signif(siteCoords[2],4),"</br>", collapse = "")
      sitePopup = paste0(sitePopup, "N. of birds: ", siteNumber,"</br>", collapse = "")
      sitePopup = paste0(sitePopup, "Date: ", siteDate,"</p>", collapse = "")
      stateMap$marker(siteCoords, bindPopup = sitePopup)
    }    
  }
  stateMap$save("fig/stateMap.html", cdn=TRUE)
  return(stateMap)
} 

shinyServer(function(input, output, session){
  
  speciesSelReactive = reactive({as.character(input$speciesSel)})
  
  output$stateSummary = renderText({
    stateCode = states$code[which(states$name == input$stateSel)]
    speciesSel = birdSpecies$sciName[which(birdSpecies$comName == speciesSelReactive() )]    
    stateData = getData(stateCode, 
                        species= birdSpecies$sciName[which(birdSpecies$comName == speciesSelReactive() )], 
                          input$daysSel)
    (topSite = which.max(stateData$howMany))    
    
    
    paste0("You have selected: ", speciesSelReactive(), ". The total number of observations reported in the last ",input$daysSel, 
            " days for ", input$stateSel, " is ", sum(stateData$howMany, na.rm = TRUE),".",
           collapse = "")
  })
  
output$birdPic <- renderImage(deleteFile = FALSE, {
  if (speciesSelReactive() == 'Snow goose') {
    return(list(
      src = "img/SnowGoose.jpg",
      contentType = "image/jpeg",
      alt = "Snow Goose"
    ))
  } else if (speciesSelReactive() == 'Sandhill Crane') {
    return(list(
      src = "img/SandhillCrane.jpg",
      contentType = "image/jpeg",
      alt = "Sandhill Crane"
    ))
  } else if (speciesSelReactive() == 'Common Goldeneye') {
    return(list(
      src = "img/Goldeneye.jpg",
      contentType = "image/jpeg",
      alt = "Common Goldeneye"
    ))
  } else if (speciesSelReactive() == 'Mallard') {
    return(list(
      src = "img/Mallard.jpg",
      filetype = "image/jpeg",
      alt = "Mallard"
    ))
  }
})
  
  output$map_container <- renderMap({
    stateCode = states$code[which(states$name == input$stateSel)]
    speciesSel = birdSpecies$sciName[which(birdSpecies$comName == speciesSelReactive() )]
    plotMap(stateCode, speciesSel, daysBack= as.numeric(input$daysSel))
  })
})
