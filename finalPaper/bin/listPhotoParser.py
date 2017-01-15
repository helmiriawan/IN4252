from __future__ import print_function
import json
import glob
import sys


# Get input file
inputFile = sys.argv[1]

# Print header
print("photoId,nsid")

# Get list of JSON file for photos
listFiles = glob.glob(inputFile)

# Parse all the JSON files
for x in listFiles:
	with open(x) as data_file:
		data = json.load(data_file)
	
	# Get list of photos from the JSON file
	listFiles = data["photos"]["photo"]
	
	for x in listFiles:
		# Get the variables
		photoId = x["id"]
		nsid = x["owner"]
	
		# Print variables
		print(str(photoId), str(nsid), sep=',')
