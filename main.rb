# loads automatically because it's part of ruby library
require 'yaml'
require 'csv'
require_relative 'lib/hotel_reader.rb'

# install and load factual api gem if it's missing
HotelReader.load_gem 'factual-api'

# Get the filename  we wish to write the data to
file_name = ARGV[0].to_s

if file_name.nil? || file_name.empty?
  #if empty, use default hotels.csv
  file_name = "hotels.csv"
end


hotel_reader = HotelReader.new

# Get total count
total_hotels = hotel_reader.get_hotel_total_count
p "Total number of hotels: " +  total_hotels.to_s

hotel_reader.run(file_name)


