# Factual API Hotel Data Tool
A tool that runs Factuals API (you can find their key on their website, it costs $1) 
and pulls the data from all Hotels and Motels in their system. 
There are 148,000 hotels, and they have a limit of 500 per minute, and 10,000 per day. 
This tool generates all 167,344 or so hotels in in one csv, 
extracting the data 1 chunk at a time incrementally, appending them to the csv file 
and pausing properly so it doesn't go over the minute and day limit. 

You have to provide output csv file and intput zip code file

## API LINK
http://developer.factual.com/


# How it works

## Step 1
Make sure you create *factualkeys.yml* file in the main directory that has the following variables

```
F_KEY: "YourKeyHere"
F_SECRET: "YourSecretHere"
```

## Step 2
To run the script and have it output data into default *hotels.csv* and read zipcodes from default **zipcodes.txt** just run
```
ruby main.rb
```

To run the script with a custom output file and/or custom zipcodes file just pass the arguments like below
```
ruby main.rb custom_name.csv zipcodes.txt
```

## BONUS Functionality - Able to pause and pick up where it left off in case there are any interruptions. 
Just hit CTRL + C to pause/stop the script

After you run the **ruby main.rb** with the same output file name, it will pick up where it left off

# Sample Output Data

```
company,address,city,state,zip code,country,room count,phone number,email
Agawam Motor Lodge,23 Suffield St,Agawam,MA,01001,us,,(413) 786-2800,
Your Love Our Touch,525 Springfield,Agawam,MA,01001,us,,(413) 306-3150,
Allen House Victorian Inn,599 Main St,Amherst,MA,01002,us,,(413) 253-5000,alan@allenhouse.com
Black Walnut Inn,1184 N Pleasant St,Amherst,MA,01002,us,,(413) 549-5649,danb@blackwalnutinn.com
Lord Jeffery Inn,30 Boltwood Ave,Amherst,MA,01002,us,,(413) 253-2576,gboyd@waterfordhotelgroup.com
Amherst Motel,408 Northampton Rd,Amherst,MA,01002,us,,(413) 256-8122,galefrench@charter.net
University Lodge,345 N Pleasant St,Amherst,MA,01002,us,20,(413) 256-8111,booking@hotels.com
Delta Organic Farm Bed and Breakfast,352 E Hadley Rd,Amherst,MA,01002,us,,(413) 253-1893,delta@amherstonline.com
Amherst Inn,257 Main St,Amherst,MA,01002,us,,(413) 253-5000,allenhouse@webtv.net
Emily's Amherst Bed & Breakfast,71 N Prospect St,Amherst,MA,01002,us,,(413) 549-0733,
Horace Kellogg Homestead Bed & Breakfast,459 S Pleasant St,Amherst,MA,01002,us,,,
Hop Brook Bed & Breakfast,15 Hop Brook Rd,Amherst,MA,01002,us,,(413) 253-1448,
Birdsong Bed & Breakfast of Amherst,815 S East St,Amherst,MA,01002,us,,(413) 256-0433,birdsongbb@comcast.net
Stone House Farm,649 E Pleasant St,Amherst,MA,01002,us,,(413) 549-4455,
Purple Gables Bed & Breakfast,232 E Pleasant St,Amherst,MA,01002,us,,(413) 549-0705,innkeeper@purplegables.com
```


# Zipcode file
**zipcodes.txt** is included but you can have your own custom zipcode file with zipcodes
