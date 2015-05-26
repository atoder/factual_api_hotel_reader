# Set limits here
LIMIT_PER_MINUTE = 5
LIMIT_PER_DAY = 10

# If specific gem is not installed, this function will install it on the machine
def load_gem(name, version=nil)
  # needed if your ruby version is less than 1.9
  require 'rubygems'

  begin
    gem name, version
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{name} #{version}")
    Gem.clear_paths
    retry
  end

  # Load proper gems
  require name if name != 'factual-api'
  # Special require case for factual gem
  require 'factual' if name == 'factual-api'

end

# Get the filename  we wish to write the data to
file_name = ARGV[0].to_s

if file_name.nil? || file_name.empty?
  #if empty, use default hotels.csv
  file_name = "hotels.csv"
end

# install and load all needed gems
load_gem 'factual-api'

# loads automatically because it's part of ruby library
require 'yaml'
require 'csv'

#load the keys
begin
  factual_keys = YAML.load_file('factualkeys.yml')
rescue => err
  puts "Exception: #{err}"
  exit 1
end

F_KEY = factual_keys['F_KEY']
F_SECRET = factual_keys['F_SECRET']
factual = Factual.new(F_KEY, F_SECRET)

# fields we need to select for our file
fields_to_select = ['factual_id', 'name', 'locality', 'region', 'postcode', 'country', 'address'].join(", ")

# Get total count
info = factual.table("hotels-us").select(fields_to_select).include_count("true")
total_hotels = info.total_count
p "Total number of hotels: " +  total_hotels.to_s

# One at the time
limit = 1

# If file exists we need to point to proper offset and  beyond what we already wrote to the file
if File.exist?(file_name)
  # Get total count of records minus 1 because 
  # because we do not want to count the headers
  offset = CSV.read(file_name).length - 1
  csv = CSV.open(file_name, "a+") 
else
  # Default settings when doing a fresh file session
  offset = 0
  csv = CSV.open(file_name, "w") 
  # Write the headers
  csv << ['Company', 'Address', 'City', 'State', 'Phone Number', 'Zip Code', 'Country']
end

info = factual.table("hotels-us").select(fields_to_select).offset(offset).limit(limit)

# keep going until we get all the records
while total_hotels > offset
  info.rows.each do |row|
    # For each row we also need to get the hotel's phone number which is not present in original query
    info = factual.table("places").filters("factual_id" => row['factual_id']).rows
    # get factual id's phone information
    tel_number = info[0]['tel']
    csv << [row['name'], row['address'], row['locality'], row['region'], tel_number, row['postcode'], row['country']]
  end

  offset = offset + limit
  # Sleep for one minute if we are hitting the minute limit
  puts "Reached the Minute Limit - Sleeping for 60 seconds..." if offset % LIMIT_PER_MINUTE  == 0
  sleep(60) if offset % LIMIT_PER_MINUTE  == 0

  # Sleep for one day if we are hitting the day limit
  puts "Reached the Minute Limit - Sleeping for 86400 seconds aka 24 hours..." if offset % LIMIT_PER_DAY  == 0
  sleep(86400) if offset % LIMIT_PER_DAY  == 0

  # Get next record
  info = factual.table("hotels-us").select(fields_to_select).offset(offset).limit(limit)
end
