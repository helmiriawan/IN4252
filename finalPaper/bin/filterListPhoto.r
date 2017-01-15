#!/usr/bin/R
# helmiriawan@student.tudelft.nl
#



# Load data from csv file
listPhoto = read.csv("csvDir/listPhoto.csv")

# Remove duplicate nsid
filteredListPhoto = aggregate(photoId ~ nsid, data = listPhoto, max)
filteredListPhoto = filteredListPhoto[, c(2,1)]

# Export to csv file
write.csv(filteredListPhoto, file = "csvDir/listPhoto.csv", row.names = FALSE, quote = FALSE)
