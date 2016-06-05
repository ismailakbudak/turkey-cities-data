require 'json'
require 'yaml'
require 'geokit'
require './config/secrets'


def find file_yml, file_json
  Geokit::Geocoders::GoogleGeocoder.api_key = Config::SECRETS[:google_api_key]

  locations = YAML.load_file( file_yml )
  locations.each do |location|
    geocode 				        = Geokit::Geocoders::GoogleGeocoder.geocode "#{location['name']}"
    latitude, longitude 	  = geocode.ll.split(',')
    location['lattitude'] 	= latitude
    location['longitude'] 	= longitude
    puts '.'
  end

  File.open(file_json, 'w') do |f|
    f.write JSON.pretty_generate(locations)
  end
end

if __FILE__ == $0
  if ARGV.length == 1
    file_json = "./data/#{ARGV[0]}.json"
    file_yml = "./data/#{ARGV[0]}.yml"
    find file_yml, file_json
  else
    puts 'You should enter yml file name existing in data directory'
  end
end