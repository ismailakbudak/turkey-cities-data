require 'json'
require 'google_maps_service'
require "./config/secrets"

gmaps = GoogleMapsService::Client.new(key: Config::SECRETS[:google_api_key] )

cities_json = "./data/cities.json" 

file = File.read(cities_json)
cities = JSON.parse(file)

cities.select{|c| c["id"] >= 0 and c["id"] <= 81 }.each do |city|

	root = "./data/paths/all-#{city['id']}"
	Dir.mkdir root

	cities.select{|i| i["id"] > city["id"] }.each do |city_in|
		first = "#{city['lattitude']},#{city['longitude']}"
		second = "#{city_in['lattitude']},#{city_in['longitude']}"

		routes = gmaps.directions( first, second, mode: 'driving', alternatives: false)

		File.open("#{root}/cities-#{city['id']}-#{city_in['id']}.json", 'ab+') do |f| 
			f.write JSON.pretty_generate(routes)
		end

		File.open("#{root}/cities-#{city_in['id']}-#{city['id']}.json", 'ab+') do |f| 
			f.write JSON.pretty_generate(routes)
		end
		puts '.'
	end  
end		
 