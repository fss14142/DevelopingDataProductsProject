states = read.table(file="usStates.csv", header = TRUE, sep=" ", as.is = TRUE)

birdSpecies = data.frame(stringsAsFactors = FALSE, 
                         sciName = c('Chen%20caerulescens', 'Grus%20canadensis', 
                                     'Bucephala%20clangula','anas%20platyrhynchos'),
                         comName = c('Snow goose', 'Sandhill Crane', 
                                     'Common Goldeneye','Mallard')
)