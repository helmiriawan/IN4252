from __future__ import print_function
import json
import glob
import sys


#######################################
# Retrieve data from photo json files #
#######################################

# Print header
with open("csvDir/photo.csv", "a") as myfile:
	myfile.write("photoId,nsid,posted,photoUrl,nComments,nTags,nViews\n")

# Get list of photo json files
listFiles = glob.glob("jsonDir/photo*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)
		
	# Check if the json stat is ok
	jsonStat = data["stat"]
	if jsonStat == "ok":

		# Get the variables
		photoId = data["photo"]["id"]
		nsid = data["photo"]["owner"]["nsid"]
		nComments = data["photo"]["comments"]["_content"]
		nTags = len(data["photo"]["tags"]["tag"])
		photoUrl = data["photo"]["urls"]["url"][0]["_content"]
		posted = data["photo"]["dates"]["posted"]
		nViews = data["photo"]["views"]
		
		# Print variables
		with open("csvDir/photo.csv", "a") as myfile:
			myfile.write(str(photoId) + "," + str(nsid) + "," + str(posted) + "," + str(photoUrl) + "," + str(nComments) + "," + str(nTags) + "," + str(nViews) + "\n")


######################################
# Retrieve data from fave json files #
######################################

# Print header
with open("csvDir/fave.csv", "a") as myfile:
	myfile.write("photoId,nFaves\n")

# Get list of fave json files
listFiles = glob.glob("jsonDir/fave*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)

	# Check if the json stat is ok
	jsonStat = data["stat"]
	if jsonStat == "ok":

		# Get the variables
		photoId = data["photo"]["id"]
		nFaves = data["photo"]["total"]
		
		# Print variables
		with open("csvDir/fave.csv", "a") as myfile:
			myfile.write(str(photoId) + "," + str(nFaves) + "\n")


#########################################
# Retrieve data from context json files #
#########################################

# Print header
with open("csvDir/context.csv", "a") as myfile:
	myfile.write("photoId,nGroups,nAlbums\n")

# Get list of context json files
listFiles = glob.glob("jsonDir/context*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)

	# Check if the json stat is ok
	jsonStat = data["stat"]
	if jsonStat == "ok":

		# Get the variables
		fileName = x.split("context")[1]
		photoId = fileName.split(".")[0]
		if 'pool' in data:
			nGroups = len(data["pool"])
		else:
			nGroups = 0
		if 'set' in data:
			nAlbums = len(data["set"])
		else:
			nAlbums = 0
		
		# Print variables
		with open("csvDir/context.csv", "a") as myfile:
			myfile.write(str(photoId) + "," + str(nGroups) + "," + str(nAlbums) + "\n")


######################################
# Retrieve data from exif json files #
######################################

# Print header
with open("csvDir/exif.csv", "a") as myfile:
	myfile.write("photoId,camera\n")

# Get list of exif json files
listFiles = glob.glob("jsonDir/exif*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)

	# Get the variables
	fileName = x.split("exif")[1]
	photoId = fileName.split(".")[0]
	camera = "Unknown"
	if 'photo' in data:
		if 'camera' in data["photo"]:
			camera = data["photo"]["camera"].partition(' ')[0]
			if len(camera) == 0:
				camera = "Unknown"
	
	# Print variables
	with open("csvDir/exif.csv", "a") as myfile:
		myfile.write(str(photoId) + "," + str(camera) + "\n")


########################################
# Retrieve data from people json files #
########################################

# Print header
with open("csvDir/people.csv", "a") as myfile:
	myfile.write("nsid,nPhotos\n")

# Get list of people json files
listFiles = glob.glob("jsonDir/people*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)

	# Check if the json stat is ok
	jsonStat = data["stat"]
	if jsonStat == "ok":

		# Get the variables
		nsid = data["person"]["nsid"]
		nPhotos = data["person"]["photos"]["count"]["_content"]
		
		# Print variables
		with open("csvDir/people.csv", "a") as myfile:
			myfile.write(str(nsid) + "," + str(nPhotos) + "\n")


########################################
# Retrieve data from contact json files #
########################################

# Print header
with open("csvDir/contact.csv", "a") as myfile:
	myfile.write("nsid,nFollows\n")

# Get list of contact json files
listFiles = glob.glob("jsonDir/contact*json")

# Parse all the json files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)

	# Check if the json stat is ok
	jsonStat = data["stat"]
	if jsonStat == "ok":

		# Get the variables
		fileName = x.split("contact")[1]
		nsid = fileName.split(".")[0]
		nFollows = data["contacts"]["total"]
		
		# Print variables
		with open("csvDir/contact.csv", "a") as myfile:
			myfile.write(str(nsid) + "," + str(nFollows) + "\n")
