# loads automatically because it's part of ruby library
require 'yaml'
require 'csv'
require 'fileutils'

require_relative 'lib/hotel_reader.rb'

# install and load factual api gem if it's missing
HotelReader.load_gem 'factual-api'

# Get the filename  we wish to write the data to
output_file = ARGV[0].to_s
zipcode_file = ARGV[1].to_s

# tmp file to keep track of cycled zipcodes 
checked_zip_file = 'checked_zip_file.txt'

if output_file.nil? || output_file.empty?
  #if empty, use default hotels.csv
  output_file = "hotels.csv"
end

if zipcode_file.nil? || zipcode_file.empty?
  #if empty, use default hotels.csv
  zipcode_file = "zipcodes.txt"
end


hotel_reader = HotelReader.new
hotel_reader.run(output_file, zipcode_file, checked_zip_file)

# Get total count in factual database
total_hotels = hotel_reader.get_hotel_total_count
p "Total number of hotels in factual database: " +  total_hotels.to_s


