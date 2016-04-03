require 'json'
 
matrix_json = "./data/matrix.json"
matrix = JSON.parse(File.read(matrix_json))

matrix.each do |value|
	distance = value["distance"].to_f
	euclidean_distance =  value["euclidean_distance"].to_f
	if distance == 0
		circuity_factor = 0
	else
		circuity_factor = distance / euclidean_distance
	end	
	value["circuity_factor"] = circuity_factor
end


File.open(matrix_json, 'w') do |f| 
	f.write JSON.pretty_generate(matrix)
end