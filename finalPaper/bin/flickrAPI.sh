#!/bin/bash
# helmiriawan@student.tudelft.nl
#



## Configuration ##


# Time period
hFormat=`date -ud"1 week ago" | cut -c1-10`
hUploadDateMax="$hFormat 23:49:59 UTC 2017"
hUploadDateMin="$hFormat 00:00:01 UTC 2017"
uploadDateMax=`date +%s -ud "$hUploadDateMax"`
uploadDateMin=`date +%s -ud "$hUploadDateMin"`


# Number of photos
per_page=200
nMultiplier=100
nPhotos=$((per_page*nMultiplier))

# API key - PUT YOUR API KEY HERE!
apiKey=""



# Time check
echo; echo `date +%Y.%m.%d\ %H:%M:%S`  "Start running the script"; echo; 
startTime=`date +%s`



## Directory check ##
for i in jsonDir csvDir htmlDir; do	
	if [ ! -d $i ]; then
		echo `date +%Y.%m.%d\ %H:%M:%S`  "No $i directory, creating directory..."
		mkdir $i
	fi
done



## Main script ##


# Get list of photos
printf "\n\n"; echo `date +%Y.%m.%d\ %H:%M:%S`  "Getting list of photos"
echo "############################################################################################"; echo
counter=1;
while [ $counter -le $nMultiplier ]; do
	tTime=`shuf -i $uploadDateMin-$uploadDateMax -n 1`
	curl https://api.flickr.com/services/rest/ -d method=flickr.photos.search -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d min_upload_date=$uploadDateMin -d max_upload_date=$tTime -d per_page=$per_page -d page=1 | python -m json.tool > jsonDir/listPhoto$counter.json
	counter=$((counter+1));
done
python listPhotoParser.py jsonDir/listPhoto'*'json > csvDir/listPhoto.csv
Rscript filterListPhoto.r



# Get json files based on photo ID
printf "\n\n"; echo `date +%Y.%m.%d\ %H:%M:%S`  "Getting json files based on photo ID"
echo "############################################################################################"; echo
for i in `awk 'NR > 1 { print }' csvDir/listPhoto.csv | awk -F"," '{print $1}'`; 
	do curl https://api.flickr.com/services/rest/ -d method=flickr.photos.getInfo -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d photo_id=$i | python -m json.tool > jsonDir/photo$i.json
	curl https://api.flickr.com/services/rest/ -d method=flickr.photos.getFavorites -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d photo_id=$i | python -m json.tool > jsonDir/fave$i.json
	curl https://api.flickr.com/services/rest/ -d method=flickr.photos.getAllContexts -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d photo_id=$i | python -m json.tool > jsonDir/context$i.json
	curl https://api.flickr.com/services/rest/ -d method=flickr.photos.getExif -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d photo_id=$i | python -m json.tool > jsonDir/exif$i.json
done


# Get json and html files based on nsid
printf "\n\n"; echo `date +%Y.%m.%d\ %H:%M:%S`  "Getting json files based on nsid"
echo "############################################################################################"; echo
for i in `awk 'NR > 1 { print }' csvDir/listPhoto.csv | awk -F"," '{print $2}' | sort -u`; 
	do curl https://api.flickr.com/services/rest/ -d method=flickr.people.getInfo -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d user_id=$i | python -m json.tool > jsonDir/people$i.json
	curl https://api.flickr.com/services/rest/ -d method=flickr.contacts.getPublicList -d api_key=$apiKey -d format=json -d nojsoncallback=1 -d user_id=$i | python -m json.tool > jsonDir/contact$i.json
	curl https://www.flickr.com/photos/$i/ > htmlDir/follower$i.html
done



# Time check

endTime=`date +%s`
diffTime=$((endTime - startTime))
diffTimeMin=$((diffTime/60))
printf "\n\n"; echo `date +%Y.%m.%d\ %H:%M:%S`  "Finished in "$diffTimeMin" minutes"; echo;