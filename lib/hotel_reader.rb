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

  def run(ouput_file, zipcode_file)
    begin
      # one record at the time
      limit = 1

      # if file exists we need to point to proper offset and beyond what we already wrote to the file
      if File.exist?(ouput_file)
        # get total count of records minus 1 because  because we do not want to count the headers
        offset = CSV.read(ouput_file).length - 1
        csv = CSV.open(ouput_file, "a+") 
      else
        # default settings when doing a fresh file session
        offset = 0
        csv = CSV.open(ouput_file, "w") 
        # write the headers
        csv << ['company', 'address', 'city', 'state', 'zip code', 'country', 'room count', 'phone number', 'email']
      end

      info = @factual.table("hotels-us").select(@fields_to_select).filters("postcode" => {"$includes" => 94118})
      puts info.rows

      exit 1

      info = @factual.table("hotels-us").select(@fields_to_select).offset(offset).limit(limit)

      # keep going until we get all the records
      while @total_hotels > offset
        info.rows.each do |row|
          # for each row we also need to get the hotel's phone number which is not present in original query
          info = factual.table("places").filters("factual_id" => row['factual_id']).rows
          # get factual id's phone information and email
          tel_number = info[0]['tel']
          email = info[0]['email']
          csv << [row['name'], row['address'], row['locality'], row['region'], row['postcode'], row['country'], row['room_count'], tel_number, email]
        end

        offset = offset + limit
        # sleep for one minute if we are hitting the minute limit
        puts "reached the minute limit - sleeping for 60 seconds..." if offset % LIMIT_PER_MINUTE  == 0
        sleep(60) if offset % LIMIT_PER_MINUTE  == 0

        # sleep for one day if we are hitting the day limit
        puts "reached the minute limit - sleeping for 86400 seconds aka 24 hours..." if offset % LIMIT_PER_DAY  == 0
        sleep(86400) if offset % LIMIT_PER_DAY  == 0

        # get next record
        info = @factual.table("hotels-us").select(@fields_to_select).offset(offset).limit(limit)
      end

    rescue => err
      puts "Exception: #{err}"
      puts "\nGoing to keep retrying every 60 seconds.. until script is completed or terminated"
      sleep(60)
      retry
    end
  end

  def get_hotel_total_count
    # get total count
    info = @factual.table("hotels-us").select(@fields_to_select).include_count("true")
    @total_hotels = info.total_count
  end


  # if specific gem is not installed, this function will install it on the machine
  def self.load_gem(name, version=nil)
    # needed if your ruby version is less than 1.9
    require 'rubygems'
    begin
      gem name, version
    rescue loaderror
      version = "--version '#{version}'" unless version.nil?
      system("gem install #{name} #{version}")
      gem.clear_paths
      retry
    end
    # load proper gems
    require name if name != 'factual-api'
    # special require case for factual gem
    require 'factual' if name == 'factual-api'
  end
end
