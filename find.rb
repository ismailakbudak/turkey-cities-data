require 'json'
require 'yaml'
require 'geokit'
require "./config/secrets"

cities_json = "./data/cities.json"
cities_yml =  "./data/cities.yml"

Geokit::Geocoders::GoogleGeocoder.api_key = Config::SECRETS[:google_api_key]

cities = YAML.load_file( cities_yml )
cities.each do |city|
  geocode 				= Geokit::Geocoders::GoogleGeocoder.geocode "#{city['name']}, Türkiye"
  latitude, longitude 	= geocode.ll.split(',')
  city['lattitude'] 	= latitude
  city["longitude"] 	= longitude
end

File.open(cities_json, 'w') do |f| 
	f.write JSON.pretty_generate(cities)
end
