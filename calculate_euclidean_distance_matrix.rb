require 'json'

cities_json = "./data/cities.json"
matrix_json = "./data/matrix.json"

cities = JSON.parse(File.read(cities_json))
matrix = JSON.parse(File.read(matrix_json))


matrix.each do |value|
	from = cities.select{|i| i["id"] == value["from_id"] }.first
	to = cities.select{|i| i["id"] == value["to_id"] }.first
	if from.nil? or to.nil?
		puts value.inspect
	else
		x = (from["lattitude"].to_f - to["lattitude"].to_f) ** 2
		y = (from["longitude"].to_f - to["longitude"].to_f) ** 2 
		euclidean_distance = Math.sqrt( x + y )
		value["euclidean_distance"] = euclidean_distance
	end
end


File.open(matrix_json, 'w') do |f| 
	f.write JSON.pretty_generate(matrix)
end