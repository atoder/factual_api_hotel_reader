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

## BONUS Functionality - Able to pause and pick up where it left off in case there are any interruptions. 
Just hit CTRL + C to pause/stop the script

After you run the **ruby main.rb** with the same output file name, it will pick up where it left off

# Sample Output Data

```
Company,Address,City,State,Phone Number,Zip Code,Country
The Mirage Hotel & Casino,3400 Las Vegas Blvd S,Las Vegas,NV,(702) 791-7111,89109,us
Planet Hollywood Resort and Casino,3667 Las Vegas Blvd S,Las Vegas,NV,(866) 919-7472,89109,us
Flamingo Las Vegas,3555 Las Vegas Blvd S,Las Vegas,NV,(702) 733-3111,89109,us
DoubleTree Suites by Hilton Hotel New York City - Times Square,1568 Broadway,New York,NY,(212) 719-1600,10036,us
New York - New York Hotel and Casino,3790 Las Vegas Blvd S,Las Vegas,NV,(702) 740-6969,89109,us
Golden Nugget Hotel & Casino,129 Fremont St,Las Vegas,NV,(702) 385-7111,89101,us
Fontainebleau Miami Beach,4441 Collins Ave,Miami Beach,FL,(305) 538-2000,33140,us
The Orleans Hotel & Casino,4500 W Tropicana Ave,Las Vegas,NV,(702) 365-7111,89103,us
The Waldorf Astoria,301 Park Ave,New York,NY,(212) 355-3000,10022,us
Harrah's Las Vegas,3475 Las Vegas Blvd S,Las Vegas,NV,(702) 369-5000,89109,us
Tropicana Casino & Resort,2831 Boardwalk,Atlantic City,NJ,(609) 340-4000,08401,us
Hilton Austin,500 E 4th St,Austin,TX,(512) 482-8000,78701,us
Hudson Hotel,356 W 58th St,New York,NY,(212) 554-6000,10019,us
Grand Hyatt New York,109 E 42nd St,New York,NY,(212) 883-1234,10017,us
Hotel Pennsylvania,401 7th Ave,New York,NY,(212) 736-5000,10001,us
Yotel,570 10th Ave,New York,NY,(646) 449-7700,10036,us
Vdara Hotel & Spa,2600 W Harmon Ave,Las Vegas,NV,(702) 590-2111,89158,us
Harrah's Resort Atlantic City,777 Harrahs Blvd,Atlantic City,NJ,(609) 441-5000,08401,us
DoubleTree by Hilton Hotel Metropolitan - New York City,569 Lexington Ave,New York,NY,(212) 752-7000,10022,us
W New York,541 Lexington Ave,New York,NY,(212) 755-1200,10022,us
The New Yorker Hotel,481 8th Ave,New York,NY,(212) 971-0101,10001,us
Caesars Atlantic City,2100 Pacific Ave,Atlantic City,NJ,(609) 348-4411,08401,us
The Westin New York at Times Square,270 W 43rd St,New York,NY,(212) 201-2700,10036,us
W New York - Times Square,1567 Broadway,New York,NY,(212) 930-7400,10036,us
The Roosevelt Hotel,45 E 45th St,New York,NY,(212) 661-9600,10017,us
InterContinental New York Times Square,300 W 44th St,New York,NY,(212) 803-4500,10036,us
Park Central New York,870 7th Ave,New York,NY,(212) 247-8000,10019,us
Hotel del Coronado,1500 Orange Ave,Coronado,CA,(619) 435-6611,92118,us
The Cosmopolitan of Las Vegas,3708 Las Vegas Blvd S,Las Vegas,NV,(702) 698-7000,89109,us
Excalibur Hotel and Casino,3850 Las Vegas Blvd S,Las Vegas,NV,(702) 597-7777,89109,us
Trump Taj Mahal Casino Resort,1000 Boardwalk,Atlantic City,NJ,(609) 449-1000,08401,us
The Manhattan at Times Square Hotel,790 7th Ave,New York,NY,(212) 581-3300,10019,us
W San Francisco,181 3rd St,San Francisco,CA,(415) 777-5300,94103,us
Fairfield Inn Rochester Airport,1200 Brooks Ave,Rochester,NY,(585) 529-5000,14624,us
Tropicana Las Vegas,3801 Las Vegas Blvd S,Las Vegas,NV,(702) 739-2222,89109,us
Sheraton Chicago Hotel & Towers,301 E North Water St,Chicago,IL,(312) 464-1000,60611,us
Chicago Marriott Downtown Magnificent Mile,540 N Michigan Ave,Chicago,IL,(312) 836-0100,60611,us
Fairmont Hotel,950 Mason St,San Francisco,CA,(415) 982-6500,94108,us
```
