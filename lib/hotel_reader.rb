class HotelReader

  # Set limits here
  LIMIT_PER_MINUTE = 500
  LIMIT_PER_DAY = 10000

  attr_accessor :factual

  def initialize(factual_keys = "factualkeys.yml")
    # fields we need in our file
    @fields_to_select = ['factual_id', 'name', 'locality', 'region', 'postcode', 'country', 'address', 'room_count'].join(", ")
    #load the keys
    begin
      factual_keys = YAML.load_file(factual_keys)
    rescue => err
      puts "Exception: #{err}"
      exit 1
    end
    f_key = factual_keys['F_KEY']
    f_secret = factual_keys['F_SECRET']
    @factual = Factual.new(f_key, f_secret)
  end

  def run(output_file, zipcode_file, checked_zip_file)
    begin
      # if output file exists we need to append to it
      if File.exist?(output_file)
        # get total count of records minus 1 because  because we do not want to count the headers
        rec_count = CSV.read(output_file).length - 1
        csv = CSV.open(output_file, "a+")
      else
        # default settings when doing a fresh file session
        rec_count = 0
        csv = CSV.open(output_file, "w") 
        # write the headers
        csv << ['company', 'address', 'city', 'state', 'zip code', 'country', 'room count', 'phone number', 'email']
      end

      # Read in zip code file
      if !File.exist?(zipcode_file)
        puts "Zip code file is missing. Please create a file with all the zip codes of different hotels you want to search through"
        exit 1
      end

      hotel_count = rec_count
      File.open(zipcode_file, "r") do |f|
        f.each_line do |zipcode|
          # get rid of new line
          zipcode = zipcode.chomp

          # Check if this zipcode has already been cycled
          if File.exists?(checked_zip_file) && File.readlines(checked_zip_file).grep(/\b#{zipcode}\b/).any?
            print "#{zipcode} has already been checked... skipping\n"
            next
          else
            print "#{zipcode} is a brand new zip code.. getting all the hotels\n"
            File.open(checked_zip_file, 'a+') {|file| file.write(zipcode + "\n") }
          end

          # find out how many hotels in specific area code
          number_of_hotels = @factual.table("hotels-us").select(@fields_to_select).filters("postcode" => {"$includes" => zipcode}).include_count("true").total_count

          puts "Zipcode: #{zipcode} has #{number_of_hotels} hotels"
          # if no hotels, go to the next record
          next if number_of_hotels == 0
          # For each zip code extract the hotels
          info = @factual.table("hotels-us").select(@fields_to_select).filters("postcode" => {"$includes" => zipcode}).rows
          info.each do |row|
            
            # for each row we also need to get the hotel's phone number which is not present in original query
            info = factual.table("places").filters("factual_id" => row['factual_id']).rows
            # get factual id's phone information and email
            tel_number = info[0]['tel']
            email = info[0]['email']

            # Record the record only if it doesn't exist in our output file yet
            if !File.readlines(output_file).grep(/\b#{row['address']}\b/).any?
              csv << [row['name'], row['address'], row['locality'], row['region'], row['postcode'], row['country'], row['room_count'], tel_number, email]
              hotel_count = hotel_count + 1
            else
              print "\nThis hotel already exists in our hotel data.. Skipping it..\n"
            end
          end

          # sleep for one minute if we are hitting the minute limit
          puts "reached the minute limit - sleeping for 60 seconds..." if hotel_count % LIMIT_PER_MINUTE  == 0
          sleep(60) if hotel_count % LIMIT_PER_MINUTE  == 0

          # sleep for one day if we are hitting the day limit
          puts "reached the minute limit - sleeping for 86400 seconds aka 24 hours..." if hotel_count % LIMIT_PER_DAY  == 0
          sleep(86400) if hotel_count % LIMIT_PER_DAY  == 0
        end
      end

      # Close all the file buffers
      csv.close

      puts "Total hotels extracted by zipcode: #{hotel_count}"
    rescue => err
      puts "Exception: #{err}"
      puts "\nThere is some kind of exception error - Let's pause for 1 hour and then keep trying.. until script is completed or terminated"
      sleep(3600)
      retry
    end
  end

  def get_hotel_total_count
    # get total count
    info = @factual.table("hotels-us").select(@fields_to_select).include_count("true")
    @total_hotels = info.total_count
  end


  # If specific gem is not installed, this function will install it on the machine
  def self.load_gem(name, version=nil)
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
end 
