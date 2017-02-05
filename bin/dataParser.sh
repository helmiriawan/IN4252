#!/bin/bash
# ====================================================================
# dataParser
# helmiriawan@student.tudelft.nl
#
# Purpose:
# To parse the data from JSON and HTML files
# 
# Notes:
# Run the flickrAPI.sh before this script
#


# Time check
echo; echo `date +%Y.%m.%d\ %H:%M:%S`  "Start running the script"; echo; 
startTime=`date +%s`



## Main script ##


# Get variables from json files, export to csv files
echo `date +%Y.%m.%d\ %H:%M:%S`  "Parsing variables from json files"; echo; 
python variablesParser.py


# Get variables from html files, export to csv files
echo `date +%Y.%m.%d\ %H:%M:%S`  "Parsing variables from html files"; echo; 
echo "nsid,nFollowers" > csvDir/follower.csv
for i in `ls htmlDir/follower*html`;
	do nsid=`echo $i | awk -F"follower" '{print $2}' | awk -F"." '{print $1}'`;
	
	# Get the number of followers
	nFollowers="$(grep -o '<p class="followers truncate">.*</p>' $i  | sed 's/\(<p class="followers truncate">\|<\/tr>\)//g' | awk '{print $1}')";
	lastChar=`echo ${nFollowers: -1}`
	
	# Change the format of truncated number
	if [ $lastChar == "k" ]; then
		removeK=`echo "${nFollowers::-1}"`
		multNum=`echo $removeK \* 1000 | bc`
		nFollowers=`echo ${multNum%.*}`
	fi
	
	# Export to csv
	echo $nsid,$nFollowers >> csvDir/follower.csv;
done


# Merge the csv files
echo `date +%Y.%m.%d\ %H:%M:%S`  "Merging csv files"; echo; 
Rscript mergeCSV.r


# Time check

endTime=`date +%s`
diffTime=$((endTime - startTime))
diffTimeMin=$((diffTime/60))
echo `date +%Y.%m.%d\ %H:%M:%S`  "Finished in "$diffTimeMin" minutes"; echo;