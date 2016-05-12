require 'json'
require 'haversine'

def calculate_euclidean_distance_matrix(locations_json, locations_dd_matrix_json)
	locations = JSON.parse(File.read(locations_json))
	matrix 		= JSON.parse(File.read(locations_dd_matrix_json))

	matrix.each do |value|
		from 	= locations.select{|i| i['id'] == value['from_id'] }.first
		to 		= locations.select{|i| i['id'] == value['to_id'] }.first
		if from.nil? or to.nil?
			puts value.inspect
		else
			# X(latitude), Y(longitude)
			loc1 = from['lattitude'].to_f, from['longitude'].to_f
			loc2 = to['lattitude'].to_f, to['longitude'].to_f
			value['euclidean_distance'] = Haversine.distance(loc1, loc2).to_km
		end
	end

	File.open(locations_dd_matrix_json, 'w') do |f|
		f.write JSON.pretty_generate(matrix)
	end
end

if __FILE__ == $0
	if ARGV.length == 1
		locations_json = "./data/#{ARGV[0]}.json"
		locations_dd_matrix_json = "./data/#{ARGV[0]}-dd-matrix.json"
		calculate_euclidean_distance_matrix locations_json, locations_dd_matrix_json
	else
		puts 'You should enter yml file name existing in data directory'
	end
end