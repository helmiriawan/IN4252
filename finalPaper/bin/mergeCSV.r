#!/usr/bin/R
# helmiriawan@student.tudelft.nl
#


# Retrieve the data from CSV file
photoDat = read.csv("csvDir/photo.csv")
faveDat = read.csv("csvDir/fave.csv")
peopleDat = read.csv("csvDir/people.csv")
contactDat = read.csv("csvDir/contact.csv")
followerDat = read.csv("csvDir/follower.csv")
contextDat = read.csv("csvDir/context.csv")
exifDat = read.csv("csvDir/exif.csv")

# Merge data
mergedDat = merge(x = photoDat, y = peopleDat, by = "nsid", all.x = TRUE)
mergedDat = merge(x = mergedDat, y = followerDat, by = "nsid", all.x = TRUE)
mergedDat = merge(x = mergedDat, y = contactDat, by = "nsid", all.x = TRUE)
mergedDat = merge(x = mergedDat, y = contextDat, by = "photoId", all.x = TRUE)
mergedDat = merge(x = mergedDat, y = exifDat, by = "photoId", all.x = TRUE)
mergedDat = merge(x = mergedDat, y = faveDat, by = "photoId", all.x = TRUE)

# Export to csv file
write.csv(mergedDat, file = "csvDir/merged.csv", row.names = FALSE, quote = FALSE)
