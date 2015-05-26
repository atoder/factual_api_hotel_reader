# Factual API Hotel Data Tool
A tool that runs Factuals API (you can find their key on their website, it costs $1) 
and pulls the data from all Hotels and Motels in their system. 
There are 148,000 hotels, and they have a limit of 500 per minute, and 10,000 per day. 
This tool generates all 167,344 or so hotels in in one csv, 
extracting the data 1 chunk at a time incrementally, appending them to the csv file 
and pausing properly so it doesn't go over the minute and day limit


# How it works

## Step 1
Make sure you create *factualkeys.yml* file in the main directory that has the following variables

```
F_KEY: "YourKeyHere"
F_SECRET: "YourSecretHere"
```

### IMPORTANT INFO 
Factual API only allows you to have 500 Row Limit. Meaning beyond 500 offset, 
it won't allow you to access the data unless you ask them to give you access/premium API

## Step 2
To run the script and have it output data into default *hotels.csv* just run
```
ruby main.rb
```

To run the script with a custom output file just pass the argument like below
```
ruby main.rb custom_name.csv
```

## BONUS -  Functionality be be able to pause and pick up where it left off that would be great in case there is any interruptions. 
Just hit CTRL + C to pause/stop the script
After you run the **main.rb** with the same file name, it will pick up where it left off





