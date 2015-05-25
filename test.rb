F_KEY = "MMWKyQISyex0ODYyxpgjSefn5xzfeGV6ssWtWJZq"
F_SECRET = "Yor44nLoueNMlXXRQ1cKm1TjeZZF0b22LdByMtXb"

# If specific gem is not installed, # this function will install it on the machine
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
  # Special require case for factual gem
  require 'factual' if name == 'factual-api'
  require name if name != 'factual-api'

end

# load all needed gems
#load_gem 'httparty'
load_gem 'factual-api'


factual = Factual.new(F_KEY, F_SECRET)

# Get total count
info = factual.table("hotels-us").select("factual_id", "name", "locality", "region", "postcode", "country").include_count("true")
total_hotels = info.total_count
p total_hotels



#info = factual.table("hotels-us").select("factual_id", "name", "locality", "region", "postcode", "country").limit(5)
#puts info.rows

