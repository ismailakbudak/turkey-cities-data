require 'json'

cities_json = "./data/cities.json"

file = File.read(cities_json)
cities = JSON.parse(file)

index = 1
cities.each do |city|
  city['id'] = index
  index += 1 
end

File.open(cities_json, 'w') do |f| 
	f.write JSON.pretty_generate(cities)
end
