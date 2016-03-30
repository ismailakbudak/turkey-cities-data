require 'json'

cities_json = "./data/cities.json"
matrix_json = "./data/matrix.json"

file = File.read(cities_json)
cities = JSON.parse(file)

matrix = []
cities.each do |city|

	root = "./data/paths/all-#{city['id']}"
	
	val = { "from_name": city["name"], "to_name": city["name"], "from_id": city["id"], "to_id": city["id"], "distance": 0, "duration": 0 }	
	matrix << val

	cities.select{|i| i["id"] > city["id"] }.each do |city_in|

		first = "#{city['lattitude']},#{city['longitude']}"
		second = "#{city_in['lattitude']},#{city_in['longitude']}"

        file_name = "#{root}/cities-#{city['id']}-#{city_in['id']}.json"
		file = File.read(file_name)
		routes = JSON.parse(file)
		
		puts distance = routes[0]["legs"][0]["distance"]["value"]
		puts duration = routes[0]["legs"][0]["duration"]["value"]
		
		val = { "from_name": city["name"], "to_name": city_in["name"], "from_id": city["id"], "to_id": city_in["id"], "distance": distance, "duration": duration }
		matrix << val
	
		val = { "from_name": city_in["name"], "to_name": city["name"], "from_id": city_in["id"], "to_id": city["id"], "distance": distance, "duration": duration }
		matrix << val
	
		puts '.'
	end
end		

File.open(matrix_json, 'ab+') do |f| 
	f.write JSON.pretty_generate(matrix)
end